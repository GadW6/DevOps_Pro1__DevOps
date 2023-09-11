variable "SSH_USERNAME" {
  type = string
  default = "administrator"
}

variable "SSH_PASSWORD" {
  type = string
  default = "password"
  sensitive = true
}

variable "ISO_FILE_PATH" {
  type = string
  default = "local:iso/debian-12.1.0-amd64-netinst.iso"
}

variable "ISO_CHECKSUM" {
  type = string
  default = "9f181ae12b25840a508786b1756c6352a0e58484998669288c4eec2ab16b8559"
}

# variable "ISO_FILE_PATH" {
#   type = string
#   default = "local:iso/debian-11.6.0-amd64-netinst.iso"
# }

# variable "ISO_CHECKSUM" {
#   type = string
#   default = "e482910626b30f9a7de9b0cc142c3d4a079fbfa96110083be1d0b473671ce08d"
# }