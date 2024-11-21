# Arc-enabled SQL Server - least privilege access

Documentation: [Arc-enabled SQL server supports running agent extension under least privilege access](https://learn.microsoft.com/sql/sql-server/azure-arc/configure-least-privilege?view=sql-server-ver16)

On the **contoso-SQL** guest VM, in the **Control Panel**, click **System and Security**, then click **Adminisrative Tools** and then double-click **Services**. Here I was able to check that the service **Microsoft Sql Server Exentension Service** was running as *NT Service\SQLServerExtension**. By default SQL server agent extension runs under Local System account.