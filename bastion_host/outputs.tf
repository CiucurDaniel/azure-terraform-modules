output "bastion_host_id" {
  value       = azurerm_bastion_host.name.id
  description = "The ID of the Bastion Host."
}

output "bastion_host_dns_name" {
  value       = azurerm_bastion_host.name.dns_name
  description = "The FQDN for the Bastion Host."
}