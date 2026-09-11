targetScope = 'subscription'

param resourceGroupNames array = [
  'RG-IT'
  'RG-HR'
  'RG-Finance'
]

param location string = 'southafricanorth'

resource newResourceGroups 'Microsoft.Resources/resourceGroups@2025-04-01' = [
  for rgName in resourceGroupNames: {
    name: rgName
    location: location
  }
]

module rgResources 'rg-resources.bicep' = [
  for (rgName, i) in resourceGroupNames: {
    name: 'deploy-${rgName}'
    scope: resourceGroup(rgName)
    params: {
      location: location
      index: i
    }
    dependsOn: [
      newResourceGroups[i]
    ]
  }
]
