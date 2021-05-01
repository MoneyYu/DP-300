## MOD-01-C-SQL-DATABASE-ELASTIC-POOL
resource "azurerm_mssql_elasticpool" "lab01d" {
  name                = lower(replace(local.lab01d_name_with_postfix, "-", ""))
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  server_name         = azurerm_sql_server.lab01.name
  license_type        = "BasePrice"
  max_size_gb         = 100

  sku {
    name     = "StandardPool"
    tier     = "Standard"
    capacity = 100
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = 100
  }

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_mssql_database" "lab01d" {
  name            = lower(replace(local.lab01d_name_with_postfix, "-", ""))
  server_id       = azurerm_sql_server.lab01.id
  sku_name        = "ElasticPool"
  elastic_pool_id = azurerm_mssql_elasticpool.lab01d.id

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
