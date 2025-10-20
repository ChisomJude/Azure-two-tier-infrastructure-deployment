locals {
  rg_name = "${var.project_name}-rg"
  tags = {
    project = var.project_name
    env     = "demo"
  }
}

module "rg" {
  source   = "./modules/resource-group"
  name     = local.rg_name
  location = var.location
  tags     = local.tags
}

module "kv" {
  source         = "./modules/key-vault"
  rg_name        = module.rg.name
  location       = var.location
  project_name   = var.project_name
  admin_username = var.admin_username
  tags           = local.tags
}


module "network" {
  source            = "./modules/network"
  rg_name           = module.rg.name
  location          = var.location
  vnet_cidr         = var.vnet_cidr
  web_subnet_cidr   = var.web_subnet_cidr
  db_subnet_cidr    = var.db_subnet_cidr
  appgw_subnet_cidr = var.appgw_subnet_cidr
  tags              = local.tags
}

module "nsg_web" {
  source              = "./modules/nsg"
  rg_name             = module.rg.name
  location            = var.location
  name                = "${var.project_name}-web-nsg"
  subnet_id           = module.network.web_subnet_id
  http_https_cidrs    = var.ingress_cidrs
  allow_sql_from_cidr = null
  tags                = local.tags
}

module "nsg_db" {
  source    = "./modules/nsg"
  rg_name   = module.rg.name
  location  = var.location
  name      = "${var.project_name}-db-nsg"
  subnet_id = module.network.db_subnet_id
  # Allow SQL 1433 from web-subnet only
  http_https_cidrs    = []
  allow_sql_from_cidr = var.web_subnet_cidr
  tags                = local.tags
}

module "web_avset" {
  source   = "./modules/availability-set"
  rg_name  = module.rg.name
  location = var.location
  name     = "${var.project_name}-web-avset"
  tags     = local.tags
}

module "web_vms" {
  source                   = "./modules/vm"
  rg_name                  = module.rg.name
  location                 = var.location
  prefix                   = "${var.project_name}-web"
  vm_count                 = var.web_vm_count
  subnet_id                = module.network.web_subnet_id
  availability_set_id      = module.web_avset.availability_set_id
  vm_size                  = var.web_vm_size
  os_disk_size_gb          = var.web_os_disk_size_gb
  admin_username           = var.admin_username
  admin_password_secret_id = module.kv.admin_password_secret_id
  tags                     = local.tags
}

module "db_vm" {
  source                   = "./modules/vm"
  rg_name                  = module.rg.name
  location                 = var.location
  prefix                   = "${var.project_name}-db"
  vm_count                 = 1
  subnet_id                = module.network.db_subnet_id
  availability_set_id      = null
  vm_size                  = var.db_vm_size
  os_disk_size_gb          = var.db_os_disk_size_gb
  admin_username           = var.admin_username
  admin_password_secret_id = module.kv.admin_password_secret_id
  tags                     = local.tags
}


module "lb" {
  source          = "./modules/load-balancer"
  rg_name         = module.rg.name
  location        = var.location
  name            = "${var.project_name}-lb"
  backend_nic_ids = module.web_vms.nic_ids
  tags            = local.tags
}

module "appgw" {
  source               = "./modules/app-gateway"
  rg_name              = module.rg.name
  location             = var.location
  name                 = "${var.project_name}-agw"
  subnet_id            = module.network.appgw_subnet_id
  backend_ip_addresses = module.web_vms.private_ips
  tags                 = local.tags
}

module "sql" {
  source       = "./modules/sql"
  count        = var.deploy_sql ? 1 : 0
  rg_name      = module.rg.name
  location     = var.location
  project_name = var.project_name
  key_vault_id = module.kv.id
  tags         = local.tags
}

module "backup" {
  source         = "./modules/backup"
  rg_name        = module.rg.name
  location       = var.location
  vm_ids         = concat(module.web_vms.vm_ids, module.db_vm.vm_ids)
  total_vm_count = var.web_vm_count + 1 # web VMs + 1 DB VM
  tags           = local.tags
}