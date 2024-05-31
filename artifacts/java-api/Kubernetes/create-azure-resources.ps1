param([string]$suffix, [string]$resourceGroup, [string]$location)

$acrName = "appacr$suffix"

az acr create `
    --name $acrName `
    --resource-group $resourceGroup `
    --location $location `
    --sku Standard `
    --admin-enabled true

az acr login -n $acrName

# Tag docker images & push to ACR

docker image tag noshnowapi:0.0.1-SNAPSHOT "$acrName.azurecr.io/noshnowapi:0.0.1-SNAPSHOT"
docker image push "$acrName.azurecr.io/noshnowapi:0.0.1-SNAPSHOT"

docker image tag noshnowui:0.0.1 "$acrName.azurecr.io/noshnowui:0.0.1"
docker image push "$acrName.azurecr.io/noshnowui:0.0.1"

# Provision AKS with access to ACR

$aksName = "appaks$suffix"
$flexServerZone = az PostgreSQL flexible-server show --resource-group $resourceGroup --name "PostgreSQLflexapp$suffix" --query availabilityZone -o tsv 

if ($flexServerZone)
{
    az aks create `
    --name $aksName `
    --resource-group $resourceGroup `
    --location $location `
    --node-count 2 `
    --zone $flexServerZone `
    --generate-ssh-keys
}
else 
{
    az aks create `
    --name $aksName `
    --resource-group $resourceGroup `
    --location $location `
    --node-count 2 `
    --generate-ssh-keys
}

az aks update `
    --name $aksName `
    --resource-group $resourceGroup `
    --attach-acr $acrName

# Get AKS credentials

az aks get-credentials --name $aksName --resource-group $resourceGroup

# Create contosonoshnow namespace

kubectl apply -f './contosonoshnow.namespace.yml'
kubectl config set-context --current --namespace=contosonoshnow
