
# locals {
#   k8smaster = compact([for hostname in var.buildhosts :contains(['k8smaster'], ) ? hostname : null])
#   # https://www.terraform.io/language/functions/compact - doc under collection section of functions
#   # https://www.terraform.io/language/functions/contains - determines whether a given list or set contains a given single value as one of its elements
# }

resource "proxmox_vm_qemu" "puppet_vm" {
  # https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
  for_each = var.buildhosts

  agent    = 1            # defaule is 0. Set to 1 to enable the QEMU Guest Agent. The qemu-guest-agent daemon sshould run in the guest for this to have any effect.
  os_type  = "cloud-init" # ubuntu, centos or cloud-init

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
    macaddr  = each.value.macaddr
    firewall = false
  }
  sshkeys   = module.shared.common.ssh_pub_key

  cpu      = "host"   # qemu host type - host, kvm64 - default to host
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  ipconfig0 = "ip=${each.value.ipv4}/24,gw=${each.value.gateway}"

  provisioner "remote-exec" {
    inline = [
      "/usr/bin/hostnamectl set-hostname ${each.value.hostname}",
      # install k8s - add command shere
      "/opt/puppetlabs/bin/puppet agent -tv",
      "grep -w puppet /etc/hosts || echo 192.168.10.60 puppet puppet.family.net >> /etc/hosts",
      "reboot",
    ]
    on_failure = continue # applies only to the final command in the list
    connection {
      type = "ssh"
      user = "root"
      private_key = file(module.shared.common.private_key_file)
      host = each.value.ip4
    }
  }
}
