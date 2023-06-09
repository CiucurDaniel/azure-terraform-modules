output "resource_group_name" {
  value       = element(concat(azurerm_resource_group.networking.*.name, [""]), 0)
  description = "Name of the networking resource group"
}

output "location" {
  value       = azurerm_resource_group.networking.*.location
  description = "Location of the networking resource group containing the vnet and subnets"
}

output "vnet_id" {
  value       = element(concat(azurerm_virtual_network.vnet.*.id, [""]), 0)
  description = "Id of the vnet"
}

output "vnet_name" {
  value       = element(concat(azurerm_virtual_network.vnet.*.name, [""]), 0)
  description = "Name of the vnet"
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = [for s in azurerm_subnet.subnet : s.id]
}

output "subnet_names" {
  description = "List of names of subnets"
  value       = [for s in azurerm_subnet.subnet : s.name]
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"
  value       = [for s in azurerm_subnet.subnet : s.address_prefixes]
}