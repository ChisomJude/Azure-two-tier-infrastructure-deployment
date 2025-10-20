variable "rg_name"       { type = string }
variable "location"      { type = string }
variable "project_name"  { type = string }
variable "tags"          { type = map(string) }

#  use an any existing Key Vault instead of creating one
variable "use_existing_kv" {
  type        = bool
  description = "If true, look up an existing Key Vault by name and RG."
  default     = false
}

variable "existing_kv_name" {
  type        = string
  description = "Existing Key Vault name (required if use_existing_kv=true)."
  default     = null
}

variable "existing_kv_rg" {
  type        = string
  description = "Resource group of the existing Key Vault (required if use_existing_kv=true)."
  default     = null
}


variable "admin_username" {
  type        = string
  default     = "azureadmin"
}
