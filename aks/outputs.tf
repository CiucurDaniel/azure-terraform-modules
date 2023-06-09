output "client_certificate" {
  value     = azurerm_kubernetes_cluster.main.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}
