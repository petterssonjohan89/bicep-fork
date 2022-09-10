param namePrefix string
param location string

resource natGatewayIPname 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: '${namePrefix}-net-publicipaddress'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource natgateway 'Microsoft.Network/natGateways@2021-05-01' = {
  name: '${namePrefix}-net-natgateway'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: natGatewayIPname.id
      }
    ]
  }
}

/* Other Resource Group */
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: '${namePrefix}-dms-weu-vnet-test'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.44.21.0/24'
      ]
    }
    subnets: [
      {
        name: '${namePrefix}-weu-subnet-servicedataproc-test'
        properties: {
          addressPrefix: '10.44.21.0/24'
          natGateway: {
            id: natgateway.id
          }
        }
      }
    ]
  }
}