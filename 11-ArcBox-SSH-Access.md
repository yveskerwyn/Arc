# SSH access to Azure Arc-enabled servers

On the **Contoso-Client** VM I tested SSH, using "az ssh arc", which allows to establish a secure shell (SSH) connection to my Azure Arc-enabled servers without requiring a public IP address or additional open ports:
```powershell
$Env:resourceGroupName="arcBox1"
$serverName="contoso-Ubuntu-01"
$localUser="jumpstart"
az ssh arc --resource-group $Env:resourceGroupName --name $serverName --local-user $localUser
```

I had to specify the password, which was unexpected since in the instuctions it is stated that *You aren't prompted for a password since ArcBox includes an SSH key-pair installed on ArcBox client VM and the hybrid Linux VMs.*.

Giving it a second thought, this is because I used the command from my local machine, not from the **contoso-Client** VM.

I tried it also for the **contoso-Win2K22** VM:
```powershell
$serverName = "contoso-Win2K22"
$localUser = "Administrator"

az ssh arc --resource-group $Env:resourceGroupName --name $serverName --local-user $localUser
```

Really cool is the using **Remote Desktop** tunneled via SSH:
``` powershell
$serverName = "contoso-Win2K22"
$localUser = "Administrator"

az ssh arc --resource-group $Env:resourceGroupName --name $serverName --local-user $localUser --rdp
```