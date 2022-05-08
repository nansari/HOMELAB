source "proxmox" "myproxmox" {
  boot_wait = "10s"
  # ref http://vcloud-lab.com/entries/microsoft-azure/hashicorp-terraform-dynamic-block-with-example
  dynamic "disks" {
    for_each = "${var.disks_details}"
    content {
      type              = disks.value["type"]
      disk_size         = disks.value["disk_size"]
      storage_pool      = disks.value["storage_pool"]
      storage_pool_type = disks.value["storage_pool_type"]
      format            = disks.value["format"]
    }
  }
  dynamic "network_adapters" {
    for_each = "${var.network_adapters_details}"
    content {
      model    = network_adapters.value["model"]
      bridge   = network_adapters.value["bridge"]
      firewall = network_adapters.value["firewall"]
    }
  }
  node                 = "${var.node}"
  username             = "${var.common.pve_username}"
  password             = "${var.secret.pve_password}"
  ssh_username         = "${var.common.ssh_username}"
  ssh_password         = "${var.secret.ssh_password}"
  proxmox_url          = "${var.common.pve_url}"
  ssh_timeout          = "15m"
  template_name        = "${var.template_name}"
  template_description = "${var.template_description}"
  iso_file             = "${var.iso_file}"
  unmount_iso          = "${var.unmount_iso}"
  vm_id                = "${var.vm_id}"
  vm_name              = "${var.vm_name}"
  memory               = "${var.memory}"
  cores                = "${var.cores}"
  scsi_controller      = "${var.scsi_controller}"

  insecure_skip_tls_verify = "${var.insecure_skip_tls_verify}"
  http_directory           = "${var.http_directory}"
  # filename in below need to be converted to variable - for now it is hard coded.
  boot_command = ["<up><tab> ip=dhcp inst.sshd inst.cmdline inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux_8_ks.cfg<enter>"]
}

build {
  name = "build Alamninux 8 template"
  sources = [
    "source.proxmox.myproxmox"
  ]
}
