# TODO: Add more relevant outputs for this module

output "azurerm_postgresql_flexible_server" {
  value = azurerm_postgresql_flexible_server.main.name
}

output "postgresql_flexible_server_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgres_flexible_server_admin_username" {
  sensitive = true
  value     = azurerm_postgresql_flexible_server.main.administrator_login
}

output "postgresql_flexible_server_admin_password" {
  sensitive = true
  value     = azurerm_postgresql_flexible_server.main.administrator_password
}

output "postgresql_flexible_server_database_name" {
  value = azurerm_postgresql_flexible_server_database.database.name
}

output "private_dns_cname_record" {
  value = azurerm_private_dns_cname_record.entry.fqdn
}