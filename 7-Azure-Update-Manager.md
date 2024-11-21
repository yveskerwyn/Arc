# Azure Update Manager

Instructions: [Onboard Azure Arc-enabled servers to Azure Update Manager](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_servers/day2/arc_updateManagementCenter)

## Deployment Open 2: **ARM template with Azure CLI**.

Update the ARM Template parameters file [update-management-center.parameters](C:\Code\Repos\GitHub\azure_arc\azure_arc_servers_jumpstart\updateManagementCenter\update-management-center.parameters.json).

```powershell
cd C:\Code\Repos\GitHub\azure_arc\azure_arc_servers_jumpstart\updateManagementCenter
code update-management-center.parameters.json
```

Deployed the ARM template file [update-management-center-template.json](C:\Code\Repos\GitHub\azure_arc\azure_arc_servers_jumpstart\updateManagementCenter\update-management-center-template.json):

```powershell
az deployment group create --resource-group $Env:resourceGroupName --template-file update-management-center-template.json --parameters update-management-center.parameters.json
```

In the Azure Portal Check the new policy assignment in the resource group: **(jumpstart) Configure periodic checking for missing system updates on azure Arc-enabled servers**. This policy, once it's remediated, enables Periodic Assessment.

Create a remediation task.

On the page of the policy, you can click **View assignment**, where you will see a **Remediation** tab. The **Remediation State** should show to be **Complete** after a while.

Annother 20 minutes later, when clicking **Update** for the Arc-enabled server, **Periodic assessent** was set to **Yes**. Also then the policy was in a compliant state.

Instead of waiting for a firsst automatic update assesment, clcick on **check for updates**, in order to trigger an update assessment manually.

This will add the **WindowsOsUpdateExtnesion**, and show after a while a number of **Rrecommended updates**. Under **History** you can the details related to the updates assessment and operations.

## Update Deployment

As part of the ARM template deployment, a new **Maintenance Configuration** resource is created. It allows you to schedule recurring updates deployments on your Azure Arc-enabled servers.

Review the following Maintenance Configuration **Settings**: 
- **Resource**, which includes the Azure Arc-enabled server
- **Schedule** of the maintenance configuration resource (it will start one day after you deploy this scenario)
- **Updsate**


Let's trigger the updates manually, by clicking **One-time update**. Check **History** for the status.

## Azure Update Manager

In **Azure Update Manager** check **History** under **Manager**.

In the instruction there is mention of a built-in workbook that provides an unified view of you current updates status, but I didn't find it.

## Some research

From conversation with Copilot:
```
It's normal for the "Remediate" option to not appear in the context menu for all policies. The "Remediate" option is typically available for policies with the **deployIfNotExists** or **modify** effects, which require remediation tasks to bring resources into compliance.

If you're not seeing the "Remediate" option, it might be because the policy you're right-clicking on doesn't have these effects or isn't configured for remediation.
```

Checking indeed the **Effect type** of the non-compliant policies I see that it is **AuditNotExists**.

After checking the documentation about using [Remotely and securely configure servers using Run command (Preview) > Azure CLI](https://learn.microsoft.com/en-us/azure/azure-arc/servers/run-command#azure-cli), I used following commands to reboot the machine from the Azure CLI:

```bash
az extension add --name connectedmachine
machineName=WIN-C5F3SBT28PD
resourceGroupName=Arc-Lab-yvesk1
az connectedmachine run-command create --name "myRunCommand" --machine-name $machineName --resource-group $resourceGroupName --script "Restart-Computer -Force"
```

Didn't work, ran into this issue: [Missing az connectedmachine run-command](https://github.com/Azure/azure-cli-extensions/issues/8151)

Tried the workaround:
```bash
az extension remove --name connectedmachine
az extension add --name connectedmachine --version 0.7.0
```


Documentation:
- [az connectedmachine](https://learn.microsoft.com/en-us/cli/azure/connectedmachine?view=azure-cli-latest)

