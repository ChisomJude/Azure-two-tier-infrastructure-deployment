resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}

# Optional HTTP/HTTPS for web
resource "azurerm_network_security_rule" "http" {
  count = length(var.http_https_cidrs) > 0 ? 1 : 0
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = var.http_https_cidrs
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "https" {
  count = length(var.http_https_cidrs) > 0 ? 1 : 0
  name                        = "allow-https"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = var.http_https_cidrs
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Optional SQL 1433 from web subnet
resource "azurerm_network_security_rule" "sql" {
  count = var.allow_sql_from_cidr == null ? 0 : 1
  name                        = "allow-sql-1433-from-web"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = var.allow_sql_from_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
