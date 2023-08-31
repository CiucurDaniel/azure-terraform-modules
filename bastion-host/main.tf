resource "azurerm_bastion_host" "main" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  copy_paste_enabled     = var.copy_paste_enabled
  file_copy_enabled      = var.file_copy_enabled
  sku                    = var.sku
  ip_connect_enabled     = var.ip_connect_enabled
  scale_units            = var.scale_units
  shareable_link_enabled = var.shareable_link_enabled
  tunneling_enabled      = var.tunneling_enabled
  tags                   = var.tags

  dynamic "ip_configuration" {
    for_each = var.ip_configuration == null ? [] : ["ip_configuration"]

    content {
      name                 = var.ip_configuration.name
      subnet_id            = var.ip_configuration.subnet_id
      public_ip_address_id = var.ip_configuration.public_ip_address_id
    }
  }

  lifecycle {
    # scale_units only can be changed when sku is Standard. scale_units is always 2 when sku is Basic
    precondition {
      condition     = !(var.scale_units != 2 && var.sku == "Basic")
      error_message = "scale_units only can be changed when sku is Standard. scale_units is always 2 when sku is Basic"
    }

    # file_copy_enabled is only supported when sku is Standard
    precondition {
      condition     = !(var.file_copy_enabled != false && var.sku == "Basic")
      error_message = "file_copy_enabled is only supported when sku is Standard"
    }

    # ip_connect_enabled is only supported when sku is Standard
    precondition {
      condition     = !(var.ip_connect_enabled != false && var.sku == "Basic")
      error_message = "ip_connect_enabled is only supported when sku is Standard"
    }

    # shareable_link_enabled is only supported when sku is Standard
    precondition {
      condition     = !(var.shareable_link_enabled != false && var.sku == "Basic")
      error_message = "shareable_link_enabled is only supported when sku is Standard"
    }

    # tunneling_enabled is only supported when sku is Standard
    precondition {
      condition     = !(var.tunneling_enabled != false && var.sku == "Basic")
      error_message = "tunneling_enabled is only supported when sku is Standard"
    }
  }
}