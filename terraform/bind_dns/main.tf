resource "proxmox_lxc" "dns" {
  # LXC Container resource https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/lxc
  for_each = var.buildhosts

  ostype = "centos" # debian, devuan, ubuntu, centos, fedora, opensuse, archlinux, alpine, gentoo, unmanaged

  hostname    = each.value.hostname
  vmid        = each.value.vmid
  target_node = each.value.target_node
  #ostemplate  = each.value.clone_template
  clone        = each.value.lxc_templatte_id
  description  = each.value.description
  #nameserver   = each.value.ipv4
  #searchdomain = each.value.domain
  cores        = each.value.cores
  memory       = each.value.memory
  onboot       = each.value.autostart
  start        = each.value.autostart
  rootfs {
    storage = each.value.datastore
    size    = each.value.disk_size
  }
  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "${each.value.ipv4}/24"
    firewall = false
    gw       = each.value.gateway
    hwaddr   = each.value.macaddr

  }
  
  #ssh_public_keys = module.shared.common.ssh_pub_key
  # I get below error on enabling above line
  # ssh-public-keys":"property is not defined in schema and the schema does not allow additional properties
  # since LXC template was created with Public key, still keybased ssh works!
  password        = module.shared.secret.ssh_password # root password inside container
  unprivileged    = true

  provisioner "remote-exec" {
    inline = [
      "/usr/bin/hostnamectl set-hostname ${each.value.fqdn}",
      "/usr/bin/timedatectl set-timezone 'Asia/Singapore'",
      "dnf install -y openssh-server qemu-guest-agent",
      "/usr/bin/systemctl start sshd",
      "/usr/bin/systemctl enable sshd qemu-guest-agent",
      "reboot",
    ]
    on_failure = continue # applies only to the final command in the list
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(module.shared.common.private_key_file)
      host        = each.value.ipv4
    }
  }

  provisioner "local-exec" {
    command = "sleep 45"
  }

  provisioner "remote-exec" {
    inline = [
      # install Puppet agent 7 on AlmaLinux 8
      # https://puppet.com/docs/puppet/7/install_and_configure.html
      "dnf install -y https://yum.puppet.com/puppet7-release-el-8.noarch.rpm",
      "dnf install -y puppet-agent",
      "echo 192.168.10.60 puppet.family.net puppet >> /etc/hosts",
      "/opt/puppetlabs/bin/puppet config set server puppet.family.net --section main",
      "/opt/puppetlabs/bin/puppet config set server puppet.family.net --section agent",
      "/opt/puppetlabs/bin/puppet config set certname ${each.value.fqdn} --section agent",
      "/opt/puppetlabs/bin/puppet config set interval 30m --section agent",
      "/opt/puppetlabs/bin/puppet agent -tv",
      "reboot",
    ]
    on_failure = continue # applies only to the final command in the list
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(module.shared.common.private_key_file)
      host        = each.value.ipv4
    }
  }
}
