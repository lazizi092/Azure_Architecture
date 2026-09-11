param location string
param index int

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: 'vnet-${resourceGroup().name}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.${index}.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  parent: virtualNetwork
  name: 'subnet1-${resourceGroup().name}'
  properties: {
    addressPrefix: '10.${index}.0.0/24'
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: 'nic-${resourceGroup().name}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: 'vm-${resourceGroup().name}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ats_v2'
    }

    osProfile: {
      computerName: take(
        toLower('vm${replace(resourceGroup().name, '-', '')}'),
        15
      )
      adminUsername: take(
        toLower('admin${replace(resourceGroup().name, '-', '')}'),
        15
      )
      adminPassword: 'Project1GetHired!'

      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }

    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }

      osDisk: {
        createOption: 'FromImage'
      }
    }

    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}
