# Example: from this directory:
`ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i nas_containers.yml setup_docker_service.yml`

# Running on a single host:
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i nas_containers.yml -l 'letsencrypt' setup_docker_service.yml 