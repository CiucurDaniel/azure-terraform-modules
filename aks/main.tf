locals {
  # The default node_pool has a subnet 
  # and each subsequent additional node_pool may have a different subnet, therefore we need to get a list
  # with all of them in order to give the network contributor role for each subnet involved
  potential_subnet_ids = flatten(concat([
    for pool in var.node_pools : [
      pool.vnet_subnet_id,
      pool.pod_subnet_id
    ]
  ], [var.vnet_subnet_id]))
  subnet_ids = toset([for id in local.potential_subnet_ids : id if id != null])
}

data "azurerm_resource_group" "cluster" {
  name = var.cluster_resource_group_name
}

data "azurerm_log_analytics_workspace" "main" {
  count               = var.microsoft_defender_enabled ? 1 : 0
  name                = var.log_analytics_workspace["name"]
  resource_group_name = var.log_analytics_workspace["resource_group_name"]
}

# FIXME: We have option to provide azurerm_log_analytics_workspace, in the future the module can provide azurerm_log_analytics_solution resource as well

resource "azurerm_kubernetes_cluster" "main" {
  name                 = var.cluster_name
  resource_group_name  = data.azurerm_resource_group.cluster.name
  location             = coalesce(var.location, data.azurerm_resource_group.cluster.location)
  sku_tier             = var.aks_sku_tier
  dns_prefix           = var.cluster_dns_prefix == null ? var.cluster_name : var.cluster_dns_prefix
  kubernetes_version   = var.kubernetes_version
  azure_policy_enabled = var.azure_policy_enabled

  node_resource_group = var.node_resource_group

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]

    content {
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      enable_auto_scaling          = var.enable_auto_scaling
      enable_host_encryption       = var.enable_host_encryption
      enable_node_public_ip        = var.enable_node_public_ip
      max_count                    = null
      max_pods                     = var.agents_max_pods
      min_count                    = null
      node_count                   = var.agents_count
      node_labels                  = var.agents_labels
      node_taints                  = var.agents_taints
      only_critical_addons_enabled = var.only_critical_addons_enabled
      orchestrator_version         = var.orchestrator_version
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      os_sku                       = var.os_sku
      pod_subnet_id                = var.pod_subnet_id
      scale_down_mode              = var.scale_down_mode
      tags                         = merge(var.tags, var.agents_tags)
      temporary_name_for_rotation  = var.temporary_name_for_rotation
      type                         = var.agents_type
      ultra_ssd_enabled            = var.ultra_ssd_enabled
      vnet_subnet_id               = var.vnet_subnet_id
      zones                        = var.agents_availability_zones
      upgrade_settings {
        max_surge = var.agent_upgrade_max_surge
      }

      # FEATURE: kubelet_config block could also be configured here
      # FEATURE: linux_os_config could also be configured here
    }
  } // end nodepool manually scaled 

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []

    content {
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      enable_auto_scaling          = var.enable_auto_scaling
      enable_host_encryption       = var.enable_host_encryption
      enable_node_public_ip        = var.enable_node_public_ip
      max_count                    = var.agents_max_count
      max_pods                     = var.agents_max_pods
      min_count                    = var.agents_min_count
      node_labels                  = var.agents_labels
      node_taints                  = var.agents_taints
      only_critical_addons_enabled = var.only_critical_addons_enabled
      orchestrator_version         = var.orchestrator_version
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      os_sku                       = var.os_sku
      pod_subnet_id                = var.pod_subnet_id
      scale_down_mode              = var.scale_down_mode
      tags                         = merge(var.tags, var.agents_tags)
      temporary_name_for_rotation  = var.temporary_name_for_rotation
      type                         = var.agents_type
      ultra_ssd_enabled            = var.ultra_ssd_enabled
      vnet_subnet_id               = var.vnet_subnet_id
      zones                        = var.agents_availability_zones
      upgrade_settings {
        max_surge = var.agent_upgrade_max_surge
      }

      # FEATURE: kubelet_config block could also be configured here
      # FEATURE: linux_os_config block could also be configured here
    }
  } // end nodepool automatically scalled


  # INFO: Currently we support only SystemAssigned type of identity. 
  # User-assigned is not supported and not planned to be soon
  # For more details see: https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types
  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = var.network_plugin
    dns_service_ip      = var.net_profile_dns_service_ip
    load_balancer_sku   = var.load_balancer_sku
    network_plugin_mode = var.network_plugin_mode
    network_policy      = var.network_policy
    outbound_type       = var.net_profile_outbound_type
    pod_cidr            = var.net_profile_pod_cidr
    service_cidr        = var.net_profile_service_cidr

    # FEATURE: load balancer profile block could also be configured here in the future
  }

  dynamic "microsoft_defender" {
    for_each = var.microsoft_defender_enabled ? ["microsoft_defender"] : []

    content {
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.main.0.id
    }
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  for_each = var.node_pools

  kubernetes_cluster_id         = azurerm_kubernetes_cluster.main.id
  name                          = each.value.name
  vm_size                       = each.value.vm_size
  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  custom_ca_trust_enabled       = each.value.custom_ca_trust_enabled
  enable_auto_scaling           = each.value.enable_auto_scaling
  enable_host_encryption        = each.value.enable_host_encryption
  enable_node_public_ip         = each.value.enable_node_public_ip
  eviction_policy               = each.value.eviction_policy
  fips_enabled                  = each.value.fips_enabled
  host_group_id                 = each.value.host_group_id
  kubelet_disk_type             = each.value.kubelet_disk_type
  max_count                     = each.value.max_count
  max_pods                      = each.value.max_pods
  message_of_the_day            = each.value.message_of_the_day
  min_count                     = each.value.min_count
  mode                          = each.value.mode
  node_count                    = each.value.node_count
  node_labels                   = each.value.node_labels
  node_public_ip_prefix_id      = each.value.node_public_ip_prefix_id
  node_taints                   = each.value.node_taints
  orchestrator_version          = each.value.orchestrator_version
  os_disk_size_gb               = each.value.os_disk_size_gb
  os_disk_type                  = each.value.os_disk_type
  os_sku                        = each.value.os_sku
  os_type                       = each.value.os_type
  pod_subnet_id                 = each.value.pod_subnet_id
  priority                      = each.value.priority
  proximity_placement_group_id  = each.value.proximity_placement_group_id
  scale_down_mode               = each.value.scale_down_mode
  spot_max_price                = each.value.spot_max_price
  tags                          = each.value.tags
  ultra_ssd_enabled             = each.value.ultra_ssd_enabled
  vnet_subnet_id                = each.value.vnet_subnet_id
  workload_runtime              = each.value.workload_runtime
  zones                         = each.value.zones

  # FEATURE: kubelet_config block could also be configured here
  # FEATURE: linux_os_config block could also be configured here

  dynamic "node_network_profile" {
    for_each = each.value.node_network_profile == null ? [] : ["node_network_profile"]

    content {
      node_public_ip_tags = each.value.node_network_profile.node_public_ip_tags
    }
  }

  dynamic "upgrade_settings" {
    for_each = each.value.upgrade_settings == null ? [] : ["upgrade_settings"]

    content {
      max_surge = each.value.upgrade_settings.max_surge
    }
  }

  dynamic "windows_profile" {
    for_each = each.value.windows_profile == null ? [] : ["windows_profile"]

    content {
      outbound_nat_enabled = each.value.windows_profile.outbound_nat_enabled
    }
  }

  lifecycle {
    create_before_destroy = true

    precondition {
      condition     = var.agents_type == "VirtualMachineScaleSets"
      error_message = "Multiple Node Pools are only supported when the Kubernetes Cluster is using Virtual Machine Scale Sets."
    }
    precondition {
      condition     = can(regex("[a-z0-9]{1,8}", each.value.name))
      error_message = "A Node Pools name must consist of alphanumeric characters and have a maximum lenght of 8 characters"
    }
    precondition {
      condition     = var.network_plugin_mode != "Overlay" || each.value.os_type != "Windows"
      error_message = "Windows Server 2019 node pools are not supported for Overlay and Windows support is still in preview"
    }
    precondition {
      condition     = var.network_plugin_mode != "Overlay" || !can(regex("^Standard_DC[0-9]+s?_v2$", each.value.vm_size))
      error_message = "With with Azure CNI Overlay you can't use DCsv2-series virtual machines in node pools. "
    }
  }
}

# TODO: Because of the Kubenet plugin we have a route table created in the node resource group.
# on that rt we also have to entries toDaimler and toFirewall how can we do it from Terraform?


# The AKS cluster identity has the Contributor role on the AKS second resource group (MC_myResourceGroup_myAKSCluster_eastus)
# However when using a custom VNET, the AKS cluster identity needs the Network Contributor role on the VNET subnets
# used by the system node pool and by any additional node pools.
# https://learn.microsoft.com/en-us/azure/aks/configure-kubenet#prerequisites
# https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni#prerequisites
# https://github.com/Azure/terraform-azurerm-aks/issues/178
resource "azurerm_role_assignment" "network_contributor" {
  for_each = var.create_role_assignment_network_contributor ? local.subnet_ids : []

  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
  scope                = each.value
  role_definition_name = "Network Contributor"
}

# See more: https://learn.microsoft.com/en-us/azure/private-link/rbac-permissions#private-link-service
resource "azurerm_role_definition" "pls" {
  count = var.create_role_assignment_private_link_service ? 1 : 0

  name  = "aks-private-link-service-role"
  scope = data.azurerm_resource_group.cluster.id

  permissions {
    actions = [
      "Microsoft.Resources/deployments/*",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/virtualNetworks/subnets/write",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/privateEndpoints/read",
      "Microsoft.Network/privateEndpoints/write",
      "Microsoft.Network/locations/availablePrivateEndpointTypes/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_resource_group.cluster.id,
  ]
}

resource "azurerm_role_assignment" "pls" {
  count = var.create_role_assignment_private_link_service ? 1 : 0

  scope              = data.azurerm_resource_group.cluster.id
  role_definition_id = try(azurerm_role_definition.pls[count.index].pls.role_definition_id)
  principal_id       = azurerm_kubernetes_cluster.main.identity[0].principal_id

  # The above reads as grant principal_id () which is the system identity of the cluster
  # the role with id (role_definiton_id) over the scope resource group of the cluster
  # IMPORTANT: in this context it means you can only deploy PLS in the resource group of the cluster and the node resource group which works by default without this role assignment
}