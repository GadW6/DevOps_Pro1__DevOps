source "proxmox-iso" "debian-bookworm" {

  # Configuration Reference
  node = "pve"
  proxmox_url = "${var.PROXMOX_URL}"
  token = "${var.TOKEN}"
  username = "${var.USERNAME}"
  insecure_skip_tls_verify = true

  template_name = "Debian12"
  template_description = "Debian 12-1.0, generated on ${timestamp()}"
  vm_name = "Debian12"
  vm_id = 10002

  iso_file = "${var.ISO_FILE_PATH}"
  iso_checksum = "${var.ISO_CHECKSUM}"
  unmount_iso = true

  # Hardware
  memory = 1024
  cores = 1
  
  disks {
    disk_size = "15G"
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
  ssh_timeout = "1h"

  # Boot Loading
  boot_wait = "5s"
  boot_command = [
    "<down><down><enter>",
    "<down><down><down><down><down><down><enter>",
    "<wait30s>",
    "http://192.168.1.21:8082/preseed.cfg",
    "<enter><wait>"
  ]
  
  
  # cloud_init = true
}

build {
  sources = ["source.proxmox-iso.debian-bookworm"]
}
