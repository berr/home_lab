variable "node" {
  type = string
  nullable = false
}

variable "hostname" {
  type = string
  nullable = false
}

variable "ip" {
  type = string
  nullable = false
}

variable "secrets" {
  type = object({
    ssh_public_key = string,
    root_password = string,
  })
}

variable "network" {
  type = object({
    gateway = string,
    dns = string,
  })
}

variable "specs" {
  type = object({
    cores = number,
    memory = number,
    disk_size = string,
  })
}