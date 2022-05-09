# create puppet master host
variable "buildhosts" {
  default = {
    "k8smaster" = {
      hostname       = "k8smaster"
      vmid           = "155"
      target_node    = "pve"
      clone_template = "almalinux8"
      cores          = "1"
      sockets        = "1"
      memory         = "1024"
      disk_size      = "10G"
      datastore      = "local-lvm"
      ipv4           = "192.168.10.55"
      gateway        = "192.168.10.1"
      macaddr        = "2a:31:71:7a:ed:55"
      autostart      = true
    }
    "k8snode1" = {
      hostname       = "k8snode1"
      vmid           = "156"
      target_node    = "pve"
      clone_template = "almalinux8"
      cores          = "2"
      sockets        = "1"
      memory         = "2046"
      disk_size      = "10G"
      datastore      = "local-lvm"
      ipv4           = "192.168.10.56"
      gateway        = "192.168.10.1"
      macaddr        = "2a:31:71:7a:ed:56"
      autostart      = true
    }
    "k8snode2" = {
      hostname       = "k8snode2"
      vmid           = "157"
      target_node    = "pve"
      clone_template = "almalinux8"
      cores          = "1"
      sockets        = "1"
      memory         = "2046"
      disk_size      = "10G"
      datastore      = "local-lvm"
      ipv4           = "192.168.10.55"
      gateway        = "192.168.10.1"
      macaddr        = "2a:31:71:7a:ed:57"
      autostart      = true
    }
  }
}
