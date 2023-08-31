resource "azurerm_static_site" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = var.sku_tier
  sku_size            = var.sku_size

  dyanmic "identity" {
    for_each = var.identity == null ? [] : ["identity"]
    content {
      type         = var.identity.type
      identity_ids = var.identity_ids
    }
  }

  tags = var.tags
}