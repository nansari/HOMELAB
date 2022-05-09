variable "common" {
  sensitive = false
  default = {
    #TODO: also used in packer's variables.auto.pkrvars.hcl, can it be shared?
    # note that packer expect below as same name as node created in proxmox.
    #default = "https://192.168.10.50:8006/api2/json"  - does not work with packer
    "pve_url"          = "https://pve:8006/api2/json"
    "pve_username"     = "root@pam"
    "ssh_username"     = "root"
    "private_key_file" = "/home/nasim/.ssh/id_rsa"
    "ssh_pub_key"      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmVcCvcqnMYXDVrmJSD4C/nNIRK4CfrnjfV9+HAKveZvi1I4YBcR0SYx1hw0UludQBbn0jPMsIBrskOWcw8+Jht4P5BZETCq/SCPpVRcALSsRh6bouzBho4Z5L79MWk6vAesTOimJ9KyO7fvpfcFgZ81VynCO3XIYPQAI4COYecNk8gz5vzqijL0CBA6ITuzyREU5hy+ZxDt5DrTwuq/O/8bHeurvCo8cMBN6Cr3IGxZ5+j2FM7bc+MAKl4YEoULtMtKMJD+p6tQxa1IO6kLbN539QkCD0weFpzyGfJgzK0IgyKQyeAp/WGg6RAYxijHr9NlIuNPu2x9IzKyleT4rElCZSaQJNxABu9gCWe0iK4aM6615T1dBSYEyuIP2lmKEC0roe5Tj5ty09j7P6cCHAykwRcHS6ozz9qjZ1rtHm/mZvQvlJ57LbD+GsFcUwit+K9wbdYfN9bMRte+/bk2moH/SUbEpSyB+C2g1vUq82Usl32ruFrZ+FDWQ3QdmvxBk= nasim@nau20"
  }
  description = "default non-secret shared variables those need to be used across all terraform workspaces (directories)"
}

