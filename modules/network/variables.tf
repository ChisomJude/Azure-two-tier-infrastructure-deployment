variable "name"          { default = "net" }
variable "rg_name"       {}
variable "location"      {}
variable "vnet_cidr"     {}
variable "web_subnet_cidr" {}
variable "db_subnet_cidr"  {}
variable "appgw_subnet_cidr" {}
variable "tags" { type = map(string) }
