data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# # FIXME: Keep? This is usefull in order to only get the name/rg and then find out the id instead of taking all 3 as input
data "azurerm_virtual_network" "psql" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

# FIXME: Get subnet name or id?
# We need it, this helps us use subnet name instead of the subnet id as input of module.
# which helps because is hard to ouput id from networking module
data "azurerm_subnet" "psql" {
  name                 = var.postgresql_subnet_name
  virtual_network_name = data.azurerm_virtual_network.psql.name
  resource_group_name  = data.azurerm_virtual_network.psql.resource_group_name
}

data "azurerm_private_dns_zone" "main" {
  name                = var.private_dns_zone_name
  resource_group_name = var.private_dns_zone_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = var.private_dns_zone_virtual_network_link
  private_dns_zone_name = data.azurerm_private_dns_zone.main.name
  virtual_network_id    = data.azurerm_virtual_network.psql.id
  resource_group_name   = data.azurerm_private_dns_zone.main.resource_group_name # the resource group where the Private DNS Zone exists
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                   = var.postgresql_server_name
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  version                = var.postgresql_version
  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password
  create_mode            = var.create_mode
  storage_mb             = var.storage_mb
  sku_name               = var.sku_name
  backup_retention_days  = var.backup_retention_days
  delegated_subnet_id    = data.azurerm_subnet.psql.id
  private_dns_zone_id    = data.azurerm_private_dns_zone.main.id
  zone                   = var.availability_zone

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? toset([var.maintenance_window]) : toset([])

    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week", 0)
      start_hour   = lookup(maintenance_window.value, "start_hour", 0)
      start_minute = lookup(maintenance_window.value, "start_minute", 0)
    }
  }

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  tags = var.tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.main]
}

# FIXME: this will be a for_each
resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = var.collation
  charset   = var.charset

}

# FIXME: this will also be a for_each
resource "azurerm_private_dns_cname_record" "entry" {
  name                = azurerm_postgresql_flexible_server_database.database.name
  zone_name           = data.azurerm_private_dns_zone.main.name
  resource_group_name = data.azurerm_private_dns_zone.main.resource_group_name
  ttl                 = 3600
  record              = azurerm_postgresql_flexible_server.main.fqdn
}
