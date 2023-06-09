# Postgresql flexible server module

Module which allows the creation of a Postgresql flexible server.

## Import existing state

```bash
terraform import module.pg_fs_database.azurerm_postgresql_flexible_server.main <existing_resource_id>

terraform import module.pg_fs_database.azurerm_private_dns_zone_virtual_network_link.main <existing_resource_id>

# vnet link has the following structure
terraform import module.pg_fs_database.azurerm_private_dns_zone_virtual_network_link.main /subscriptions/8f8acc6c-5c90-4578-a1fc-6549f616a053/resourceGroups/<your_rg>/providers/Microsoft.Network/privateDnsZones/<private_dns_zone_name>.postgres.database.azure.com/virtualNetworkLinks/<name_of_vnet_link>
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_postgresql_flexible_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_private_dns_cname_record.entry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_cname_record) | resource |
| [azurerm_private_dns_zone_virtual_network_link.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.psql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.psql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located | `number` | n/a | yes |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days. | `number` | `7` | no |
| <a name="input_charset"></a> [charset](#input\_charset) | Specifies the Charset for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Charset. | `string` | `"utf8"` | no |
| <a name="input_collation"></a> [collation](#input\_collation) | Specifies the Collation for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Collation. | `string` | `"en_US.utf8"` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | value | `string` | `"Default"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the database to be created in the PostgreSQL intance | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The maintenance window block | <pre>object({<br>    day_of_week  = number<br>    start_hour   = number<br>    start_minute = number<br>  })</pre> | `null` | no |
| <a name="input_postgres_admin_password"></a> [postgres\_admin\_password](#input\_postgres\_admin\_password) | The Password associated with the administrator login for the PostgreSQL Flexible Server | `string` | n/a | yes |
| <a name="input_postgres_admin_username"></a> [postgres\_admin\_username](#input\_postgres\_admin\_username) | The administrator login for the PostgreSQL Flexible Server | `string` | n/a | yes |
| <a name="input_postgresql_server_name"></a> [postgresql\_server\_name](#input\_postgresql\_server\_name) | The name which should be used for this PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | n/a | yes |
| <a name="input_postgresql_subnet_name"></a> [postgresql\_subnet\_name](#input\_postgresql\_subnet\_name) | The name of the subnet in which Postgres Flexible Server will be deployed. Subnet needs to be delgated to Microsoft.DBforPostgreSQL/flexibleServers in order to work | `string` | n/a | yes |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | The version of PostgreSQL Flexible Server to use. | `number` | n/a | yes |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | Name for the private dns zone. Suffix is added auotmatically by the module: <private\_dns\_zone\_name>.postgres.database.azure.com | `string` | n/a | yes |
| <a name="input_private_dns_zone_resource_group_name"></a> [private\_dns\_zone\_resource\_group\_name](#input\_private\_dns\_zone\_resource\_group\_name) | The Name of the Resource Group where the Private DNS Zone exists | `string` | n/a | yes |
| <a name="input_private_dns_zone_virtual_network_link"></a> [private\_dns\_zone\_virtual\_network\_link](#input\_private\_dns\_zone\_virtual\_network\_link) | Name of the link between private dns zone and vnet | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group where the PostgreSQL Flexible Server is resources are deployed | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B\_Standard\_B1ms, GP\_Standard\_D2s\_v3, MO\_Standard\_E4s\_v3) | `string` | n/a | yes |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | The max storage allowed for the PostgreSQL Flexible Server. Defaults to smallest size possbile | `number` | `32768` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags for resources created by the module | `map(string)` | `{}` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the vnet which contains the subnet where the PostgreSQL Flexible Server will be deployed | `string` | n/a | yes |
| <a name="input_vnet_resource_group_name"></a> [vnet\_resource\_group\_name](#input\_vnet\_resource\_group\_name) | The name of the resource group where the vnet is deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_postgresql_flexible_server"></a> [azurerm\_postgresql\_flexible\_server](#output\_azurerm\_postgresql\_flexible\_server) | n/a |
| <a name="output_postgres_flexible_server_admin_username"></a> [postgres\_flexible\_server\_admin\_username](#output\_postgres\_flexible\_server\_admin\_username) | n/a |
| <a name="output_postgresql_flexible_server_admin_password"></a> [postgresql\_flexible\_server\_admin\_password](#output\_postgresql\_flexible\_server\_admin\_password) | n/a |
| <a name="output_postgresql_flexible_server_database_name"></a> [postgresql\_flexible\_server\_database\_name](#output\_postgresql\_flexible\_server\_database\_name) | n/a |
| <a name="output_postgresql_flexible_server_fqdn"></a> [postgresql\_flexible\_server\_fqdn](#output\_postgresql\_flexible\_server\_fqdn) | n/a |
| <a name="output_private_dns_cname_record"></a> [private\_dns\_cname\_record](#output\_private\_dns\_cname\_record) | n/a |
