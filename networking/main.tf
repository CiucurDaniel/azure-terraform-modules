# Networking module takes care of VNET and its subnets

locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.networking.*.name, azurerm_resource_group.networking.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.networking.*.location, azurerm_resource_group.networking.*.location, [""]), 0)
  vnet_name           = element(coalescelist(data.azurerm_virtual_network.vnet.*.name, azurerm_virtual_network.vnet.*.name, [""]), 0)
}

data "azurerm_resource_group" "networking" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "networking" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_virtual_network" "vnet" {
  count               = var.create_vnet == false ? 1 : 0
  name                = var.vnet_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.create_vnet ? 1 : 0
  name                = var.vnet_name
  address_space       = var.address_space
  location            = local.location
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.value.name
  virtual_network_name = local.vnet_name           # because we use local we have to explicitely tell terraform about the dependency with depends_on block
  resource_group_name  = local.resource_group_name # all subnets should be under the same rg as the vnet right?

  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", true)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", true)

  address_prefixes  = each.value.address_prefixes
  service_endpoints = lookup(each.value, "service_endpoints", [])

  dynamic "delegation" {

    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []

    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]

}
