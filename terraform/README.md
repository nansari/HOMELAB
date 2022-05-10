# bind_dns
* Build an LXC container using ssh enabled LXC Template for BIND DNS using `proxmox_lxc` resource of proxmox provider

# kubernetes
Build k8s master and nodes using terraform using VM image created by Packer and using `proxmox_vm_qemu` resource of proxmox provider

# puppet
Build Puppet master VM and install Puppet master using method similar to above.

# shared
Terraform shared module to supply shared variable and secrets to all other workspaces

