data "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

resource "azurerm_private_dns_zone" "main" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = var.private_dns_zone_virtual_network_link_name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = data.azurerm_virtual_network.main.id
  resource_group_name   = azurerm_private_dns_zone.main.resource_group_name # the resource group where the Private DNS Zone exists
  registration_enabled  = var.registration_enabled
}
