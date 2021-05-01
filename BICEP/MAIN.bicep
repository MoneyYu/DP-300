param groupName string = 'DP300-${utcNow('MMddHHmm')}'
param location string = 'southeastasia'
param randomString string = '${uniqueString(groupName)}'
param lab01 string = 'lab01'
param lab02 string = 'lab01'
param lab03 string = 'lab01'
param lab04 string = 'lab01'
param lab05 string = 'lab01'
param lab06 string = 'lab01'

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: groupName
  location: location
}
