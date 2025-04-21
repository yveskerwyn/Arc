# Microsoft Entra ID based SSH Login

In order to use the **Entra ID based SSH Login**, we first need to install the **AADSSHLogin** *Azure Arc VM extension*:
```powershell
$Env:resourceGroupName = "Arc-Box1"
$Env:azureLocation = "westeurope"
$serverName = "contoso-Ubuntu-01"

az connectedmachine extension create --machine-name $serverName --resource-group $Env:resourceGroupName --publisher Microsoft.Azure.ActiveDirectory --name AADSSHLogin --type AADSSHLoginForLinux --location $Env:azureLocation
```

In order to persist the environment varialbles, update the environment variables in ``$PROFILE``:
```powershell
code $PROFLE
```

And then reload:
```powershell
. $PROFILE
```

This should also work:
```powershell 
[System.Environment]::SetEnvironmentVariable("azureLocation", "westeurope", "User")
[System.Environment]::SetEnvironmentVariable("azureResourceGroupName", "ArcBox1", "User")
```

Since Visual Studio Code (VS Code) launches PowerShell sessions in a separate context, and it doesn't automatically inherit user environment variables or profile settings, I had to do the following:

```powershell
cd C:\Users\YvesKerwyn\OneDrive - Vreegoebezig\Documents\PowerShell
code Microsoft.PowerShell_profile.ps1
```

I added:
```powershell
$Env:resourceGroupName = "Arc-Box1"
$Env:azureLocation = "westeurope"
```

Later I can always update this executing:
```powershell
code $PROFILE
```

Back to the **AADSSHLogin** *Azure Arc VM extension*, this did take a while to get installed, I checked in the Azure Portal the extensions for the **Contoso-Ubunu-01** VM.

As a next step I checked the roles assigned to me for this VM. Even while I'm owner at the managed group level, I still had to explicitelly assign the **Virtual Machine Administrator Login** and/or **Virtual Machine User Login** roles - if not the following will fail with ``yves@vreegoebezig.be@contoso-ubuntu-01: Permission denied (publickey).``:

Test the **Entra ID based SSH Login**:
```powershell
az ssh arc --resource-group $Env:resourceGroupName --name $serverName
```