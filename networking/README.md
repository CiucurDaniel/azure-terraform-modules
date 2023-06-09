# Azure networking module

Terraform module to create Azure Virtual Network with Subnets and Service Endpoints and Service Delegations.

Following services are supported by the module:


* [Virtual Network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
* [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
* [Subnet Service Delegation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#delegation)
* [Virtual Network service endpoints](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_endpoints)

Resources related to networking that we might support in the future:

* [Private Link service/Endpoint network policies on Subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#enforce_private_link_endpoint_network_policies)
* [AzureNetwork DDoS Protection Plan](https://www.terraform.io/docs/providers/azurerm/r/network_ddos_protection_plan.html)
* [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)
* [Network Security Groups](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)

## How to keep documentation up to date

After any change to the module:

```
terraform-docs markdown table . >> README.md
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.56.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.56.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.networking_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/resources/virtual_network) | resource |
| [azurerm_resource_group.networking_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/data-sources/resource_group) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.56.0/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | List containing address spaces for the vnet | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Boolean value to determine if a resource group should be created else module will query and existing one | `bool` | n/a | yes |
| <a name="input_create_vnet"></a> [create\_vnet](#input\_create\_vnet) | Boolean value to determine if the virtual network should be created or queried | `bool` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the resource group. Only if it's created and not queried | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to query or create | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to be created inside the vnet | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags for resources created by the module | `map(string)` | `{}` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the virtual network to query or create | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_location"></a> [location](#output\_location) | Location of the networking resource group containing the vnet and subnets |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the networking resource group |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | List of address prefix for subnets |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of IDs of subnets |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | Id of the vnet |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Name of the vnet |
