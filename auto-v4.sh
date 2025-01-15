#!/bin/bash

# Load sensitive information from environment variables
if [ -z "$PROXMOX_SSH_USER" ] || [ -z "$PROXMOX_SSH_HOST" ] || [ -z "$PROXMOX_SSH_KEY" ] || [ -z "$VM_IP" ]; then
    echo "Error: One or more sensitive environment variables are missing."
    exit 1
fi

# Step 1: Apply Terraform to create the VM
echo "Applying Terraform to create VM..."
terraform init
terraform apply -auto-approve

# Check if Terraform applied successfully
if [ $? -eq 0 ]; then
    echo "Terraform applied successfully!"
else
    echo "Error: Terraform application failed!"
    exit 1
fi

VMIP="$VM_IP"

# Step 2: Get VMID from Terraform output
vm_name=$(terraform output -raw vm_name)
vmid=$(ssh -i "$PROXMOX_SSH_KEY" "$PROXMOX_SSH_USER"@"$PROXMOX_SSH_HOST" "qm list | grep $vm_name | awk '{print \$1}'")

# Check if VMID was fetched successfully
if [ -z "$vmid" ]; then
    echo "Error: Failed to get VMID for $vm_name"
    exit 1
else
    echo "VMID for $vm_name: $vmid"
fi

# Step 3: Start the VM using the VMID
echo "Starting the VM with VMID: $vmid"
ssh -i "$PROXMOX_SSH_KEY" "$PROXMOX_SSH_USER"@"$PROXMOX_SSH_HOST" "qm start $vmid"

# Check if VM started successfully
if [ $? -eq 0 ]; then
    echo "VM started successfully!"
else
    echo "Error: Failed to start the VM!"
    exit 1
fi

# Step 4: Wait for VM to initialize
echo "Waiting for VM to initialize..."
sleep 60  # Wait for 60 seconds to allow VM to fully initialize

# Step 5: Remove old SSH key for the new VM IP from known_hosts
echo "Removing old SSH key for $VM_IP from known_hosts..."
sudo ssh-keygen -f '/root/.ssh/known_hosts' -R "$VM_IP"

# Step 6: Update Ansible hosts file with the new VM IP
echo "[webserver]" > /etc/ansible/hosts
echo "$VM_IP ansible_user=$ANSIBLE_USER ansible_ssh_private_key_file=$ANSIBLE_SSH_KEY_PATH" >> /etc/ansible/hosts

# Step 7: Run Ansible playbook to install Apache
echo "Running Ansible playbook to install Apache..."
ansible-playbook install-apache.yml

# Check if Ansible playbook ran successfully
if [ $? -eq 0 ]; then
    echo "Apache installed successfully!"
else
    echo "Error: Ansible playbook failed to install Apache!"
    exit 1
fi

echo "VM created and Apache installed successfully!"

