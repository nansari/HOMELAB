# VM to run postgres DB
variable "buildhosts" {
  default = {
    "postgres" = {
      hostname       = "postgres"
      description    = "Postgres VM"
      fqdn           = "postgres.family.net"
      vmid           = "161"
      target_node    = "pve"
      clone_template = "almalinux8"
      cores          = "1"
      sockets        = "2"
      memory         = "2046"
      disk_size      = "10G"
      datastore      = "local-lvm"
      ipv4           = "192.168.10.61"
      gateway        = "192.168.10.1"
      macaddr        = "2a:31:71:7a:ed:61"
      autostart      = true
    }
  }
}
