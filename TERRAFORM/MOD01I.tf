## MOD-01-I-AUTOMATION

resource "azurerm_automation_account" "lab01i" {
  name                = "${local.lab01_name}-automation-${local.random_str}"
  location            = azurerm_resource_group.dp300.location
  resource_group_name = azurerm_resource_group.dp300.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = local.default_tags
}

resource "azurerm_automation_credential" "lab01i_sqladmin" {
  name                    = "sql-maint-admin"
  resource_group_name     = azurerm_resource_group.dp300.name
  automation_account_name = azurerm_automation_account.lab01i.name
  username                = var.user_name
  password                = var.user_passowrd
  description             = "SQL admin credential for scheduled maintenance runbook."
}

# Runbook keeps Azure SQL DB statistics refreshed and validates integrity.
resource "azurerm_automation_runbook" "lab01i_sql_maintenance" {
  name                    = "sql-maintenance"
  resource_group_name     = azurerm_resource_group.dp300.name
  automation_account_name = azurerm_automation_account.lab01i.name
  location                = azurerm_resource_group.dp300.location
  log_progress            = true
  log_verbose             = true
  runbook_type            = "PowerShell72"
  description             = "Executes Azure SQL Database maintenance (stats refresh + DBCC)."

  content = <<-POWERSHELL
    param (
      [Parameter(Mandatory = $true)]
      [string] $serverfqdn,
      [Parameter(Mandatory = $true)]
      [string] $databasename,
      [Parameter(Mandatory = $true)]
      [string] $credentialname
    )

    $cred = Get-AutomationPSCredential -Name $credentialname
    if (-not $cred) {
      throw "Credential $credentialname not found."
    }

    $connectionString = "Server=tcp:$serverfqdn,1433;Database=$databasename;User ID=$($cred.UserName);Password=$($cred.GetNetworkCredential().Password);Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

    $queries = @(
        "SET NOCOUNT ON; EXEC sp_updatestats;",
        "SET NOCOUNT ON; DBCC CHECKDB WITH NO_INFOMSGS;"
    )

    $connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
    $command = $connection.CreateCommand()

    try {
        $connection.Open()
        foreach ($query in $queries) {
            $command.CommandText = $query
            $command.ExecuteNonQuery() | Out-Null
        }
        Write-Output "Maintenance completed for $databasename on $(Get-Date -Format o)"
    }
    catch {
        Write-Error "Maintenance failed: $($_.Exception.Message)"
        throw
    }
    finally {
        $connection.Close()
    }
  POWERSHELL

  tags = local.default_tags
}

resource "azurerm_automation_schedule" "lab01i_daily" {
  name                    = "sql-maintenance-daily"
  resource_group_name     = azurerm_resource_group.dp300.name
  automation_account_name = azurerm_automation_account.lab01i.name
  frequency               = "Day"
  interval                = 1
  timezone                = "Asia/Taipei"
  start_time              = timeadd(timestamp(), "15m")
  description             = "Daily Azure SQL maintenance window."
}

resource "azurerm_automation_job_schedule" "lab01i_sql_maintenance" {
  resource_group_name     = azurerm_resource_group.dp300.name
  automation_account_name = azurerm_automation_account.lab01i.name
  schedule_name           = azurerm_automation_schedule.lab01i_daily.name
  runbook_name            = azurerm_automation_runbook.lab01i_sql_maintenance.name

  parameters = {
    serverfqdn     = azurerm_mssql_server.lab01.fully_qualified_domain_name
    databasename   = azurerm_mssql_database.lab01d02.name
    credentialname = azurerm_automation_credential.lab01i_sqladmin.name
  }
}
