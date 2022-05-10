terraform {
  required_providers {
    proxmox = {
      # https://registry.terraform.io/providers/Telmate/proxmox/latest
      source = "telmate/proxmox"
    }
  }
}

module "shared" {
  source = "../shared"
}

provider "proxmox" {
  pm_api_url      = module.shared.common.pve_url
  pm_user         = module.shared.common.pve_username
  pm_password     = module.shared.secret.pve_password
  pm_tls_insecure = "true"
  ##uncomment below line to get debug outpout - such as bad parameters
  # pm_log_enable = true
  # pm_log_file = "terraform-plugin-proxmox.log"
  # pm_debug = true
  # pm_log_levels = {
  #   _default = "debug"
  #   _capturelog = ""
  }
}
