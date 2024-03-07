terraform {
  required_version = ">= 1.6.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.93.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.12.1"
    }
  }
}

provider "azurerm" {
  features {}
}