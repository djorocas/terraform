variable "az_location" {
 description = "The location where resources will be created"
 default     = "South Africa North"
}

variable "az_tags" {
 description = "A map of the tags to use for the resources that are deployed"
 type        = "map"
 default     = {
   environment = "dev"
 }
}

# Network
variable "az_rg_name" {
 description = "The name of the resource group in which the resources will be created"
 default     = "devops_rg"
}

variable "az_vnet_name" {
 description = "Azure vnet name"
 default     = "devops_vnet"
}

variable "az_subnet_name" {
 description = "Azure subnet name"
 default     = "devops_subnet"
}

variable "az_net_interface_name" {
 description = "Azure network interface name"
 default     = "devops_net_interface"
}

variable "az_net_interface_ip_config_name" {
 description = "Azure network interface ip configuration name"
 default     = "devops_net_interface"
}

variable "az_pub_ip_name" {
 description = "Azure public ip name"
 default     = "devops_pub_ip"
}
