# Inventory Management

Instructions: [Azure Arc-enabled servers inventory management using Resource Graph Explorer](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/day2/arc_inventory_management)

List all hybrid machines:
```sql
Resources
| where type =~ 'Microsoft.HybridCompute/machines'
```

Check for resources that have a value for the Scenario tag:
```sql
Resources
| where type =~ 'Microsoft.HybridCompute/machines' and isnotempty(tags['Scenario'])
| extend Scenario = tags['Scenario']
| project name, tags
```

List extensions installed on our Azure Arc-enabled servers:
```sql
Resources
| where type == 'microsoft.hybridcompute/machines'
| project id, JoinID = toupper(id), ComputerName = tostring(properties.osProfile.computerName), OSName = tostring(properties.osName)
| join kind=leftouter(
    Resources
    | where type == 'microsoft.hybridcompute/machines/extensions'
    | project MachineId = toupper(substring(id, 0, indexof(id, '/extensions'))), ExtensionName = name
) on $left.JoinID == $right.MachineId
| summarize Extensions = make_list(ExtensionName) by id, ComputerName, OSName
| order by tolower(OSName) desc
```
List the Azure Arc Agent version installed on your Azure Arc-enabled servers:
```sql
Resources
| where type =~ 'Microsoft.HybridCompute/machines'
| extend arcAgentVersion = tostring(properties.['agentVersion']), osName = tostring(properties.['osName']), osVersion = tostring(properties.['osVersion']), osSku = tostring(properties.['osSku']),
lastStatusChange = tostring(properties.['lastStatusChange'])
| project name, arcAgentVersion, osName, osVersion, osSku, lastStatusChange
```