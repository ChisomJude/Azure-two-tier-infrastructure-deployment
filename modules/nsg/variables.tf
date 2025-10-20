variable "rg_name" {}

variable "location" {}

variable "name" {}

variable "subnet_id" {}

variable "http_https_cidrs" {
  type = list(string)
}

variable "allow_sql_from_cidr" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}
