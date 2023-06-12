locals {
  bastion_subnet_mask = split(data.azurerm_subnet.bastion.address_space, "/")[1] >= 26
}

data "azurerm_subnet" "bastion" {
  count = var.ip_configuration != null ? 1 : 0
  name  = var.ip_configuration.name
  id    = var.ip_configuration.subnet_id
}

resource "azurerm_bastion_host" "main" {
  location             = var.location
  name                 = var.name
  resource_group_name  = var.resource_group_name
  copy_paste_enabled   = var.copy_paste_enabled
  file_copy_enabled    = var.file_copy_enabled
  sku                  = var.sku
  ip_configuration     = var.ip_configuration
  ip_connect_enabled   = var.ip_connect_enabled
  scale_units          = var.scale_units
  public_ip_address_id = var.public_ip_address_id
  tags                 = var.tags

  lifecycle {
    # scale_units only can be changed when sku is Standard. scale_units is always 2 when sku is Basic
    precondition {
      condition     = !(var.scale_units != 2 && var.sku == "Basic")
      error_message = "scale_units only can be changed when sku is Standard. scale_units is always 2 when sku is Basic"
    }

    # file_copy_enabled is only supported when sku is Standard
    precondition {
      condition     = ((var.file_copy_enabled == true && var.sku == "Standard") || (var.file_copy_enabled == false && var.sku == "Basic"))
      error_message = "file_copy_enabled is only supported when sku is Standard"
    }

    # ip_connect_enabled is only supported when sku is Standard
    precondition {
      condition     = ((var.ip_connect_enabled == true && var.sku == "Standard") || (var.ip_connect_enabled == false && var.sku == "Basic"))
      error_message = "ip_connect_enabled is only supported when sku is Standard"
    }

    # subnet used for the Bastion Host must have the subnet mask must be at least a /26.
    precondition {
      condition     = local.bastion_subnet_mask >= 26
      error_message = "The Subnet used for the Bastion Host must have the subnet mask must be at least a /26."
    }
  }
}
