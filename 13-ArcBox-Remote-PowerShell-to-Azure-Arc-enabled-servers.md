# Remote PowerShell to Azure Arc-enabled servers

[SSH for Arc-enabled servers](https://learn.microsoft.com/azure/azure-arc/servers/ssh-arc-powershell-remoting) enables SSH based PowerShell remote connections to Arc-enabled servers without requiring a public IP address or additional open ports.

From **contoso-Client**:
```powershell
$serverName = "contoso-Ubuntu-01"
$localUser = "jumpstart"
$configFile = "C:\ArcBox\$serverName"

az extension add --name ssh

az ssh config --resource-group $Env:resourceGroupName --name $serverName  --local-user $localUser --resource-type Microsoft.HybridCompute --file "C:\ArcBox\$serverName"
```

This command configures SSH access settings for the Azure Arc-enabled server and saves the SSH (proxy) configuration to a file. This SSH (proxy) configuration file can then be used to facilitate SSH connections without needing to enter all the details every time.

extract the values for the SSH proxy command:
```powershell
# Use a regex pattern to find the ProxyCommand line and extract its value
$proxyCommandPattern = 'ProxyCommand\s+"([^"]+)"\s+-r\s+"([^"]+)"'
$match = Select-String -Path $configFile -Pattern $proxyCommandPattern

$proxyCommandValue1 = [regex]::Match($match.Line, $proxyCommandPattern).Groups[1].Value
$proxyCommandValue2 = [regex]::Match($match.Line, $proxyCommandPattern).Groups[2].Value
$fullProxyCommandValue = "`"$proxyCommandValue1 -r $proxyCommandValue2`""

$options = @{ ProxyCommand = $fullProxyCommandValue }
```

We're ready now to interact with the **contoso-Client** VM using remote PowerShell:
```powershell
# Create PowerShell Remoting session
New-PSSession -HostName $serverName -UserName $localUser -Options $options -OutVariable session

# Run a command
Invoke-Command -Session $session -ScriptBlock {Write-Output "Hello $(whoami) from $(hostname)"}

# Enter an interactive session
Enter-PSSession -Session $session[0]

# Disconnect
exit

# Clean-up
$session | Remove-PSSession
```