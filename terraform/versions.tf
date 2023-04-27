terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.47.0"
    }
  }
}

data "azurerm_subscription" "current" {}

provider "azurerm" {
  features {}
}