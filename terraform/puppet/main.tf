resource "proxmox_vm_qemu" "puppet_vm" {
  # Resource to create VM from VM Template https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
  for_each = var.buildhosts

  agent   = 1            # defaule is 0. Set to 1 to enable the QEMU Guest Agent. The qemu-guest-agent daemon sshould run in the guest for this to have any effect.
  os_type = "cloud-init" # ubuntu, centos or cloud-init

  name        = each.value.hostname
  desc        = each.value.description
  vmid        = each.value.vmid
  target_node = each.value.target_node
  clone       = each.value.clone_template
  cores       = each.value.cores
  sockets     = each.value.sockets
  memory      = each.value.memory
  onboot      = each.value.autostart
  disk {
    type    = "scsi"
    size    = each.value.disk_size
    storage = each.value.datastore
  }
  network {
    model    = "virtio"
    bridge   = "vmbr0"
    macaddr  = each.value.macaddr
    firewall = false
  }
  sshkeys = module.shared.common.ssh_pub_key

  cpu       = "host" # qemu host type - host, kvm64 - default to host
  scsihw    = "virtio-scsi-pci"
  bootdisk  = "scsi0"
  ipconfig0 = "ip=${each.value.ipv4}/24,gw=${each.value.gateway}"

  provisioner "remote-exec" {
    inline = [
      "/usr/bin/hostnamectl set-hostname ${each.value.fqdn}",
      "/usr/bin/timedatectl set-timezone 'Asia/Singapore'",
      "/usr/bin/systemctl disable firewalld",
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
      # install Puppet server 7 plus agent on AlmaLinux 8
      # https://puppet.com/docs/puppet/7/install_and_configure.html
      "dnf install -y https://yum.puppet.com/puppet7-release-el-8.noarch.rpm",
      "dnf install -y git puppetserver qemu-guest-agent gem",
      "sed -i 's/2g/1g/g' /etc/sysconfig/puppetserver",
      'echo JAVA_ARGS="$JAVA_ARGS -Djava.net.preferIPv4Stack=true" >> /etc/sysconfig/puppetserver',
      "echo 192.168.10.60 puppet.family.net puppet >> /etc/hosts",
      "/opt/puppetlabs/bin/puppet config set server puppet.family.net  --section main",
      "/opt/puppetlabs/bin/puppet config set server puppet.family.net  --section agent",
      "/opt/puppetlabs/bin/puppet config set certname ${each.value.fqdn} --section agent",
      "/opt/puppetlabs/bin/puppet config set interval 30m  --section agent",
      "echo '*' >> /etc/puppetlabs/puppet/autosign.conf",
      #"/opt/puppetlabs/bin/puppet config print ssldir --section agent",
      "cd /etc/puppetlabs/code/environments && rm -rf production && git clone https://github.com/nansari/homelab.git && ln -s homelab/puppet_code/production production",
      "/opt/puppetlabs/bin/puppetserver ca setup",
      "/opt/puppetlabs/bin/puppetserver ca list --all",
      "/usr/bin/systemctl enable puppetserver puppet qemu-guest-agent",
      "/usr/bin/systemctl start puppetserver puppet",
      "gem install puppet-lint",
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
