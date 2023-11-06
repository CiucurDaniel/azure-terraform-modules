# Update Postgres Version

In order to update the PostgresSQL version of our postgres flexible server instance we have the folowing attributes that we have to change.

```
create_mode = "Update"
version = "14"
```

Therefore, by changing the create mode to update, we tell terrafrom that our intention is to perform an update on the resource and then we specify the version to update to. Issuing terrafrom plan command will output the following plan of exection:


```
terrafrom plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.postgres_flexible_server.azurerm_postgresql_flexible_server.main will be updated in-place
  ~ resource "azurerm_postgresql_flexible_server" "main" {
      ~ create_mode                   = "Default" -> "Update"
        id                            = "/subscriptions/<subscription_id>/resourceGroups/project-test-rg-westeurope/providers/Microsoft.DBforPostgreSQL/flexibleServers/project-test-postgres-flexible-server"
        name                          = "project-test-postgres-flexible-server"
        tags                          = {
            "Demo" = "yes"
        }
      ~ version                       = "13" -> "14"
        # (13 unchanged attributes hidden)

        # (2 unchanged blocks hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Please notice that in this way Terraform says it will `update in place` which means our databases inside the server are safe.



If tou access the service on Azure portal you will see a note about the current update process.

```
The server is currently in upgradingmajorversion state. Please wait for the operation to complete.  You can refresh to check status. Reach out to Microsoft support if the operation is taking too long.
```

**NOTE!** The updating process takes around 14m0s.