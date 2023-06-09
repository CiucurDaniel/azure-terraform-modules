# Update Kubernetes

## Update control plane

First update the value of `kubernetes version`. Now doing tfplan will show that Terraform can update in place. Proceed with tfapply and wait for Terrafrom to update the control plane.

```hcl
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.aks.azurerm_kubernetes_cluster.main will be updated in-place
  ~ resource "azurerm_kubernetes_cluster" "main" {
        id                                  = "/subscriptions/<subscription_id>/resourceGroups/project-test-rg/providers/Microsoft.ContainerService/managedClusters/project-test-west-europe"
      ~ kubernetes_version                  = "1.24" -> "1.25"
        name                                = "project-test-west-europe"
        tags                                = {}
        # (23 unchanged attributes hidden)

        # (4 unchanged blocks hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

On Azure portal the kubernetes service will show: `Status : Upgrading (Running)`.
After update is finished it should show `Status : Succeeded (Running)`.

## Update version for nodepools

```bash
kubectl get nodes

NAME                               STATUS   ROLES   AGE    VERSION
aks-nodepool-38714297-vmss000000   Ready    agent   5m9s   v1.24.10
aks-user123-13879289-vmss000000    Ready    agent   58s    v1.24.10
```

```bash
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.aks.azurerm_kubernetes_cluster.main will be updated in-place
  ~ resource "azurerm_kubernetes_cluster" "main" {
        id                                  = "/subscriptions/<subscription_id>/resourceGroups/project-test-rg/providers/Microsoft.ContainerService/managedClusters/project-test-west-europe"
        name                                = "project-test-west-europe"
        tags                                = {}
        # (24 unchanged attributes hidden)

      ~ default_node_pool {
            name                         = "nodepool"
          ~ orchestrator_version         = "1.24.10" -> "1.25"
            tags                         = {}
            # (22 unchanged attributes hidden)

            # (1 unchanged block hidden)
        }

        # (3 unchanged blocks hidden)
    }

  # module.aks.azurerm_kubernetes_cluster_node_pool.node_pool["nodepool1"] will be updated in-place
  ~ resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
        id                      = "/subscriptions/<subscription_id>/resourceGroups/project-test-rg/providers/Microsoft.ContainerService/managedClusters/project-test-west-europe/agentPools/user123"
        name                    = "user123"
      ~ orchestrator_version    = "1.24" -> "1.25"
        tags                    = {}
        # (25 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

Plan: 0 to add, 2 to change, 0 to destroy.
```

On Node Pools, `Provisioning state` will change to `Upgrading`.


We see an extra node pool gets created for the system nodepool and the initall one gets tainted with `SchedulingDisabled` to prepare for the update.
```
NAME                               STATUS                     ROLES   AGE     VERSION
aks-nodepool-38714297-vmss000000   Ready,SchedulingDisabled   agent   12m     v1.24.10
aks-nodepool-38714297-vmss000001   Ready                      agent   22s     v1.25.6
aks-user123-13879289-vmss000000    Ready                      agent   7m57s   v1.24.10
```

Then the extra node acts as the original node during the update.
```
NAME                               STATUS   ROLES   AGE     VERSION
aks-nodepool-38714297-vmss000001   Ready    agent   47s     v1.25.6
aks-user123-13879289-vmss000000    Ready    agent   8m22s   v1.24.10
```

The initiall node almost finished updating.
```
NAME                               STATUS     ROLES    AGE    VERSION
aks-nodepool-38714297-vmss000000   NotReady   <none>   5s     v1.25.6
aks-nodepool-38714297-vmss000001   Ready      agent    90s    v1.25.6
aks-user123-13879289-vmss000000    Ready      agent    9m5s   v1.24.10
```

Then the extra node gets deleted and the taint get removed from the initial node because now it has the new Kubernetes version.
```
NAME                               STATUS   ROLES    AGE     VERSION
aks-nodepool-38714297-vmss000000   Ready    <none>   17s     v1.25.6
aks-user123-13879289-vmss000000    Ready    agent    9m17s   v1.24.10
```

The same process happens for the user nodepool.
```
NAME                               STATUS                     ROLES   AGE     VERSION
aks-nodepool-38714297-vmss000000   Ready                      agent   2m46s   v1.25.6
aks-user123-13879289-vmss000000    Ready,SchedulingDisabled   agent   11m     v1.24.10
aks-user123-13879289-vmss000001    Ready                      agent   39s     v1.25.6
```

```
NAME                               STATUS   ROLES   AGE    VERSION
aks-nodepool-38714297-vmss000000   Ready    agent   4m4s   v1.25.6
aks-user123-13879289-vmss000001    Ready    agent   117s   v1.25.6
```

```
Apply complete! Resources: 0 added, 2 changed, 0 destroyed.
```

## TLDR

* 1) Update version on `kubernetes_version` (eg: "1.24" -> "1.25")
* 2) terrafrom plan, terraform apply
* 3) Update version on `orchestrator_version` for default_nodepool and any other nodepools (eg: "1.24" -> "1.25")
* 4) terrafrom plan, terraform apply