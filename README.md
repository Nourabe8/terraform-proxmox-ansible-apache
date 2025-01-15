# README for Terraform-Ansible-Proxmox-Apache Project

## Project Overview

This project automates the creation and configuration of a Proxmox virtual machine (VM) with Terraform and Ansible. The VM is configured to install and run Apache, serving as a basic web server. The project combines infrastructure as code (IaC) principles with configuration management to streamline the deployment process.

## Features

- **VM Creation:** Automatically create a Proxmox VM using Terraform.
- **Cloud-Init Support:** Use a Proxmox cloud-init template for VM initialization.
- **Apache Installation:** Install and configure Apache on the VM using an Ansible playbook.
- **Automated Workflow:** A shell script (`creation-deployment.sh`) integrates Terraform and Ansible workflows for seamless automation.

## Prerequisites

- **Proxmox VE**: A running Proxmox environment.
- **Terraform**: Installed on your local machine (tested with Terraform v1.x).
- **Ansible**: Installed on your local machine for configuration management.
- **SSH Access**: SSH key-based authentication set up for accessing the Proxmox server and the VM.
- **Environment Variables**:
  - `PROXMOX_SSH_USER`: Proxmox SSH username.
  - `PROXMOX_SSH_HOST`: Proxmox SSH host/IP.
  - `PROXMOX_SSH_KEY`: Path to the SSH private key for Proxmox.
  - `VM_IP`: Static IP address for the VM.

## File Structure

```
.
├── .terraform.lock.hcl        # Terraform lock file for provider versions
├── creation-deployment.sh     # Shell script for automated deployment
├── install-apache.yml         # Ansible playbook for installing Apache
├── main.tf                    # Main Terraform configuration file
├── output.tf                  # Terraform outputs
├── providers.tf               # Provider configuration
├── resources.tf               # VM resource definition
├── variables.tf               # Variables definition
├── terraform.tfvars           # Variable values (not included in the repository)
```

## Getting Started

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone <repository_url>
cd <repository_name>
```

### 2. Configure Variables

Edit the `terraform.tfvars` file to provide values for the required variables:

```hcl
pm_api_url      = "https://your-proxmox-server:8006/api2/json"
pm_user         = "your-proxmox-username"
pm_password     = "your-proxmox-password"
network_model   = "virtio"
network_bridge  = "vmbr0"
proxmox_ip      = "IP of VM"
gateway         = "GW"
target_node     = "your-proxmox-node"
clone_template  = "your-cloud-init-template"
```

### 3. Run the Deployment Script

Execute the deployment script to create the VM and configure it:

```bash
chmod +x creation-deployment.sh
./creation-deployment.sh
```

### 4. Access the Apache Web Server

Once the script completes, open a browser and navigate to the static IP address of the VM (`http://<VM_IP>`). You should see the default Apache welcome page.

## Technical Details

### Terraform

- Creates a Proxmox VM using the `proxmox_vm_qemu` resource.
- Configures the VM with the provided static IP, memory, CPU, and disk settings.

### Ansible

- Installs Apache using the `install-apache.yml` playbook.
- Ensures that Apache is started and enabled to run on boot.

### Shell Script

- Integrates Terraform and Ansible workflows.
- Fetches the VMID from Proxmox and starts the VM.
- Updates the Ansible hosts file with the new VM's IP address.

## Security Considerations

- Ensure that sensitive information (e.g., Proxmox credentials, SSH keys) is securely stored and not hardcoded in the scripts.
- Add `.terraform.tfvars` to `.gitignore` to prevent sensitive data from being committed.

## Troubleshooting

- **Terraform Errors:** Run `terraform init` and `terraform plan` to debug configuration issues.
- **SSH Issues:** Verify that the SSH key is correctly configured and matches the Proxmox server and VM settings.
- **Ansible Errors:** Use `ansible-playbook -vvvv install-apache.yml` for detailed output during playbook execution.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any bugs or feature requests.

## Author

**Noura Alotaibi**

---

Feel free to customize this README further based on your specific project setup or additional features.


