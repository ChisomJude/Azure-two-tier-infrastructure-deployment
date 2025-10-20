
resource "random_string" "suffix" {
  count   = var.vm_count
  length  = 4
  upper   = false
  special = false
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = "admin-password"
  key_vault_id = var.admin_password_secret_id
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.prefix}-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

locals {
  _p1   = lower(var.prefix)
  _p2   = replace(local._p1, "-", "")
  _p3   = replace(local._p2, "_", "")
  _p4   = replace(local._p3, " ", "")
  short = substr(local._p4, 0, 12)   # leaves room for index suffix
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.prefix}-vm-${random_string.suffix[count.index].result}"
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = data.azurerm_key_vault_secret.admin_password.value
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  availability_set_id   = var.availability_set_id
  computer_name = "${local.short}${count.index + 1}"
  
  os_disk {
    name                 = "${var.prefix}-osdisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = var.tags
}
