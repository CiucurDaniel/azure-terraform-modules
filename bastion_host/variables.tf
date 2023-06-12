variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Review Azure Bastion Host FAQ for supported locations"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Bastion Host. Changing this forces a new resource to be created."
}

variable "copy_paste_enabled" {
  type        = bool
  description = "(Optional) Is Copy/Paste feature enabled for the Bastion Host."
}

variable "file_copy_enabled" {
  type        = bool
  description = "(Optional) Is File Copy feature enabled for the Bastion Host. "
}

variable "sku" {
  type        = string
  description = "(Optional) The SKU of the Bastion Host. Accepted values are Basic and Standard."
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "Possible values for sku are Basic or Standard!"
  }
}

variable "ip_configuration" {
  type = object({
    name      = string
    subnet_id = string
  })
  description = "(Optional) The ip_configuration block."
  default     = null

  validation {
    condition     = var.ip_configuration["name"] == "AzureBastionHost"
    error_message = "The Subnet used for the Bastion Host must have the name AzureBastionSubnet!"
  }
}

variable "ip_connect_enabled" {
  type        = bool
  description = "(Optional) Is IP Connect feature enabled for the Bastion Host."
  default     = false
}

variable "scale_units" {
  type        = number
  description = "(Optional) The number of scale units with which to provision the Bastion Host. Possible values are between 2 and 50. Defaults to 2."
  default     = 2

  validation {
    condition     = var.scale_units >= 2 && var.scale_units <= 50
    error_message = "scale_units has to be between 2 and 50!"
  }
}

variable "public_ip_address_id" {
  type        = string
  description = "(Required) Reference to a Public IP Address to associate with this Bastion Host. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}