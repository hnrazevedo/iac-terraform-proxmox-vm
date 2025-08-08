terraform {
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "3.0.2-rc03"
        }
    }
}

provider "proxmox" {
    pm_api_url      = var.host.api_url
    pm_user         = var.host.authentication.user
    pm_password     = var.host.authentication.password
    pm_tls_insecure = var.host.tls_insecure
    pm_debug        = var.host.debug
    pm_log_enable   = var.host.log.enable
    pm_log_file     = var.host.log.file
}