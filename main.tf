resource "proxmox_vm_qemu" "provision" {
    # General Definition
    cpu_type     = var.vm.general.cpu_type
    bootdisk     = var.vm.general.bootdisk
    scsihw       = var.vm.general.scsihw
    os_type      = var.vm.general.os_type
    full_clone   = var.vm.general.full_clone
    hotplug      = var.vm.general.hotplug
    numa         = var.vm.general.numa

    # Display
    vga {
        type     = var.vm.resources.display
    }

    # Identification 
    name         = var.vm.name
    vmid         = var.vm.vmid

    # Account
    target_node  = var.vm.node

    # Options
    onboot       = var.vm.options.onboot
    clone        = var.vm.options.template
    agent        = var.vm.options.agent

    # Resources
    memory       = var.vm.resources.memory
    sockets      = var.vm.resources.sockets
    cores        = var.vm.resources.cores

    # CloudInit
    ciupgrade    = var.vm.cloudinit.upgrade != null ? var.vm.cloudinit.upgrade : null
    ciuser       = var.vm.cloudinit.user != null ? var.vm.cloudinit.user : null
    cipassword   = var.vm.cloudinit.password != null ? var.vm.cloudinit.password : null
    searchdomain = var.vm.cloudinit.domain != null ? var.vm.cloudinit.domain : null
    nameserver   = var.vm.cloudinit.nameserver != null ? var.vm.cloudinit.nameserver : null
    sshkeys      = var.vm.cloudinit.sshkeys != null ? join("\n",var.vm.cloudinit.sshkeys) : null
    
    # Network Devices
    dynamic "network" {
        for_each = var.vm.network
        content {
            id        = network.key
            bridge    = var.vm.network[network.key].bridge
            model     = var.vm.network[network.key].model
            firewall  = var.vm.network[network.key].firewall
            link_down = var.vm.network[network.key].link_down
        }
    }

    # CloudInit Network Configuration
    ipconfig0 = var.vm.network[0].gateway != null ? "ip=${var.vm.network[0].address}/${var.vm.network[0].mask},gw=${var.vm.network[0].gateway}" : "ip=${var.vm.network[0].address}/${var.vm.network[0].mask}"
    ipconfig1 = length(var.vm.network) > 1 ? (var.vm.network[1].gateway != null ? "ip=${var.vm.network[1].address}/${var.vm.network[1].mask},gw=${var.vm.network[1].gateway}" : "ip=${var.vm.network[1].address}/${var.vm.network[1].mask}") : null
    ipconfig2 = length(var.vm.network) > 2 ? (var.vm.network[2].gateway != null ? "ip=${var.vm.network[2].address}/${var.vm.network[2].mask},gw=${var.vm.network[2].gateway}" : "ip=${var.vm.network[2].address}/${var.vm.network[2].mask}") : null
    ipconfig3 = length(var.vm.network) > 3 ? (var.vm.network[3].gateway != null ? "ip=${var.vm.network[3].address}/${var.vm.network[3].mask},gw=${var.vm.network[3].gateway}" : "ip=${var.vm.network[3].address}/${var.vm.network[3].mask}") : null
    ipconfig4 = length(var.vm.network) > 4 ? (var.vm.network[4].gateway != null ? "ip=${var.vm.network[4].address}/${var.vm.network[4].mask},gw=${var.vm.network[4].gateway}" : "ip=${var.vm.network[4].address}/${var.vm.network[4].mask}") : null
    
    # CloudInit Disk
    disk {
        type    = var.vm.cloudinit.disk.type
        storage = var.vm.general.disk.storage
        slot    = var.vm.cloudinit.disk.slot
    }

    # Disk Boot and Additional disks
    dynamic "disk" {
        for_each = var.vm.resources.disks
        content {
            type    = var.vm.general.disk.type
            storage = var.vm.general.disk.storage
            slot    = disk.value.slot
            size    = disk.value.size
        }
    }
}