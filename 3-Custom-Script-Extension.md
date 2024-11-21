# Custom Script Extension

Instructions: [Deploy Custom Script Extension on Azure Arc Linux and Windows servers using Extension Management](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/day2/arc_vm_extension_customscript_arm)

Update [customscript-templatewindows.parameters.json](C:\Code\Repos\GitHub\azure_arc\azure_arc_servers_jumpstart\extensions\arm\customscript-templatewindows.parameters.json).

```powershell
cd C:\
cd Code\Repos\GitHub\azure_arc\azure_arc_servers_jumpstart\extensions\arm
code customscript-templatewindows.parameters.json
```

Deploy the ARM template [customscript-templatewindows.json](C:\Code\Repos\GitHub\azure_arc\azure_arc_servers_jumpstart\extensions\arm\customscript-templatewindows.json):
```powershell
$Env:resourceGroupName='Arc-Test1'
az deployment group create --resource-group $Env:resourceGroupName --template-file customscript-templatewindows.json --parameters customscript-templatewindows.parameters.json
```

The script will install the **Custom Script Extension** and use it to install **Visual Studio Code Chocolatey** packages on the VM, using the [custom_script_windows.ps1](https://raw.githubusercontent.com/microsoft/azure_arc/main/azure_arc_servers_jumpstart/scripts/custom_script_windows.ps1) PowerShell:

```powershell
$chocolateyAppList = "microsoft-windows-terminal,microsoft-edge,7zip,vscode"

if ([string]::IsNullOrWhiteSpace($chocolateyAppList) -eq $false -or [string]::IsNullOrWhiteSpace($dismAppList) -eq $false)
{
    try{
        choco config get cacheLocation
    }catch{
        Write-Output "Chocolatey not detected, trying to install now"
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

if ([string]::IsNullOrWhiteSpace($chocolateyAppList) -eq $false){   
    Write-Host "Chocolatey Apps Specified"  
    
    $appsToInstall = $chocolateyAppList -split "," | foreach { "$($_.Trim())" }

    foreach ($app in $appsToInstall)
    {
        Write-Host "Installing $app"
        & choco install $app /y | Write-Output
    }
}
```

With an earlier try, using un oudated schema for the parameters, I got following error:
```json
{"code": "InvalidTemplate", "message": "Deployment template validation failed: 'The following parameters were supplied, but do not correspond to any parameters defined in the template: 'commandToExecute'. The parameters defined in the template are: 'vmName, location, fileUris'. Please see https://aka.ms/arm-pass-parameter-values for usage details.'.", "additionalInfo": [{"type": "TemplateViolation", "info": {"lineNumber": 0, "linePosition": 0, "path": ""}}]}
```

After checking the ARM template, I removed `commandToExecute`:
```json
"commandToExecute": {
            "value": "powershell -ExecutionPolicy Unrestricted -File custom_script_windows.ps1" //command that will trigger the script
        }
```

Here's the result:
```json
{
  "id": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb/resourceGroups/Arc-Test1/providers/Microsoft.Resources/deployments/customscript-templatewindows",
  "location": null,
  "name": "customscript-templatewindows",
  "properties": {
    "correlationId": "e78d662b-5221-4366-9f63-488a74a9b102",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT22M10.8800384S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb/resourceGroups/Arc-Test1/providers/Microsoft.HybridCompute/machines/ServerVM1/extensions/CustomScriptExtension",
        "resourceGroup": "Arc-Test1"
      }
    ],
    "outputs": null,
    "parameters": {
      "fileUris": {
        "type": "String",
        "value": "https://raw.githubusercontent.com/microsoft/azure_arc/main/azure_arc_servers_jumpstart/scripts/custom_script_windows.ps1"
      },
      "location": {
        "type": "String",
        "value": "westeurope"
      },
      "vmName": {
        "type": "String",
        "value": "ServerVM1"
      }
    },
    "parametersLink": null,
    "providers": [
      {
        "id": null,
        "namespace": "Microsoft.HybridCompute",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "westeurope"
            ],
            "properties": null,
            "resourceType": "machines/extensions",
            "zoneMappings": null
          }
        ]
      }
    ],
    "provisioningState": "Succeeded",
    "templateHash": "17569283563899295988",
    "templateLink": null,
    "timestamp": "2024-11-20T18:29:12.465960+00:00",
    "validatedResources": null
  },
  "resourceGroup": "Arc-Test1",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```