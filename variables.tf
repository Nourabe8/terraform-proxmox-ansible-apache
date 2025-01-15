variable "pm_api_url" {}
variable "pm_user" {}
variable "pm_password" {}
variable "pm_tls_insecure" {
  default = true
}

variable "network_model" {
  description = "The network model for the VM"
  type        = string
  default     = "virtio"  # Default network model
}

variable "network_bridge" {
  description = "The network bridge for the VM"
  type        = string
  default     = "vmbr0"  # Default network bridge
}

variable "proxmox_ip" {
  description = "The static IP address for the VM"
  type        = string
}

variable "gateway" {
  description = "The gateway for the network"
  type        = string
}

variable "target_node" {
  description = "The target Proxmox node"
  type        = string
}

variable "clone_template" {
  description = "The Proxmox template to clone from"
  type        = string
}

