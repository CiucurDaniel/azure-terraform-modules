terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.58.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "germanywestcentral"
}

resource "azurerm_virtual_network" "example" {
  name                = "examplevnet"
  address_space       = ["192.168.1.0/24"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["192.168.1.224/27"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastion-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


module "bastion_host_example" {
  source = "./.."

  name                = "demo-bastion"
  resource_group_name = azurerm_resource_group.example.name
  location            = "germanywestcentral"
  copy_paste_enabled  = true
  file_copy_enabled   = false
  sku                 = "Basic"
  ip_configuration = {
    name                 = "Configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
  ip_connect_enabled     = false
  scale_units            = 2
  shareable_link_enabled = false
  tunneling_enabled      = false
  tags = {
    "Project"           = "DEMO",
    "ResourceManagedBy" = "Terraform"
  }
}
