## MOD-01-C-SQL-DATABASE
resource "azurerm_mssql_database" "lab01c" {
  name         = lower(replace(local.lab01c_name_with_postfix, "-", ""))
  server_id    = azurerm_sql_server.lab01.id
  sku_name     = "GP_Gen5_2"
  license_type = "BasePrice"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.lab01.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.lab01.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment = local.group_name
  }
}
