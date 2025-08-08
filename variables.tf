variable "host" {
    description    = "Virtualization Host Info"
    type = object({
        api_url = string
        authentication = object({
            user = string
            password = string
        })
        tls_insecure = bool
        debug = bool
        log     = object({
            enable = bool
            file = string
        })
    })
}

variable "vm" {
    description    = "Resources VM Proxmox"
    type = object({
        name = string
        vmid = optional(number, 0)
        node = string
        root = number

        general = optional(object({
            cpu_type    = optional(string, "host")
            bootdisk    = optional(string, "scsi0")
            scsihw      = optional(string, "virtio-scsi-single")
            os_type     = optional(string, "cloud-init")
            full_clone  = optional(bool, true)
            hotplug     = optional(string, "network,disk,usb,memory,cpu")
            numa        = optional(bool, true)
            disk        = optional(object({
                storage = string
                type    = string 
            }))
        }),{
            cpu_type    = "host"
            bootdisk    = "scsi0"
            scsihw      = "virtio-scsi-single"
            os_type     = "cloud-init"
            full_clone  = true
            disk        = {
                storage = "local-lvm"
                type    = "disk"
            }
        })
        
        options = object({
            template = string
            onboot   = optional(bool, false)
            agent    = optional(number, 1)
        })

        resources  = object({
            memory   = number
            sockets  = number
            cores    = number
            display  = optional(string, "virtio")
            disks    = optional(list(object({
                slot = string
                size = string
            })))
        })

        network = list(object({
            address   = string
            bridge    = string
            gateway   = optional(string)
            mask      = optional(string, "24")
            model     = optional(string, "virtio")
            firewall  = optional(bool, false)
            link_down = optional(bool, false)
        }))

        cloudinit = optional(object({
            domain     = optional(string, null)
            nameserver = optional(string, null)
            user       = optional(string, null)
            password   = optional(string, null)
            sshkeys    = optional(list(string))
            upgrade    = optional(bool, false)
            disk       = optional(object({
                type   = optional(string, "cloudinit")
                slot   = optional(string, "ide2") 
            }),{
                type   = "cloudinit"
                slot   = "ide2"
            })
        }),{
            disk       = {
                type   = "cloudinit"
                slot   = "ide2"
            }
        })
    })
}