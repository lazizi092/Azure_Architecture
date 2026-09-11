param location string = 'SouthAfrica North'
param storageAccountName string = 'store${substring(uniqueString(resourceGroup().id), 0, 8)}'
param appServicePlanName string = 'plan${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environment string
var appServiceAppName = 'project1bicepdemoappservice'
var storageAccountSkuName = (environment == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environment == 'prod') ? 'P1v2' : 'F1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
  properties: {
    reserved: true
  }
}
resource appServiceApp 'Microsoft.Web/sites@2025-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    }
  }
