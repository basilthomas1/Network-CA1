terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-network-ca1"
  location = "UK South"
}

resource "azurerm_container_registry" "acr" {
  name                = "acrnetworkca1basil"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-network-ca1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name              = "app-network-ca1-basil"
  resource_group_name = azurerm_resource_group.rg.name
  location          = azurerm_service_plan.plan.location
  service_plan_id   = azurerm_service_plan.plan.id

  site_config {
    always_on = false
    application_stack {
      docker_image     = "mcr.microsoft.com/azuredocs/aci-helloworld"
      docker_image_tag = "latest"
    }
  }