terraform {
  backend "local" { path = "../../private/nas.tfstate" }
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://${var.proxmox_ip}:${var.proxmox_port}/api2/json"
  pm_tls_insecure = true

  pm_user = var.pm_user

  pm_log_enable = false
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

locals {
  secrets = {
    ssh_public_key = "${file(var.ssh_public_key_file)}"
    root_password  = var.root_password
  }

  network = {
    gateway          = var.gateway
    dns              = var.dns
    net_size         = split("/", var.network_prefix)[1]
  }

  default_specs = {
    cores = 16
    memory = 2048
    disk_size = "4G"
  }

  services = [
    {name: "dashboard", specs: {}},
    {name: "arr", specs: {}},
    {name: "syncthing", specs: {}},
    {name: "jellyfin", specs: {}},
    {name: "navidrome", specs: {}},
    {name: "photoprism", specs: {disk_size: "8G", memory: 4096}},
    {name: "influxdb", specs: {}},
    {name: "grafana", specs: {}},
    {name: "letsencrypt", specs: {}},
  ]
}


module "containers" {
  source = "./modules/nas_service"

  count = length(local.services)

  hostname = local.services[count.index].name
  ip       = "${split("/", cidrhost(var.services_subnet_prefix, count.index))[0]}/${local.network.net_size}"

  node    = var.proxmox_node
  specs = merge(local.default_specs, local.services[count.index].specs)
  secrets = local.secrets
  network = local.network
}

resource "local_file" "hosts" {
  content = templatefile("../hosts.tftpl",
    {
      services = module.containers.*
      domain = var.domain
    }
  )
  filename = "../../config/pihole/nas_hosts"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("../inventory.yml.tftpl",
    {
      services = module.containers.*
    }
  )
  filename = "../../ansible/nas_containers.yml"
}