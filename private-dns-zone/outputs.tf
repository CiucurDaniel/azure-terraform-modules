output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.main.id
  description = "The ID of the Private DNS Zone"
}

output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.main.name
  description = "The name of the Private DNS Zone"
}
