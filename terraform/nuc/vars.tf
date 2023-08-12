variable "proxmox_ip" {
  type     = string
  nullable = false
}

variable "proxmox_port" {
  type     = string
  default  = "8006"
  nullable = false
}

variable "proxmox_node" {
  type     = string
  nullable = false
}

variable "ssh_public_key_file" {
  type     = string
  nullable = false
}

variable "root_password" {
  type      = string
  default   = "pass1234"
  nullable  = false
  sensitive = true
}

variable "gateway" {
  type     = string
  nullable = false
}

variable "dns" {
  type     = string
  nullable = false
}

variable "network_prefix" {
  type     = string
  nullable = false
}

variable "services_subnet_prefix" {
  type     = string
  nullable = false
}

variable "domain" {
  type     = string
  nullable = false
  default  = "example.com"
}

variable "pm_user" {
  type = string
  nullable = false
  default = "root@pam"
}

variable "pm_pass" {
  type = string
  nullable = false
  default = "abcd"
}