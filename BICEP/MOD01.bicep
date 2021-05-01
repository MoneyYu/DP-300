targetScope = 'resourceGroup'

resource vnet 'Microsoft.Network/virtualNetworkGateways@2020-11-01'={
  name:'VNent-${randomString}'
}
