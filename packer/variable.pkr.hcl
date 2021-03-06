variable "cloud_init_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "template_name" {
  type    = string
  default = "almalinux8"
}

variable "template_description" {
  type    = string
  default = "VM template"
}

variable "vm_id" {
  type    = number
  default = 9999
}

variable "node" {
  type        = string
  default     = "pve"
  description = "same as dir name present in /etc/pve/nodes else error 596 tls_process_server_certificate"
}

variable "iso_file" {
  type    = string
  default = "local:iso/AlmaLinux-8.5-x86_64-minimal.iso"
}

variable "unmount_iso" {
  type    = bool
  default = true
}

variable "vm_name" {
  type        = string
  default     = "AlmaLinuxTemplateVM"
  description = "Name of the virtual machine during creation"
}

variable "memory" {
  type    = number
  default = 1024
}

variable "cores" {
  type    = number
  default = 1
}

variable "scsi_controller" {
  type    = string
  default = "virtio-scsi-pci"
}

variable "network_adapters_details" {
  type = list(object({
    model    = string
    bridge   = string
    firewall = bool
  }))
  default = [
    {
      "model"    = "virtio"
      "bridge"   = "vmbr0"
      "firewall" = false
    },
  ]
}

variable "disks_details" {
  type = list(object({
    type              = string
    disk_size         = string
    storage_pool      = string
    storage_pool_type = string
    format            = string
  }))
  default = [
    {
      type              = "scsi"
      disk_size         = "10G"
      storage_pool      = "local-lvm"
      storage_pool_type = "lvm"
      format            = "raw"
    }
  ]
}

variable "insecure_skip_tls_verify" {
  type    = bool
  default = true
}

variable "http_directory" {
  type        = string
  default     = "../kickstart/"
  description = "The files in this directory will be available over HTTP"
}

variable "ks_file_name" {
  type    = string
  default = "almalinux_8_ks.cfg"
}

