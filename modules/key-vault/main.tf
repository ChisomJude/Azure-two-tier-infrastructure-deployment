data "azurerm_client_config" "current" {}

# Optionally look up an existing KV
data "azurerm_key_vault" "existing" {
  count               = var.use_existing_kv ? 1 : 0
  name                = var.existing_kv_name
  resource_group_name = var.existing_kv_rg
}

locals {
  
  tmp1          = replace(lower(var.project_name), "-", "")
  tmp2          = replace(local.tmp1, "_", "")
  tmp3          = replace(local.tmp2, " ", "")
  cleaned_prefix = substr(local.tmp3, 0, 18)
  kv_suffix      = substr(md5(var.project_name), 0, 5)
  new_kv_name    = "${local.cleaned_prefix}kv${local.kv_suffix}"

  kv_id   = try(data.azurerm_key_vault.existing[0].id,   azurerm_key_vault.kv[0].id)
  kv_name = try(data.azurerm_key_vault.existing[0].name, azurerm_key_vault.kv[0].name)
}

# Create a new KV only if not using an existing one
resource "azurerm_key_vault" "kv" {
  count               = var.use_existing_kv ? 0 : 1
  name                = local.new_kv_name
  location            = var.location
  resource_group_name = var.rg_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags = var.tags
}

# Generate an admin password to store as a secret
resource "random_password" "admin" {
  length  = 20
  special = true
}

# Access policy for your current identity (works for existing/new)
resource "azurerm_key_vault_access_policy" "me" {
  key_vault_id = local.kv_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "Set", "List"]
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "admin-password"
  value        = random_password.admin.result
  key_vault_id = local.kv_id

  depends_on = [azurerm_key_vault_access_policy.me]
}
