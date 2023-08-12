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
  
  ostemplate   = "local:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"

  start = true
  onboot = true
  unprivileged = false
  
  cores = var.specs.cores
  memory = var.specs.memory

  features {
    nesting = true
  }

  rootfs {
    storage = "local-lvm"
    size    = var.specs.disk_size
  }

  mountpoint {
    slot    = "0"
    key     = 0
    storage = "/mnt/data_fast"
    volume  = "/mnt/data_fast"
    mp      = "/mnt/data_fast"
    size    = "1T"
  }

  mountpoint {
    slot    = "1"
    key     = 1
    storage = "/mnt/data_slow"
    volume  = "/mnt/data_slow"
    mp      = "/mnt/data_slow"
    size    = "2T"
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