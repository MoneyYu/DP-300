## MOD-01-A-MSSQL-VM
resource "azurerm_virtual_network" "lab01a" {
  name                = lower(replace(local.lab01a_name_with_postfix, "-", ""))
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_subnet" "lab01a" {
  name                 = lower(replace(local.lab01a_name_with_postfix, "-", ""))
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.lab01a.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "lab01a" {
  name                = lower(replace(local.lab01a_name_with_postfix, "-", ""))
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  allocation_method   = "Dynamic"
  domain_name_label   = lower(local.lab01a_name_with_postfix)

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_network_security_group" "lab01a" {
  name                = lower(replace(local.lab01a_name_with_postfix, "-", ""))
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_network_security_rule" "lab01a01" {
  name                        = "RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "3389"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.group.name
  network_security_group_name = azurerm_network_security_group.lab01a.name
}

resource "azurerm_network_security_rule" "lab01a02" {
  name                        = "MSSQL"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "1433"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.group.name
  network_security_group_name = azurerm_network_security_group.lab01a.name
}

resource "azurerm_network_interface" "lab01a" {
  name                = lower(replace(local.lab01a_name_with_postfix, "-", ""))
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  ip_configuration {
    name                          = lower(replace(local.lab01a_name_with_postfix, "-", ""))
    subnet_id                     = azurerm_subnet.lab01a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab01a.id
  }

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_network_interface_security_group_association" "lab01a" {
  network_interface_id      = azurerm_network_interface.lab01a.id
  network_security_group_id = azurerm_network_security_group.lab01a.id
}

resource "azurerm_windows_virtual_machine" "lab01a" {
  name                  = lower(replace(local.lab01a_name_with_postfix, "-", ""))
  location              = azurerm_resource_group.group.location
  resource_group_name   = azurerm_resource_group.group.name
  network_interface_ids = [azurerm_network_interface.lab01a.id]
  size                  = "Standard_B4ms"

  os_disk {
    name                 = lower(replace(local.lab01a_name_with_postfix, "-", ""))
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2019-ws2019"
    sku       = "SQLDEV"
    version   = "latest"
  }

  computer_name  = local.lab01a_name
  admin_username = local.user_name
  admin_password = local.user_passowrd

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_mssql_virtual_machine" "lab01a" {
  virtual_machine_id               = azurerm_windows_virtual_machine.lab01a.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = true
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_username = local.user_name
  sql_connectivity_update_password = local.user_passowrd

  auto_patching {
    day_of_week                            = "Sunday"
    maintenance_window_duration_in_minutes = 60
    maintenance_window_starting_hour       = 2
  }
}