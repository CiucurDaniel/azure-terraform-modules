output "bastion_host_id" {
  value       = azurerm_bastion_host.main.id
  description = "The ID of the Bastion Host."
}

output "bastion_host_dns_name" {
  value       = azurerm_bastion_host.main.dns_name
  description = "The FQDN for the Bastion Host."
}