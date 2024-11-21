# Defender for Cloud

Instructions: [Connect Azure Arc-enabled servers to Microsoft Defender for Cloud](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/day2/arc_defender)

## Deployment Option 2: ARM template with Azure CLI

As documented in [az security workspace-setting](https://learn.microsoft.com/en-us/cli/azure/security/workspace-setting?view=azure-cli-latest#az_security_workspace_setting_show) I used following command to list all workspace settings in my subscription - these settings let me control which workspace will hold my security data:
```powershell
az security workspace-setting list
```

## Misc

Since I already had Defender for Cloud configured, I first tried this:

```powershell
az security pricing show -n VirtualMachines

{
  "deprecated": null,
  "enablementTime": "2024-11-06T17:24:45.715220+00:00",
  "extensions": [
    {
      "additionalExtensionProperties": null,
      "isEnabled": "False",
      "name": "MdeDesignatedSubscription",
      "operationStatus": null
    },
    {
      "additionalExtensionProperties": {"ExclusionTags": "[]"},
      "isEnabled": "True",
      "name": "AgentlessVmScanning",
      "operationStatus": null
    },
    {
      "additionalExtensionProperties": null,
      "isEnabled": "False",
      "name": "FileIntegrityMonitoring",
      "operationStatus": null
    }
  ],
  "freeTrialRemainingTime": "24 days, 6:52:00",
  "id": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb/providers/Microsoft.Security/pricings/VirtualMachines",
  "name": "VirtualMachines",
  "pricingTier": "Standard",
  "replacedBy": null,
  "subPlan": "P2",
  "type": "Microsoft.Security/pricings"
}
```

So, since only the **AgentlessVmScanning** extension was already enabled, with none of the VMs excluded: [Agentless scanning for VMs](https://learn.microsoft.com/en-us/azure/defender-for-cloud/enable-agentless-scanning-vms)

And follow extension were disabled:
- MdeDesignatedSubscription
- FileIntegrityMonitoring


As documented in [az security workspace-setting](https://learn.microsoft.com/en-us/cli/azure/security/workspace-setting?view=azure-cli-latest#az_security_workspace_setting_show) I used following command to list all workspace settings in my subscription - these settings let me control which workspace will hold my security data:
```powershell
az security workspace-setting list
```

So, I already had the Log Analytics workspace **Arc-LogAnalyticsWS** connected to Defender for Cloud:
```json
[
  {
    "id": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb/providers/Microsoft.Security/workspaceSettings/default",
    "name": "default",
    "scope": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb",
    "type": "Microsoft.Security/workspaceSettings",
    "workspaceId": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb/resourceGroups/arc-challenge-infra/providers/Microsoft.OperationalInsights/workspaces/Arc-LogAnalyticsWS"
  }
]
```

Previously, I didn't have any workspace settings yet, and created a default one, actualy the above one:
```powershell
$subscriptionID=23724162-64fb-4c6e-a74b-f3e3ec82bcdb
$resourceGroupName=arc-challenge-infra
$workspaceName=Arc-LogAnalyticsWS
az security workspace-setting create --name default --target-workspace 'subscriptions/$subscriptionID=/resourceGroups/$resourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$workspaceName'
```

```powershell
# Verify Workspace Existence
az monitor log-analytics workspace list --resource-group "arc-challenge-infra" --output table

# Set Variables
$subscriptionID="23724162-64fb-4c6e-a74b-f3e3ec82bcdb"
$resourceGroupName="arc-challenge-infra"
$workspaceName="Arc-LogAnalyticsWS"

# Create Workspace Setting
az security workspace-setting create --name default --target-workspace "/subscriptions/$subscriptionID/resourceGroups/$resourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$workspaceName"
```

In case you use a **Git Bash** session, following information of Copilot might be interesting:
```
Prompt: It worked in PowerShell, can you find out why this will not work in Git Bash?

Answer: The issue you're encountering is due to Git Bash interpreting the leading slash (/) as a path on your filesystem. This behavior is different from PowerShell, which treats the slash as part of the command syntax

To prevent Git Bash from interpreting the leading slash, you can set an environment variable to disable path conversion. Here’s how:

export MSYS_NO_PATHCONV=1
```

By setting the `MSYS_NO_PATHCONV` environment variable, Git Bash should correctly interpret the leading slash as part of the command syntax, just like PowerShell does.

```bash
az security workspace-setting list
[
  {
    "id": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb/providers/Microsoft.Security/workspaceSettings/default",
    "name": "default",
    "scope": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb",
    "type": "Microsoft.Security/workspaceSettings",
    "workspaceId": "/subscriptions/23724162-64fb-4c6e-a74b-f3e3ec82bcdb/resourceGroups/arc-challenge-infra/providers/Microsoft.OperationalInsights/workspaces/Arc-LogAnalyticsWS"
  }
]
```

As per instructions I executed following command in order to assign the default Microsoft Defender for Cloud policy initiative. Defender makes its security recommendations based on policies. There is an specific initiative that groups Microsoft Defender for Cloud policies with the definition ID '1f3afdf9-d0c9-4c3d-847f-89da613e70a8'. The command below will assign the Defender initiative to your subscription:

```bash
az policy assignment create --name 'ASC Default $subscriptionID' \
--scope '/subscriptions/$subscriptionID' \
--policy-set-definition '1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
```

When checking the resource group **Arc-lab-yvesk1**, select **Settings** > **Policies** you will see the new initiative added: **ASC Default (subscription: 23724162-64fb-4c6e-a74b-f3e3ec82bcdb)**.

You click-through here to **Non-compliant resources**.

Or via **Defender for Cloud** > **Inventory** and optionally filter on **Resource type** **Machine - Azure Arc** you can also click-through.


Documentation:
- [Cloud security posture management (CSPM)](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management)
- [Enable agentless scanning for VMs](https://learn.microsoft.com/en-us/azure/defender-for-cloud/enable-agentless-scanning-vms?WT.mc_id=Portal-Microsoft_Azure_Security)
- [Microsoft Defender for Cloud pricing](https://azure.microsoft.com/en-us/pricing/details/defender-for-cloud/)
- [Remediate recommendations](https://learn.microsoft.com/en-us/azure/defender-for-cloud/implement-security-recommendations?WT.mc_id=Portal-Microsoft_Azure_Security_R3#quick-fix-remediation)