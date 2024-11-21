# Onboarding Linux

After having dowloaded the instalation script from Azure Arc on my local machine, which is in the same network as the Linux machine, I copied the script as follows from the command prompt or PowerShell:

```bash
scp OnboardingScript.sh yves@192.168.0.233:~
``` 

Run the script:
```bash
bash ~/OnboardingScript.sh
```

You might get following lessage: Another apt/dpkg process is updating the system. In that case check:
```bash
ps aux | grep -i apt
```

If you see any processes, you may need to wait for them to complete or terminate them if they are stuck.

In Arc, go to the Linux machine and under **Settings** | **Seciurity**


[Microsoft Defender for Cloud pricing](https://azure.microsoft.com/en-us/pricing/details/defender-for-cloud/)
[Cloud security posture management (CSPM) | Plan availability](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management)
[Azure Automanage for Machines Best Practices - Azure Arc-enabled servers](https://learn.microsoft.com/en-us/azure/automanage/automanage-arc)
[Retirement: Azure Automange Best Practices Migrating to Azure Policy](https://azure.microsoft.com/en-us/updates/v2/Azure-Automanage-Best-Practices-Retirement-Migrate-to-Azure-Policy)