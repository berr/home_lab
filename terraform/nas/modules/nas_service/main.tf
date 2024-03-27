terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

resource "proxmox_lxc" "container" {
  target_node  = var.node
  hostname     = var.hostname
  ssh_public_keys = var.secrets.ssh_public_key
  password     = var.secrets.root_password
  
  ostemplate   = "local:vztmpl/debian12_homelab.tar.xz"

  start = true
  onboot = true
  unprivileged = false
  
  cores = var.specs.cores
  memory = var.specs.memory
  swap = var.specs.swap

  features {
    nesting = true
  }

  rootfs {
    storage = "container-data"
    size    = var.specs.disk_size
  }

  mountpoint {
    slot    = "0"
    key     = 0
    storage = "/mnt/data"
    volume  = "/mnt/data"
    mp      = "/mnt/data"
    size    = "4T"
  }


  nameserver = var.network.dns
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = var.ip
    gw = var.network.gateway
  }

  tags = "terraform"  
}