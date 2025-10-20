resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-vnet"
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.web_subnet_cidr]
}

resource "azurerm_subnet" "db" {
  name                 = "db-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.db_subnet_cidr]
}

resource "azurerm_subnet" "appgw" {
  name                 = "appgw-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.appgw_subnet_cidr]
}

