## MOD-01
resource "azurerm_sql_server" "lab01" {
  name                         = lower(replace(local.lab01_name_with_postfix, "-", ""))
  resource_group_name          = azurerm_resource_group.group.name
  location                     = azurerm_resource_group.group.location
  version                      = "12.0"
  administrator_login          = local.user_name
  administrator_login_password = local.user_passowrd

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_sql_firewall_rule" "lab0101" {
  name                = "FirewallRule01"
  resource_group_name = azurerm_resource_group.group.name
  server_name         = azurerm_sql_server.lab01.name
  start_ip_address    = "114.32.33.212"
  end_ip_address      = "114.32.33.212"
}

resource "azurerm_sql_firewall_rule" "lab0102" {
  name                = "FirewallRule02"
  resource_group_name = azurerm_resource_group.group.name
  server_name         = azurerm_sql_server.lab01.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_storage_account" "lab01" {
  name                     = lower(replace(local.lab01_name_with_postfix, "-", ""))
  resource_group_name      = azurerm_resource_group.group.name
  location                 = azurerm_resource_group.group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}