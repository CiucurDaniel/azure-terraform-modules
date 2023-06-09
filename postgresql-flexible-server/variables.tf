variable "resource_group_name" {
  type        = string
  description = "The resource group where the PostgreSQL Flexible Server is resources are deployed"
}

variable "vnet_name" {
  type        = string
  description = "The name of the vnet which contains the subnet where the PostgreSQL Flexible Server will be deployed"
}

variable "vnet_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is deployed"
}

variable "postgresql_subnet_name" {
  type        = string
  description = "The name of the subnet in which Postgres Flexible Server will be deployed. Subnet needs to be delgated to Microsoft.DBforPostgreSQL/flexibleServers in order to work"
}

variable "private_dns_zone_name" {
  type        = string
  description = "Name for the private dns zone. Suffix is added auotmatically by the module: <private_dns_zone_name>.postgres.database.azure.com"
}

variable "private_dns_zone_resource_group_name" {
  type        = string
  description = "The Name of the Resource Group where the Private DNS Zone exists"
}

variable "private_dns_zone_virtual_network_link" {
  type        = string
  description = "Name of the link between private dns zone and vnet"
}

variable "postgresql_server_name" {
  type        = string
  description = "The name which should be used for this PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "postgresql_version" {
  type        = number
  description = "The version of PostgreSQL Flexible Server to use."
}

variable "postgres_admin_username" {
  type        = string
  description = "The administrator login for the PostgreSQL Flexible Server"
}

variable "postgres_admin_password" {
  type        = string
  description = "The Password associated with the administrator login for the PostgreSQL Flexible Server"
}

variable "create_mode" {
  type        = string
  description = "value"
  default     = "Default"

  # FIXME: https://github.com/hashicorp/terraform-provider-azurerm/issues/21821
  # validation {
  #   condition     = contains(["Default", "PointInTimeRestore", "Replica"], var.create_mode)
  #   error_message = "Valid values for create_mode are (Default, PointInTimeRestore, Replica)"
  # }
}

variable "storage_mb" {
  type        = number
  description = "The max storage allowed for the PostgreSQL Flexible Server. Defaults to smallest size possbile"
  default     = 32768

  validation {
    condition     = contains([32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216], var.storage_mb)
    error_message = "Possible values for storage_mb are: 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, and 16777216"
  }
}

variable "sku_name" {
  type        = string
  description = "The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3)"
}

variable "backup_retention_days" {
  type        = number
  description = "The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days."
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days"
  }
}

variable "availability_zone" {
  type        = number
  description = "Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located"

  validation {
    condition     = contains([1, 2, 3], var.availability_zone)
    error_message = "Availability Zone should be: 1, 2 or 3"
  }
}

variable "maintenance_window" {
  type = object({
    day_of_week  = number
    start_hour   = number
    start_minute = number
  })
  description = "The maintenance window block"
  default     = null
}

variable "tags" {
  description = "A map of tags for resources created by the module"
  type        = map(string)
  default     = {}
}

# DBs

variable "database_name" {
  type        = string
  description = "Name of the database to be created in the PostgreSQL intance"
}

variable "charset" {
  type        = string
  description = "Specifies the Charset for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Charset."
  default     = "utf8"
}

variable "collation" {
  type        = string
  description = "Specifies the Collation for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Collation."
  default     = "en_US.utf8"
}

# variable "databases" {
#   description = "Databases to be created in the postgresql flexible server."
#   type = {}
# }