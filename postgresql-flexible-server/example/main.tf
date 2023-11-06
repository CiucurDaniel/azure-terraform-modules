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
  location = "westeurope"
  name     = "project-test-rg-westeurope"
}

resource "azurerm_virtual_network" "main" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  name                = "project-test-vnet-westeurope"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "psql" {
  name                 = "project-test-psql-subnet-westeurope"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]

  service_endpoints = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "main" {
  name                = "project-test.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

module "postgres_flexible_server" {
  source                                = "./.."
  resource_group_name                   = azurerm_resource_group.main.name
  vnet_name                             = azurerm_virtual_network.main.name
  vnet_resource_group_name              = azurerm_virtual_network.main.resource_group_name
  postgresql_subnet_name                = azurerm_subnet.psql.name
  private_dns_zone_name                 = azurerm_private_dns_zone.main.name
  private_dns_zone_resource_group_name  = azurerm_private_dns_zone.main.resource_group_name
  private_dns_zone_virtual_network_link = "project-test-vnet-link-west-europe"
  postgresql_server_name                = "project-test-postgres-flexible-server"
  postgresql_version                    = 13
  postgres_admin_username               = "user1"
  postgres_admin_password               = "Safepassword1;"
  create_mode                           = "Default"
  storage_mb                            = 32768
  sku_name                              = "B_Standard_B1ms"
  backup_retention_days                 = 7
  availability_zone                     = 3

  maintenance_window = {
    day_of_week  = 0
    start_hour   = 0
    start_minute = 0
  }

  tags = {
    "Demo" = "yes"
  }

  database_name = "test-db"
  charset       = "UTF8"
  collation     = "en_US.utf8"

  depends_on = [azurerm_private_dns_zone.main, azurerm_resource_group.main, azurerm_subnet.psql]
}