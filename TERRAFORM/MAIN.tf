terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you are using version 1.x, the "features" block is not allowed.
  # version = "~>2.0"
  features {}
  # Use Azure CLI to authencation
}

locals {
  group_name               = "DP300-${formatdate("MMDDHHmm", timestamp())}"
  location                 = "southeastasia"
  random_name              = random_string.rid.result
  lab01_name               = "LAB01"
  lab01a_name              = "LAB01A"
  lab02_name               = "LAB02"
  lab03_name               = "LAB03"
  lab04_name               = "LAB04"
  lab05_name               = "LAB05"
  lab06_name               = "LAB06"
  lab07_name               = "LAB07"
  lab08_name               = "LAB08"
  lab09_name               = "LAB09"
  lab10_name               = "LAB10"
  lab10b_name              = "LAB10B"
  lab11_name               = "LAB11"
  lab12_name               = "LAB12"
  lab13_name               = "LAB13"
  lab14_name               = "LAB14"
  lab15_name               = "LAB15"
  lab16_name               = "LAB16"
  lab01_name_with_postfix  = "${local.lab01_name}${local.random_name}"
  lab01a_name_with_postfix = "${local.lab01a_name}${local.random_name}"
  lab02_name_with_postfix  = "${local.lab02_name}${local.random_name}"
  lab03_name_with_postfix  = "${local.lab03_name}${local.random_name}"
  lab04_name_with_postfix  = "${local.lab04_name}${local.random_name}"
  lab05_name_with_postfix  = "${local.lab05_name}${local.random_name}"
  lab06_name_with_postfix  = "${local.lab06_name}${local.random_name}"
  lab07_name_with_postfix  = "${local.lab07_name}${local.random_name}"
  lab08_name_with_postfix  = "${local.lab08_name}${local.random_name}"
  lab09_name_with_postfix  = "${local.lab09_name}${local.random_name}"
  lab10_name_with_postfix  = "${local.lab10_name}${local.random_name}"
  lab10b_name_with_postfix = "${local.lab10b_name}${local.random_name}"
  lab11_name_with_postfix  = "${local.lab11_name}${local.random_name}"
  lab12_name_with_postfix  = "${local.lab12_name}${local.random_name}"
  lab13_name_with_postfix  = "${local.lab13_name}${local.random_name}"
  lab14_name_with_postfix  = "${local.lab14_name}${local.random_name}"
  lab15_name_with_postfix  = "${local.lab15_name}${local.random_name}"
  lab16_name_with_postfix  = "${local.lab16_name}${local.random_name}"
  user_name                = "demouser"
  user_passowrd            = "Azuredemo2020"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "azurerm_client_config" "current" {}

resource "random_string" "rid" {
  length  = 3
  special = false
  number  = false
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "group" {
  name     = local.group_name
  location = local.location

  tags = {
    environment = local.group_name
  }
}
