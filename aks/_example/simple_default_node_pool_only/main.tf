# TODO: This example is not yet finished

resource "azurerm_resource_group" "env_rg" {
  location = "westeurope"
  name     = "project-test-rg"
}

module "aks" {
  source = "../aks"

  cluster_name                = "project-test-west-europe"
  cluster_resource_group_name = azurerm_resource_group.env_rg.name
  kubernetes_version          = "1.25"
  node_resource_group         = "project-aks-test-rg"
  aks_sku_tier                = "Free"
  network_plugin              = "kubenet"


  depends_on = [azurerm_resource_group.env_rg]
}
