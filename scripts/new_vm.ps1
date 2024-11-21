$vmName="ServerVM1"

# CREATE RESOURCE GROUP
az group create --name $Env:resourceGroupName --location $Env:azureLocation

# CREATING VM
az vm create --resource-group $Env:resourceGroupName --name $vmName --image Win2019Datacenter --admin-username yves --admin-password Hello@12345#