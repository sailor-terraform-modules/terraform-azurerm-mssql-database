

variable "resource_group_name" {
  type        = string
  description = "name of the resource group"
}

variable "server_details" {
  type = list(object({
    administrator_login = string,
    name                = string
    location            = string,
    database_name       = string,
    read_scale          = string
    sku_name            = string,
    zone_redundant      = string,
    max_size_gb         = number
  }))
  description = "value"


}

# variable "db_details" {
#   type = list(object({
#     database_name = string,
#     read_scale = string
#     sku_name = string,
#     zone_redundant = string,
#     max_size_gb = number
#   }))
#   description = "value"


# }

# variable "administrator_login" {
#   type        = string
#   description = "name of the administrator_login"
# }

variable "keyvault_name" {
  type        = string
  description = "name of the administrator_login_password"
}

# variable "mssql_name" {
#   type        = string
#   description = "read_scale"
# }

