resource "azurerm_public_ip" "pip" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "agw" {
  name                = var.name
  resource_group_name = var.rg_name
  location            = var.location

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  ssl_policy {
  policy_type = "Predefined"
  policy_name = "AppGwSslPolicy20220101S"  # TLS 1.2+
}

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "gw-ipcfg"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "fp-80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "feip"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  
  backend_address_pool {
    name         = "bepool"
    ip_addresses = var.backend_ip_addresses  # list(string)
  }

  backend_http_settings {
    name                  = "be-http"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 30
  }

  http_listener {
    name                           = "listener-http"
    frontend_ip_configuration_name = "feip"
    frontend_port_name             = "fp-80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener-http"
    backend_address_pool_name  = "bepool"
    backend_http_settings_name = "be-http"
    priority                   = 100  
  }

  tags = var.tags
}
