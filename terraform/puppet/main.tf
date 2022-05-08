resource "proxmox_vm_qemu" "puppet_vm" {
  # https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
  for_each = var.buildhosts

  name        = each.value.hostname
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
    #macaddr  = each.value.macaddr
    firewall = false
  }
  sshkeys   = module.shared.common.ssh_pub_key

  agent    = 1        # defaule is 0. Set to 1 to enable the QEMU Guest Agent. The qemu-guest-agent daemon sshould run in the guest for this to have any effect.
  cpu      = "host"   # qemu host type - host, kvm64 - default to host
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  define_connection_info = true
  ipconfig0 = "ip=${each.value.ipv4}/24,gw=${each.value.gateway}"
  os_type  = "cloud-init" # ubuntu, centos or cloud-init
#   os_network_config = <<EOF
# auto ens18
# iface ens18 inet static
# EOF

#   lifecycle {
#     ignore_changes = [network, ]
#   }

  provisioner "remote-exec" {
    inline = [
      "/usr/bin/hostnamectl set-hostname ${each.value.hostname}",
      # install Puppet server 7 plus agent on AlmaLinux 8
      # https://puppet.com/docs/puppet/7/install_and_configure.html
      "dnf install -y https://yum.puppet.com/puppet7-release-el-8.noarch.rpm",
      "dnf install -y git puppetserver",
      "sed -i 's/2g/1g/g' /etc/sysconfig/puppetserver",
      "echo 192.168.10.60 puppet >> /etc/hosts",
      "/opt/puppetlabs/bin/puppet config set server puppet  --section main",
      "echo '*' >> /etc/puppetlabs/puppet/autosign.conf",
      "cd /etc/puppetlabs/code && rm -rf environments && mkdir environments && git clone https://github.com/nansari/homelab.git && ln -s homelab/puppet_code/production environments/production",
      "/opt/puppetlabs/bin/puppetserver ca setup",
      "/usr/bin/systemctl enable puppetserver puppet",
      "/usr/bin/systemctl stop firewalld",
      "/usr/bin/systemctl start puppetserver puppet",
      "/opt/puppetlabs/bin/puppet agent -t",
      "reboot",
    ]
    on_failure = continue # applies only to the final command in the list
    connection {
      type = "ssh"
      user = "root"
      #   private_key = file("${module.shared.common.private_key_file}")
      private_key = file(module.shared.common.private_key_file)
      #host        = each.value.ipv4 #TODO: check if host using each.value.hostname works
      host = each.value.hostname #TODO: check if host using each.value.hostname works
    }
  }

#   provisioner "local-exec" {
#     command = "sleep 45"
#   }

}