# 1. Resource Group — name includes your name (required)
resource "azurerm_resource_group" "rg" {
  name     = "rg-cloudscale-${var.name_prefix}"
  location = var.location
  tags = {
    Project     = "Final"
    StudentName = var.student_name
  }
}

# 2. Azure Container Registry — Basic SKU
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
  tags = {
    Project     = "Final"
    StudentName = var.student_name
  }
}

# 3. AKS cluster — 2 nodes, Standard_B2s
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cloudscale-${var.name_prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "cloudscale"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Project     = "Final"
    StudentName = var.student_name
  }
}

# 4. AKS -> ACR integration (automatic pull, NO secrets)
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}
