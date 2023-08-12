output "ip_addr" {
  value = split("/", proxmox_lxc.container.network[0].ip)[0]
}

output "name" {
  value = proxmox_lxc.container.hostname
}