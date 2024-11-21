# SSH Posture Control

Check **Machine Configuration** for **contoso-Ubuntu-01**, click the **LinuxSshServerSecurityBaseline** configuration. Show **Compliant** as well as **Not compliant** settings.

The compliance information is also available via Azure Resource Graph for reporting at scale across multiple machines. Navigate to **Azure Resource Graph Explorer** in the Azure portal.

Use following query:
```kql
// SSH machine counts by compliance status
guestconfigurationresources
| where name contains "LinuxSshServerSecurityBaseline"
| extend complianceStatus = tostring(properties.complianceStatus)
| summarize machineCount = count() by complianceStatus
```

And then this one:
```kql
// SSH rule level detail
GuestConfigurationResources
| where name contains "LinuxSshServerSecurityBaseline"
| project report = properties.latestAssignmentReport,
 machine = split(properties.targetResourceId,'/')[-1],
 lastComplianceStatusChecked=properties.lastComplianceStatusChecked
| mv-expand report.resources
| project machine,
rule = report_resources.resourceId,
ruleComplianceStatus = report_resources.complianceStatus,
ruleComplianceReason = report_resources.reasons[0].phrase,
lastComplianceStatusChecked
```

The instructions that follow are referring to **Automanage** documentation, not suer whether that is still relevant.