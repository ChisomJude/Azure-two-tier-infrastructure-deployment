output "server_fqdn"   { value = azurerm_mssql_server.srv.fully_qualified_domain_name }
output "database_name" { value = azurerm_mssql_database.db.name }
