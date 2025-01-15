# resources.tf

resource "proxmox_vm_qemu" "test-server-apache" {
  name        = "apache-vm-1"
  onboot      = true
  target_node = var.target_node
  clone       = var.clone_template
  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  memory      = 2048

  disk {
    size    = "8G"
    type    = "scsi"
    storage = "local"
  }

  network {
    model  = var.network_model   # Use the network model from variables
    bridge = var.network_bridge  # Use the network bridge from variables
  }

  # Use the IP and gateway from variables for network configuration
  ipconfig0 = "ip=${var.proxmox_ip},gw=${var.gateway}"
}
