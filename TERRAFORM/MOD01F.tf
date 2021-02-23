## MOD-01-F-POSTGRESQL
resource "azurerm_postgresql_server" "lab01f" {
  name                = lower(replace(local.lab01f_name_with_postfix, "-", ""))
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = local.user_name
  administrator_login_password = local.user_passowrd
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "lab01f" {
  name                = lower(replace(local.lab01f_name_with_postfix, "-", ""))
  resource_group_name = azurerm_resource_group.group.name
  server_name         = azurerm_postgresql_server.lab01f.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "lab01f01" {
  name                = "Rule01"
  resource_group_name = azurerm_resource_group.group.name
  server_name         = azurerm_postgresql_server.lab01f.name
  start_ip_address    = "114.32.33.212"
  end_ip_address      = "114.32.33.212"
}

resource "azurerm_postgresql_firewall_rule" "lab01f02" {
  name                = "Rule02"
  resource_group_name = azurerm_resource_group.group.name
  server_name         = azurerm_postgresql_server.lab01f.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}