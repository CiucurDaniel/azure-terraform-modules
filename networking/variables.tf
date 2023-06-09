variable "create_resource_group" {
  type        = bool
  description = "Boolean value to determine if a resource group should be created else module will query and existing one"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to query or create"
}

variable "location" {
  description = "Location of the resource group. Only if it's created and not queried"
  type        = string
  default     = null
}

variable "create_vnet" {
  description = "Boolean value to determine if the virtual network should be created or queried"
  type        = bool
}

variable "vnet_name" {
  description = "Name of the virtual network to query or create"
  type        = string
}

variable "address_space" {
  description = "List containing address spaces for the vnet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Subnets to be created inside the vnet"
}

variable "tags" {
  description = "A map of tags for resources created by the module"
  type        = map(string)
  default     = {}
}