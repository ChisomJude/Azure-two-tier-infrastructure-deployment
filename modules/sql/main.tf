resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "random_password" "sql" {
  length  = 20
  special = true
}

resource "azurerm_mssql_server" "srv" {
  name                         = "${var.project_name}-sql-${random_string.suffix.result}"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = random_password.sql.result
  identity { type = "SystemAssigned" }
  tags = var.tags
}

# Allow Azure services to access
resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.srv.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "db" {
  name        = "appdb"
  server_id   = azurerm_mssql_server.srv.id
  sku_name    = "S0"
  tags        = var.tags
}

# Store connection string in Key Vault for apps
resource "azurerm_key_vault_secret" "conn" {
  name         = "sql-connection-string"
  key_vault_id = var.key_vault_id
  value        = "Server=tcp:${azurerm_mssql_server.srv.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};Persist Security Info=False;User ID=${azurerm_mssql_server.srv.administrator_login};Password=${random_password.sql.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
