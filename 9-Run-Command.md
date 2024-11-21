# Run Command

Instructions: [Run PowerShell and Shell scripts on Azure Arc-enabled servers using the Run command
](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/day2/arc_run_command)

Check the name of the Connected MAchine agent:
```powershell
$machineName='ServerVM1'
az connectedmachine show --name $machineName --resource-group $Env:resourceGroupName --query "properties.agentVersion"
```