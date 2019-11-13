# Configure the Azure Provider
provider "azurerm" {
  version = "=1.36.0"
}

# Get a resource group
data "azurerm_resource_group" "devops_rg" {
  name = var.az_rg_name
}

# Get network interface
data "azurerm_network_interface" "az_net_interface" {
  name                = var.az_net_interface_name
  resource_group_name = "${data.azurerm_resource_group.devops_rg.name}"
}

# Create a Virtual Machine
resource "azurerm_virtual_machine" "test" {
    name                              = var.az_vm_name
    location                          = var.az_location
    resource_group_name               = "${data.azurerm_resource_group.devops_rg.name}"
    network_interface_ids             = ["${data.azurerm_network_interface.az_net_interface.id}"]
    vm_size                           = "Standard_B1ms"
    delete_os_disk_on_termination     = true
    delete_data_disks_on_termination  = true


    storage_image_reference {
      publisher = var.vm_image_publisher
      offer     = var.vm_image_offer
      sku       = var.vm_image_sku
      version   = var.vm_image_version
    }

    storage_os_disk {
      name              = var.vm_storage_os_disk_name
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    os_profile {
      computer_name   = "SERVER2016"
      admin_username  = var.VM_USERNAME
      admin_password  = var.VM_PASSWORD
    }

    os_profile_windows_config {
      provision_vm_agent = "true"
      enable_automatic_upgrades = "true"
      winrm {
        protocol = "http"
        certificate_url =""
      }
    }
}

module "iis-install" {
  source  = "ghostinthewires/iis-install/azurerm"
  version = "1.0.2"
  resource_group_name = "${data.azurerm_resource_group.devops_rg.name}"
  vmname = "${azurerm_virtual_machine.test.name}"
  location = "${data.azurerm_resource_group.devops_rg.location}"
}
