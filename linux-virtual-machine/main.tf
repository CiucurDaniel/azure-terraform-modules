resource "azurerm_network_interface" "main" {
  location            = "value"
  name                = "value"
  resource_group_name = "value"
  ip_configuration {
    name                          = "value"
    private_ip_address_allocation = "value"
  }

}

resource "azurerm_linux_virtual_machine" "main" {
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  location              = var.location
  license_type          = var.license_type
  name                  = var.vm_name
  network_interface_ids = [var.var.primary_network_interface_id, var.additional_network_interface_ids]
  resource_group_name   = "value"
  size                  = "value"
  os_disk {
    caching              = "value"
    storage_account_type = "value"
  }

}