source "proxmox-iso" "debian-bookworm-10Gb" {

  # Configuration Reference
  node = "pve"
  proxmox_url = "${var.PROXMOX_URL}"
  token = "${var.TOKEN}"
  username = "${var.USERNAME}"
  insecure_skip_tls_verify = true

  template_name = "Debian12"
  template_description = "Debian 12-1.0, generated on ${timestamp()}"
  vm_name = "Debian12-10Gb"
  vm_id = 10001

  iso_file = "${var.ISO_FILE_PATH}"
  iso_checksum = "${var.ISO_CHECKSUM}"
  unmount_iso = true

  # Hardware
  memory = 1024
  cores = 1
  
  disks {
    disk_size = "10G"
    storage_pool = "local-lvm"
    type = "scsi"
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  
  # SSH
  ssh_password = "${var.SSH_PASSWORD}"
  ssh_username = "${var.SSH_USERNAME}"
  ssh_timeout = "15m"

  # VM Cloud-Init Settings
  cloud_init = true
  cloud_init_storage_pool = "local-lvm"

  # Boot Loading
  boot_wait = "5s"
  boot_command = [
    "<down><down><enter>",
    "<down><down><down><down><down><down><enter>",
    "<wait60s>",
    "http://${var.LOCAL_IP}:8082/preseed-10gb.cfg",
    "<enter><wait>"
  ]
  
}

build {
  name = "debian-10Gb-builder"

  sources = ["source.proxmox-iso.debian-bookworm-10Gb"]

  provisioner "shell" {
    inline = [
      # Update Apt Sources
      "apt-get update -y",

      # Install Base Packages
      "apt-get install vim wget libip6tc2 libnfnetlink0 libnetfilter-conntrack3 iptables -y",

      # Cloud init
      "apt-get install cloud-init -y",
      
      # SSH Banner
      "sed -i 's%#Banner none%Banner /etc/issue.net%' /etc/ssh/sshd_config",

      # Docker Install
      "wget ${var.DOCKER_SOURCES}/${var.CONTAINERD}",
      "wget ${var.DOCKER_SOURCES}/${var.DOCKER_CE_CLI}",
      "wget ${var.DOCKER_SOURCES}/${var.DOCKER_CE}",
      "wget ${var.DOCKER_SOURCES}/${var.DOCKER_BUILDX}",
      "wget ${var.DOCKER_SOURCES}/${var.DOCKER_COMPOSE}",

      "dpkg -i ${var.CONTAINERD}",
      "dpkg -i ${var.DOCKER_CE_CLI}",
      "dpkg -i ${var.DOCKER_CE}",
      "dpkg -i ${var.DOCKER_BUILDX}",
      "dpkg -i ${var.DOCKER_COMPOSE}",
      
      "rm ${var.CONTAINERD} ${var.DOCKER_CE_CLI} ${var.DOCKER_CE} ${var.DOCKER_BUILDX} ${var.DOCKER_COMPOSE}"

    ]
  }

  provisioner "file" {
    destination = "/etc/"
    source      = "boot/issue.net"
  }

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg.d/"
    source      = "boot/99_pve.cfg"
  }

  provisioner "shell" {
    inline = [
      # Revert SSH Rule
      "sed -i 's/PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config",
    ]
  }
  
}
