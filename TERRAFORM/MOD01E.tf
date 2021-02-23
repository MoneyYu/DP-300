## MOD-01-E-SQL-DATABASE-HYPERSCALE
resource "azurerm_sql_database" "lab01e" {
  name                = lower(replace(local.lab01e_name_with_postfix, "-", ""))
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  server_name         = azurerm_sql_server.lab01.name
  edition             = "Hyperscale"
  
  tags = {
    environment = local.group_name
  }
}
