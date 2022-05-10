# create puppet master host
variable "buildhosts" {
  default = {
    "dns" = {
      hostname         = "dns"
      description      = "BIND DNS LXC container"
      fqdn           = "dns.family.net"
      vmid             = "153"
      target_node      = "pve"
      #clone_template   = "/var/lib/vz/template/cache/almalinux-8-default_20210928_amd64.tar.xz"
      cores            = "1"
      sockets          = "1"
      memory           = "1024"
      disk_size        = "5G"
      datastore        = "local-lvm"
      ipv4             = "192.168.10.53"
      gateway          = "192.168.10.1"
      macaddr          = "2a:31:71:7a:ed:53"
      autostart        = true
      lxc_templatte_id = "8888"
    }
  }
}
