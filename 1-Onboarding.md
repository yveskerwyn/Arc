# Onboarding

## Preparation

Check and update environment variables:
```powershell
code $PROFILE
```
```powershell
$Env:resourceGroupName = "Arc-Test1"
$Env:azureLocation = "westeurope"
```

Reload the updated environment variables:
```powershell
. $PROFILE
```

Check your current version of the Azure CLI:
```powershell
az --version
```

If not yet installed, download the MSI installer for Windows from the [Azure CLI installation page](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) and run the installer.

Or if needed, update:
```
az upgrade
```

You can also use the Azure CLI directly in the Azure Cloud Shell, which is a browser-based shell that doesn't require installation. Just navigate to https://shell.azure.comand start using the CLI.

```powershell
az login
$subscriptionId=$(az account show --query id --output tsv)
az ad sp create-for-rbac -n "JumpstartArc" --role "Contributor" --scopes "subscriptions/$subscriptionId/resourceGroups/$Env:resourceGroupName"
```

```powershelll
  az provider register --namespace 'Microsoft.HybridCompute'
  az provider register --namespace 'Microsoft.GuestConfiguration'
  az provider register --namespace 'Microsoft.HybridConnectivity'
```

Also recommended:
- [Visual Code](https://code.visualstudio.com/download)
- [Git](https://git-scm.com/downloads)

## Azure hosted Windows VM

First create a virtual machine, using [new_vm.ps1](./scripts/new_vm.ps1):
```powershell
. .\scripts\new_vl.ps1
```

Check the result in the Azure Portal.

It is a good idea to add inbound security rules to allow RDP access only for your IP address: **ServerVM1NSG** > **Settings** > **Inbound security rules** 


Start a RDP session to the server.

As a very first step you might want to disable the **Internet Explorer Enhanced Security Configuration (IE ESC)**: 
- Open **Server Manager**
- Select **Local Server**
- Find the **IE Enhanced Security Configuration** parameter and click **On** next to it. 
- A window will appear1. Select **Off** for both Administrators and Users, then click **OK**.

Reload the updated environment variables:
```powershell
. $PROFILE
```

As documented in [Evaluate Azure Arc-enabled servers on an Azure virtual machine > Reconfigure Azure VM](https://learn.microsoft.com/en-us/azure/azure-arc/servers/plan-evaluate-on-azure-virtual-machine#reconfigure-azure-vm) execute:

```powershell
## Configure the OS to allow Azure Arc Agent to be deploy on an Azure VM
Set-Service WindowsAzureGuestAgent -StartupType Disabled -Verbose
Stop-Service WindowsAzureGuestAgent -Force -Verbose
New-NetFirewallRule -Name BlockAzureIMDS -DisplayName "Block access to Azure IMDS" -Enabled True -Profile Any -Direction Outbound -Action Block -RemoteAddress 169.254.169.254 

# Download the package AzureConnectedMachineAgent.msi package
function download() {$ProgressPreference="SilentlyContinue"; Invoke-WebRequest -Uri https://aka.ms/AzureConnectedMachineAgent -OutFile AzureConnectedMachineAgent.msi}
download

# Install the package
msiexec /i AzureConnectedMachineAgent.msi /l*v installationlog.txt /qn | Out-String
```

```powershell
code $PROFILE
```

Change the following environment variables according to your Azure service principal name
```powershell
$env:subscriptionId='<Your Azure subscription ID>'
$env:appId='<Your Azure service principal name>'
$env:password='<Your Azure service principal password>'
$env:tenantId='<Your Azure tenant ID>'
$env:resourceGroupName='<Azure resource group name>'
$env:azureLocation='<Azure Region>'
```

Run the connect command:
```powershell
cd 'C:\Program Files'
cd AzureConnectedMachineAgent

& "$env:ProgramFiles\AzureConnectedMachineAgent\azcmagent.exe" connect --service-principal-id $env:appId --service-principal-secret $env:password --resource-group $env:resourceGroupName --tenant-id $env:tenantId --location $env:azureLocation --subscription-id $env:subscriptionId
```
 As a result you should see the server in Arzure Arc.

 ## Onboarding Windows (on-premises)

Instructions: [Connect an existing Windows server to Azure Arc](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/general/onboard_server_win)

Download [az_connect_win.ps1](https://github.com/microsoft/azure_arc/blob/main/azure_arc_servers_jumpstart/scripts/az_connect_win.ps1)

Change the environment variables according to your environment and copy the script to the designated machine.

Run the script, optionally with the editor of PowerShell ISE:
```powershell
powershell_ise
```

In order to run it you might first need to change the **Execution Policy**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Deploy a Windows Azure Virtual Machine and connect it to Azure Arc using an ARM Template

Instructions: [Deploy a Windows Azure Virtual Machine and connect it to Azure Arc using an ARM Template](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/azure/azure_arm_template_win)