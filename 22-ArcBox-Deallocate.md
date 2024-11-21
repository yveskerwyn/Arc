# Deallocate

After shutting down **contoso-Client**:
```powershell
az vm deallocate --resource-group $Env:resourceGroupName --name "contoso-Client"
```

In oder tot start again later:
```powershell
az vm start --resource-group $Env:resourceGroupName --name "contoso-Client"
```