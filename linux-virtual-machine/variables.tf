# VM

variable "admin_username" {
  type        = string
  description = "(Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
}

variable "admin_password" {
  type        = string
  description = "The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created."
  default     = null
}

variable "location" {
  type        = string
  description = "The Azure location where the Linux Virtual Machine should exist. Changing this forces a new resource to be created."
}

variable "license_type" {
  type        = string
  description = "(Optional) Specifies the BYOL Type for this Virtual Machine. Possible values are RHEL_BYOS and SLES_BYOS."
  default     = "value"

  validation {
    condition     = contains(["RHEL_BYOS", "SLES_BYOS"], var.license_type)
    error_message = "Possible values for license_type are RHEL_BYOS and SLES_BYOS."
  }
}

variable "primary_network_interface_id" {
  type        = string
  description = "The Primary Netwotk interface on the Virtual Machine."
}

variable "additional_network_interface_ids" {
  type        = list(string)
  description = "(Optional) Additional network interfaces to be added to the virtual machine"
}