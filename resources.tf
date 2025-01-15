resource "proxmox_vm_qemu" "test-server-apache" {
  name        = "apache-vm-1"
  onboot      = true
  target_node = "tigers1"
  clone       = "temp-terr"
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

  # Uncomment the following line if static IPs are used
  ipconfig0 = "ip=10.10.10.97/24,gw=10.10.10.1"
}

