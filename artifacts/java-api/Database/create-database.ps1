param([string]$suffix, [string]$password, [string]$resourceGroup, [string]$location)

$serverName = "postgresqlflexapp$suffix"

az postgresql flexible-server create `
    --admin-user AppAdmin `
    --admin-password $password `
    --database-name app `
    --location $location `
    --resource-group $resourceGroup `
    --name $serverName `
    --public-access all `
    --tier Burstable `
    --sku-name Standard_B1ms `
    --version 16

az postgresql flexible-server execute `
    -n $serverName `
    -u AppAdmin `
    -p $password `
    -d app `
    -f './app-database.sql'
