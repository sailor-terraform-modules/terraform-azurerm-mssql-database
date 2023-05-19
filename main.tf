data "azurerm_key_vault" "key_vault" {
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
}
resource "azurerm_mssql_server" "mssql" {
  for_each                     = { for i in var.server_details : i.name => i }
  name                         = each.value.name
  resource_group_name          = var.resource_group_name
  location                     = each.value.location
  version                      = "12.0"
  administrator_login          = each.value.administrator_login
  administrator_login_password = random_password.password[each.key].result
}

resource "azurerm_mssql_database" "database" {
  for_each       = { for i in var.server_details : i.name => i }
  name           = each.value.database_name
  server_id      = azurerm_mssql_server.mssql[each.key].id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = each.value.max_size_gb
  read_scale     = each.value.read_scale
  sku_name       = each.value.sku_name
  zone_redundant = each.value.zone_redundant

  threat_detection_policy {
    state = "Enabled"
  }
}
resource "random_password" "password" {
  for_each         = { for i in var.server_details : i.name => i }
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_"
  special          = true
  upper            = true


}


resource "azurerm_key_vault_secret" "mysql_password" {
  for_each = { for i in var.server_details : i.name => i }

  name         = "${each.value.name}-password"
  value        = random_password.password[each.key].result
  key_vault_id = data.azurerm_key_vault.key_vault.id

}


resource "azurerm_mssql_firewall_rule" "example" {
  for_each         = { for i in var.server_details : i.name => i }
  name             = "${each.value.name}-rule"
  server_id        = azurerm_mssql_server.mssql[each.key].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
