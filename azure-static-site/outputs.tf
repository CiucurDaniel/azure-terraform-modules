output "name" {
  value       = azurerm_static_site.main.name
  description = "he name of this Static Web App."
}

output "id" {
  value       = azurerm_static_site.main.id
  description = "The ID of the Static Web App."
}

output "api_key" {
  value       = azurerm_static_site.main.api_key
  description = "The API key of this Static Web App, which is used for later interacting with this Static Web App from other clients, e.g. GitHub Action."
}

output "default_host_name" {
  value       = azurerm_static_site.main.default_host_name
  description = "The default host name of the Static Web App."
}