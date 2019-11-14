# Configure the Azure Provider
provider "azurerm" {
  version = "=1.36.0"
}

# Create a resource group
resource "azurerm_resource_group" "devops_rg" {
  name     = var.az_rg_name
  location = var.az_location
  tags     = var.az_tags
}

resource "azurerm_virtual_network" "az_vnet" {
 name                = var.az_vnet_name
 address_space       = ["10.0.0.0/16"]
 location            = var.az_location
 resource_group_name = "${azurerm_resource_group.devops_rg.name}"
 tags                = var.az_tags
}

resource "azurerm_network_security_group" "az_nsg" {
  name                = "acceptanceTestSecurityGroup1"
  location            = "${azurerm_resource_group.devops_rg.location}"
  resource_group_name = "${azurerm_resource_group.devops_rg.name}"

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    destination_port_range     = "3389"
  }

  tags = var.az_tags
}

resource "azurerm_subnet" "az_subnet" {
 name                 = var.az_subnet_name
 resource_group_name  = "${azurerm_resource_group.devops_rg.name}"
 virtual_network_name = "${azurerm_virtual_network.az_vnet.name}"
 address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_association" {
  subnet_id                 = "${azurerm_subnet.az_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.az_nsg.id}"
}

resource "azurerm_public_ip" "az_pub_ip" {
  count = var.acount
  name                = "${var.az_pub_ip_name}${count.index}"
  location            = var.az_location
  resource_group_name = "${azurerm_resource_group.devops_rg.name}"
  allocation_method   = "Dynamic"

  tags = var.az_tags
}

resource "azurerm_network_interface" "az_net_interface" {
  count = var.acount
  name                = "${var.az_net_interface_name}${count.index}"
  location            = var.az_location
  resource_group_name = "${azurerm_resource_group.devops_rg.name}"

  ip_configuration {
    name                          = var.az_net_interface_ip_config_name
    subnet_id                     = "${azurerm_subnet.az_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.az_pub_ip.*.id, count.index)
  }
}

# Create a Virtual Machine
resource "azurerm_virtual_machine" "test" {
    count                             = var.acount
    name                              = "${var.az_vm_name}${count.index}"
    location                          = var.az_location
    resource_group_name               = "${azurerm_resource_group.devops_rg.name}"
    network_interface_ids             = [element(azurerm_network_interface.az_net_interface.*.id, count.index)]
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
      name              = "${var.vm_storage_os_disk_name}${count.index}"
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

/*
module "iis-install" {
  source  = "ghostinthewires/iis-install/azurerm"
  version = "1.0.2"
  resource_group_name = "${azurerm_resource_group.devops_rg.name}"
  vmname = "${azurerm_virtual_machine.test.name}"
  location = "${azurerm_resource_group.devops_rg.location}"
}
*/
