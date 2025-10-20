resource "azurerm_recovery_services_vault" "rsv" {
  name                = "${var.name}-rsv"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  soft_delete_enabled = true
  tags                = var.tags
}

resource "azurerm_backup_policy_vm" "default" {
  name                = "daily-policy"
  resource_group_name = var.rg_name
  recovery_vault_name = azurerm_recovery_services_vault.rsv.name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}

locals {
  vm_keys = [for i in range(var.total_vm_count) : tostring(i)]
  vm_map  = { for k in local.vm_keys : k => var.vm_ids[tonumber(k)] }
}
# Protect all VMs passed in
resource "azurerm_backup_protected_vm" "protected" {
  for_each            = local.vm_map
  resource_group_name = var.rg_name
  recovery_vault_name = azurerm_recovery_services_vault.rsv.name
  source_vm_id        = each.value
  backup_policy_id    = azurerm_backup_policy_vm.default.id
}