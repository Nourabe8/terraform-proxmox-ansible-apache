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
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Use the IP and gateway from variables
  ipconfig0 = "ip=${var.proxmox_ip},gw=${var.gateway}"
}
