# Home Lab
Infrastructure for my home network.

The goal of this project is to have my whole infrastructure defined as code, using Terraform. And manage configurations using Ansible.
I currently have 2 machines, both of them running [Proxmox](https://www.proxmox.com/en/) as hypervisor.

All services run inside linux containers (and often times in a nested a docker container) to optimize usage of resources, provisioned through Proxmox.

## NUC
Low power, passively cooled x86 pc with 4 2.5 gbps ethernet ports. It contains the most essential services and should be always on.

It currently currently has a VM running PfSense as my router, with two ports passed through to the vm. (This is not defined in terraform/ansible).
The remaining services are defined in code. But currently there is only a Pihole instance running as my DNS and DHCP server.


## NAS
More powerful standard desktop pc used as a server.
All services here are defined in Terraform.

### SSL
All of my hosted services use https, with a wildcard certificate for `*.berr.dev`.
This is done through a container running `certbot` and sharing the new live certificate with the other containers.
This isn't running at the moment because I'm currently switching from my current VPS and I'll update the automation soon.

### Private data
Although most of the configuration here is public: the ips inside my internal network, etc. I have some informations that I chose to keep hidden.
These files stay in the `private` folder:
- `dhcp_reservations`: contains a list of dhcp reservations for my pihole server. This is kept private because it contains the MAC Adresses of devices in my home.
- An example of this file could be:
```
dhcp-host=00-B0-D0-63-C2-26,10.102.3.0,felipe-desktop
dhcp-host=01-23-45-67-89-AB,10.102.3.1,felipe-laptop
```
- `secrets.env`: Contains the root password for Proxmox and for the created containers.
```
export PM_PASS="proxmox_password_example"
export ROOT_PASSWORD="secret_root_password"
export TF_VAR_root_password="${ROOT_PASSWORD}"
```
- The remaining files are the state files created by terraform, they're only private because they contain the values of the previous two files.
- The `encrypt_files.sh` and `decrypt_files.sh` scripts in the root of the repository are used to generate the `private_encrypted` folder to commit, and to get back the original files from the encrypted version. They only accept one parameter, which is the key for the encryption.
- Example usage: `./encrypt_files.sh fC4o4FX9ClBf0ZmrT5L8PQZLtn11E0EP` or `./decrypt_files.sh fC4o4FX9ClBf0ZmrT5L8PQZLtn11E0EP`
