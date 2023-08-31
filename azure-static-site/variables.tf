variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Static Web App. Changing this forces a new Static Web App to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the Static Web App should exist. Changing this forces a new Static Web App to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Static Web App should exist. Changing this forces a new Static Web App to be created."
}

variable "sku_tier" {
  type        = string
  description = "(Optional) Specifies the SKU tier of the Static Web App. Possible values are Free or Standard. Defaults to Free."
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "sku_tier must be Free or Standard"
  }
}

variable "sku_size" {
  type        = string
  description = "(Optional) Specifies the SKU size of the Static Web App. Possible values are Free or Standard. Defaults to Free."
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "sku_size must be Free or Standard"
  }
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = <<-EOT
    object({
      type = "(Required) The Type of Managed Identity assigned to this Static Site resource. Possible values are SystemAssigned, UserAssigned and SystemAssigned, UserAssigned."
      identity_ids = "(Optional) A list of Managed Identity IDs which should be assigned to this Static Site resource."
    })
    EOT
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resources created by this module."
  default     = null
}