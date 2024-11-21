# ArcBox

Following the instructions for [Jumpstart ArcBox for IT Pros](https://azurearcjumpstart.io/azure_jumpstart_arcbox/ITPro)

In case you need to your ArcBox client again:
```powershell
az vm start --resource-group $Env:resourceGroupName --name "contoso-Client"
```

Checking all subscriptions:
```powershell
az account list --output table
```

Check which is the default subscription:
```powershell
az account list --query "[?isDefault]"
```

If you need to change the default subscription, you can specify the subscription name of ID:
```powershell
az account set --subscription "Microsoft Partner Network"
```

Check my current vCPU utilization:
```powershell
az vm list-usage --location "westeurope" --output table
```

Or - didn't work:
```powershell
az vm list-usage --location "westeurope" --output table --query "[?name.value=='Standard DSv5 Family vCPUs']"
```

Making sure all necessary Azure resource providers are registered:
```bash
az provider register --namespace Microsoft.HybridCompute --wait
az provider register --namespace Microsoft.GuestConfiguration --wait
az provider register --namespace Microsoft.AzureArcData --wait
az provider register --namespace Microsoft.OperationsManagement --wait
```

## Using the Bicep deployment option.

```powershell
az bicep upgrade
```

Updating [main.bicepparam](azure_jumpstart_arcbox\bicep\main.bicepparam):
```powershell
cd C:\Code\Repos\GitHub\azure_arc\
cd azure_jumpstart_arcbox
cd bicep
code main.bicepparam
```

Create a resource group and start the deployment:
```powershell
resourceGroupName="arcBox1"
az group create --name $resourceGroupName --location "westeurope"
az deployment group create -g $resourceGroupName -f "main.bicep" -p "main.bicepparam"
```

Innitialy I got an error about `autoShutdownTimezone` parameter, I specified **CET**, I had to change it to:
```shell
param autoShutdownTimezone = 'Central European Standard Time'
```

Following issue was useful in that regard: [New-AzResource timezone issue "Incorrect required property 'TimeZoneId'" #20467](https://github.com/Azure/azure-powershell/issues/20467)

I added an inbound security rule to the ``contoso-NSG`` network security group.

When logging in to the client I ran into following issue: [Logon scripts on ARCBoxClient machine fail! #2845](https://github.com/microsoft/azure_arc/issues/2845)

As I first attemt to solve the problem I manually renamed the **ArcBox-SQL** to **contoso-SQL** in the folder ``F:\Virtual Machines``, and rebooted.

Checking the login script:
C:\Code\Repos\GitHub\azure_arc\azure_jumpstart_arcbox\artifacts\ArcServersLogonScript.ps1

At some point the script halted and asked my wether I was sure I wanted to restart ´contoso-Ubuntu-01´ and ´contoso-Ubuntu-02´. I agreed.

No errors, also nothing in the ``C:\ArcBox\Logs\ArcServerLogonScript.log``.

I then opened **Windows PowerShell ISE** and executed ``C:\ArcBox\Tests\itpro.tests.m-ps1`` and ``C:\ArcBox\Tests\common.tests.m-ps1``.