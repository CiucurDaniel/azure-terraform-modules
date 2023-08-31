# VM

variable "admin_username" {
    type = string
    description = "(Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
}

variable "location" {

}

variable "license_type" {
  type        = string
  description = "(Optional) Specifies the BYOL Type for this Virtual Machine. Possible values are RHEL_BYOS and SLES_BYOS."
  default     = "value"
}

variable "primary_network_interface_id" {
  type        = string
  description = "The Primary Netwotk interface on the Virtual Machine."
}

variable "additional_network_interface_ids" {
  type        = list(string)
  description = "(Optional) Additional network interfaces to be added to the virtual machine"
}