variable "az_location" {
 description = "The location where resources will be created"
 default     = "South Africa North"
}

variable "az_rg_name" {
 description = "The name of the resource group in which the resources will be created"
 default     = "devops_rg"
}

variable "az_net_interface_name" {
 description = "Azure network interface name"
 default     = "devops_net_interface"
}

# VM
variable "az_vm_name" {
  description = "Azure vm name"
  default     = "devops_vm"
}

variable "vm_image_publisher" {
  description = "Azure vm image vendor"
  default     = "MicrosoftWindowsServer"
}

variable "vm_image_offer" {
  description = "vm image vendor's VM offering"
  default     = "WindowsServer"
}

variable "vm_image_sku" {
  default = "2016-Datacenter"
}

variable "vm_image_version" {
  description = "vm image version"
  default     = "latest"
}

variable "vm_storage_os_disk_name" {
  description = "Azure Storage os disk name"
  default     = "devops_datadisk"
}

variable "VM_USERNAME" {
  description = "Azure VM Admin username"
  default = "devops"
}

variable "VM_PASSWORD" {
  description = "Azure VM password"
  default = "a7G6}WVT7zV.e+N"
}
