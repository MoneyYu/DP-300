resource "azapi_resource" "dbwatcher" {
  type      = "Microsoft.DatabaseWatcher/watchers@2024-10-01-preview"
  name      = "${local.lab01_name}-db-watcher-${local.random_str}"
  location  = "Japan West"
  parent_id = azurerm_resource_group.dp300.id

  identity {
    type = "SystemAssigned"
  }

  tags = local.default_tags

  body = {
    properties = {

    }
  }
}

resource "azurerm_key_vault" "keyvault" {
  name                      = "${local.lab01_name}-kv-${random_string.rid.result}"
  location                  = azurerm_resource_group.dp300.location
  resource_group_name       = azurerm_resource_group.dp300.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  purge_protection_enabled  = false
  enable_rbac_authorization = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = local.admin_oid

    key_permissions         = ["Get", "List", "Create", "Delete", "Recover", "Backup", "Restore"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
    certificate_permissions = []
    storage_permissions     = []
  }

  tags = local.default_tags
}
