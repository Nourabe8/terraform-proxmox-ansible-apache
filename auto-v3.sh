#!/bin/bash

# Step 1: Apply Terraform to create the VM
echo "Applying Terraform to create VM..."
terraform init
terraform apply -auto-approve

# Step 2: Get VMID and VMIP from Terraform output
#vmid=$(terraform output -raw vmid)
#vm_ip=$(terraform output -raw vm_ip)
vm_name=$(terraform output -raw vm_name)
vmid=$(ssh root@10.10.10.5 "qm list | grep $vm_name | awk '{print \$1}'")

#terraform refresh

# Step 2: Get VMID from Terraform output
#vmid="123"

# Step 3: Start the VM using the VMID
echo "Starting the VM with VMID: $vmid"
#qm start $vmid
ssh root@10.10.10.5 "qm start $vmid"

# Step 2: Extract VM's IP address (Adjust based on your Terraform output)
#vm_ip=$(terraform output -raw vm_ip)
vm_ip="10.10.10.97"

# Step 5: Wait for VM to initialize
echo "Waiting for VM to initialize..."
sleep 60  # Wait for 30 seconds

echo "Removing old SSH key for $vm_ip from known_hosts..."
sudo ssh-keygen -f '/root/.ssh/known_hosts' -R "$vm_ip"

# Step 3: Update Ansible hosts file with the new VM IP
echo "[webserver]" > /etc/ansible/hosts
echo "$vm_ip ansible_user=terrweb3 ansible_ssh_private_key_file=/home/noura/.ssh/id_rsa" >> /etc/ansible/hosts

# Step 4: Run Ansible playbook
echo "Running Ansible playbook to install Apache..."
ansible-playbook install-apache.yml

echo "VM created and Apache installed successfully!"

