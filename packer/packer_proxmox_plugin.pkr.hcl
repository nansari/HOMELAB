# https://github.com/hashicorp/packer-plugin-proxmox
packer {
  required_plugins {
    proxmox = {
      version = ">= 1.0.6"
      source  = "github.com/hashicorp/proxmox"
      
    }
  }
}