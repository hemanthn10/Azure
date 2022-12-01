terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
provider "azurerm" {
  features {}

  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = “000000000000000000000”
  tenant_id       = "00000000-0000-0000-0000-000000000000"
}
resource "azurerm_resource_group" "aks" {
  name     = "aks-rg"
  location = "eastus"
}
resource "random_string" "aks_cluster_name" {
  length  = 8
  special = false
}
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-${random_string.aks_cluster_name.result}"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "aks-${random_string.aks_cluster_name.result}"
}
  default_node_pool = {
    name                           = "nodepool1"
    node_count                     = 2
    vm_size                        = "Standard_D2_v3"
    zones                          = ["1", "2"]
    taints                         = null
    cluster_auto_scaling           = false
    cluster_auto_scaling_min_count = null
    cluster_auto_scaling_max_count = null
  }
  additional_node_pools = {
    pool2= {
      node_count                     = 4
      vm_size                        = "Standard_E4_v3"
      zones                          = ["1", "2", "3"]
      node_os                        = "Linux"
      taints                         = null
      cluster_auto_scaling           = true
      cluster_auto_scaling_min_count = 4
      cluster_auto_scaling_max_count = 12
    }
tags = {
    Env = "Production"
  }
