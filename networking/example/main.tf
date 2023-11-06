terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.56.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

module "networking" {
  source                = "./.." # networking module
  create_resource_group = true
  resource_group_name   = "networking-rg"
  location              = "germanywestcentral"
  create_vnet           = true
  vnet_name             = "vnet-main"
  address_space         = ["10.0.0.0/16"]

  subnets = {
    first_subnet = {
      name                                          = "first-subnet"
      address_prefixes                              = ["10.0.0.0/24"]
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    }

    second_subnet = {
      name              = "second-subnet"
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]

      delegation = {
        name = "fs"

        service_delegation = {
          name = "Microsoft.DBforPostgreSQL/flexibleServers"

          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
          ]
        }
      }
    }
  }

  tags = {
    "ProjectName"     = "test-project"
    "Env"             = "Dev"
    "Owner"           = "Daniel Ciucur"
    "ObjectManagedBy" = "Terraform"
  }
}

output "networking_ouputs" {
  value = module.networking
}
