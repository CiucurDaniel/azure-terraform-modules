terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.58.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "main" {
  location = "germanywestcentral"
  name     = "test-rg"
}

resource "azurerm_virtual_network" "main" {
  name                = "test-vnet"
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  location            = "germanywestcentral"
}

module "private_dns_zone" {
  source                   = "./.."
  vnet_name                = azurerm_virtual_network.main.name
  vnet_resource_group_name = azurerm_virtual_network.main.resource_group_name
  private_dns_zone_name    = "test-private-dns-zone.azure.com"
  resource_group_name      = azurerm_resource_group.main.name
  private_dns_zone_virtual_network_link_name = "test-project-vnet-link"
  registration_enabled     = false
  tags = {
    "ManagedBy" = "Terraform"
    "Test"      = "Yes"
  }

  depends_on = [ azurerm_virtual_network.main ]
}
