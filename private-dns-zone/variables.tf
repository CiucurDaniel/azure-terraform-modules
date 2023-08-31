variable "vnet_name" {
  type        = string
  description = "The name of the vnet which should be linked with the PrivateDnsZone"
}

variable "vnet_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is deployed"
}

variable "private_dns_zone_name" {
  type        = string
  description = "(Required) The name of the Private DNS Zone. Must be a valid domain name. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the resource group where the Private DNS Zone should be created. Changing this forces a new resource to be created."
}

variable "private_dns_zone_virtual_network_link_name" {
  type = string
  description = "(Required) The name of the Private DNS Zone Virtual Network Link. Changing this forces a new resource to be created."
}

variable "registration_enabled" {
  type        = bool
  description = "(Optional) Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to false."
  default     = false
}

variable "tags" {
  description = "A map of tags for resources created by the module"
  type        = map(string)
  default     = {}
}
