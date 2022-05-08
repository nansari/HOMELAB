# create puppet master host
variable "buildhosts" {
  default = {
    "puppet" = {
      hostname       = "puppet"
      vmid           = "160"
      target_node    = "pve"
      clone_template = "almalinux8"
      cores          = "1"
      sockets        = "1"
      memory         = "2046"
      disk_size      = "10G"
      datastore      = "local-lvm"
      ipv4           = "192.168.10.60"
      gateway        = "192.168.10.1"
      macaddr        = "2a:31:71:7a:ed:21"
      autostart      = true
    }
  }
}

variable "workspace" {
  default = "puppet"
}