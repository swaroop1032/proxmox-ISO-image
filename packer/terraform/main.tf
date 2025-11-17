terraform {
  required_providers { proxmox = { source = "bpg/proxmox", version = ">= 0.40.0" } }
}
variable "pm_api_url"      { default = "https://<PROXMOX_IP>:8006/api2/json" }
variable "pm_api_token_id" {}
variable "pm_api_token_secret" {}
variable "node"            { default = "proxmox" }
variable "vm_name"         { default = "win11-auto-01" }
variable "storage"         { default = "local-lvm" }
variable "bridge"          { default = "vmbr0" }

provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_user    = var.pm_api_token_id
  pm_token   = var.pm_api_token_secret
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "win11" {
  name        = var.vm_name
  target_node = var.node
  clone       = "tpl-win11-25h2"
  cores       = 2
  memory      = 4096
  agent       = 1
  onboot      = true

  network { model = "virtio"; bridge = var.bridge }
  disk    { size = "60G"; type = "scsi"; storage = var.storage; ssd = 1 }

  cicustom = "user=local:snippets/win11-userdata.yaml,network=local:snippets/win11-network.yaml"
  ipconfig0 = "ip=dhcp"
  boot = "order=scsi0;net0"
}
