# Microsoft Defender for Cloud - SQL server on machines

In **Microsoft Defendere for Cloud**, navigate to **Management** > **Environment settings** and click the **Microsoft Parter Network** subscription.

Checking **Email notifications**, I specified that I want to be notified about **Medium** severity alerts.

Going back to the **contoso-SQL** SQL Server (not the machine), and navigate to **Security** > **Microsoft Defender for Cloud**. I clicked **Enable**. (30-day trial), and waited until it is finished.

From the **contoso-Client** machine logon to the **contoso-SAL** guest VM. In **Windows PowerShell ISE** open and run the``C:\ArcBox\testDefenderForSQL.ps1`` script.

As a result I received an e-mail: **Microsoft Defender for Cloud has detected suspicious activity in your resource**, for which you could find details in the Azure Portal.