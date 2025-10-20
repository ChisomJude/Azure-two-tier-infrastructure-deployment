variable "project_name" {
  type    = string
  default = "finopay-demo"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "web_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "appgw_subnet_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

# Web tier VM settings
variable "web_vm_count" {
  type    = number
  default = 2
}

variable "web_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "web_os_disk_size_gb" {
  type    = number
  default = 128
}

# DB tier VM settings
variable "db_vm_size" {
  type    = string
  default = "Standard_D4s_v3"
}

variable "db_os_disk_size_gb" {
  type    = number
  default = 256
}

# Admin username; password is generated and stored in Key Vault
variable "admin_username" {
  type    = string
  default = "azureadmin"
}

# Toggle Azure SQL (PaaS) in addition to the DB VM
variable "deploy_sql" {
  type    = bool
  default = true
}

# IP allow-list for HTTP/HTTPS to web tier via LB/AppGW (0.0.0.0/0 for demo)
variable "ingress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}