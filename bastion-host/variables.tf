variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Bastion Host. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Review Azure Bastion Host FAQ for supported locations"
}

variable "copy_paste_enabled" {
  type        = bool
  description = "(Optional) Is Copy/Paste feature enabled for the Bastion Host. Defaults to true."
  default     = true
}

variable "file_copy_enabled" {
  type        = bool
  description = "(Optional) Is File Copy feature enabled for the Bastion Host. "
  default     = false
}

variable "sku" {
  type        = string
  description = "(Optional) The SKU of the Bastion Host. Accepted values are Basic and Standard. Defaults to Basic."
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "Possible values for sku are Basic or Standard!"
  }
}

variable "ip_configuration" {
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
  description = "The ip_configuration block."
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

variable "shareable_link_enabled" {
  type        = bool
  description = "(Optional) Is Shareable Link feature enabled for the Bastion Host. Defaults to false."
  default     = false
}

variable "tunneling_enabled" {
  type        = bool
  description = "(Optional) Is Tunneling feature enabled for the Bastion Host. Defaults to false."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}
