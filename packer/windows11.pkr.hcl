packer {
  required_plugins {
    proxmox = {
      source  = "github.com/hashicorp/proxmox"
      version = ">= 1.1.0"
    }
  }
}

variable "pm_url"       { default = "https://172.18.0.48:8006/api2/json" }
variable "pm_user"      {}
variable "pm_token"     {}
variable "node"         { default = "proxmox" }
variable "iso_storage"  { default = "local" }
variable "vm_storage"   { default = "local-lvm" }
variable "bridge"       { default = "vmbr0" }
variable "winrm_password" { default = "Passw0rd!" }

source "proxmox-iso" "win11" {
  url               = var.pm_url
  username          = var.pm_user
  token             = var.pm_token
  node              = var.node

  vm_name           = "tpl-win11-25h2"
  memory            = 4096
  cores             = 2
  disk_size         = "60G"
  vm_storage_pool   = var.vm_storage

  iso_storage_pool  = var.iso_storage
  iso_file          = "local:iso/Win11_25H2_EnglishInternational_x64.iso"
  additional_iso_files = ["local:iso/virtio-win.iso"]

  efi_disk          = true
  uefi              = true
  secure_boot       = false

  network_adapter   = "virtio"
  bridge            = var.bridge
  disk_interface    = "virtio"

  qemu_agent        = true

  floppy_files      = ["packer/Autounattend.xml"]

  communicator      = "winrm"
  winrm_username    = "Administrator"
  winrm_password    = var.winrm_password
  winrm_timeout     = "2h"
}

build {
  sources = ["source.proxmox-iso.win11"]

  provisioner "file" {
    source      = "packer/scripts/"
    destination = "C:\\Windows\\Temp\\"
  }

  provisioner "windows-shell" {
    inline = [
      "powershell -ExecutionPolicy Bypass -File C:\\Windows\\Temp\\install-virtio-drivers.ps1",
      "powershell -ExecutionPolicy Bypass -File C:\\Windows\\Temp\\install-qemu-agent.ps1",
      "powershell -ExecutionPolicy Bypass -File C:\\Windows\\Temp\\install-cloudbase-init.ps1"
    ]
  }

  provisioner "windows-shell" {
    inline = [ "Write-Host 'Customization complete'" ]
  }

  provisioner "windows-shell" {
    inline = [
      "powershell -ExecutionPolicy Bypass -File C:\\Windows\\Temp\\prepare-template.ps1"
    ]
  }

  post-processor "shell-local" {
    inline = [
      "ssh root@172.18.0.48 'qm stop $(qm list | awk \"/tpl-win11-25h2/ {print \\$1}\"); qm template $(qm list | awk \"/tpl-win11-25h2/ {print \\$1}\")'"
    ]
  }
}
