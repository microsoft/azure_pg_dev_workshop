# Hands-on Lab: Deploy Azure Function App to Azure Kubernetes Service (AKS)

Function apps can be containerized and deployed to AKS. These steps will walk through this process so it can be applied later if this is something the architecture demands.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure App Service Plan (Linux)
- Azure App Service (Linux)
- Azure Database for PostgreSQL Flexible Server
- Azure Kubernetes Service (AKS)
- Azure Container Registry

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

### Software pre-requisites

All this is done already in the lab setup scripts for the Lab virtual machine but is provided here for reference.

- Install [Visual Studio Code](https://code.visualstudio.com/download)
- Install the [`Azure Functions`](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) extension
- Install the [`Python`](https://marketplace.visualstudio.com/items?itemName=ms-python.python) extension
- Install [Python 3.11.x](https://www.python.org/downloads/)
- Install the [Azure Functions core tools MSI](https://go.microsoft.com/fwlink/?linkid=2174087)
- Install the latest [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli-windows?tabs=powershell)
- Install [Docker Desktop (Windows)](https://www.docker.com/products/docker-desktop/#)

## Exercise 1: Ensure Docker is started

- Open Docker Desktop, and ensure that it is running.

## Exercise 2: Setup AKS (KEDA)

- Open a new Visual Studio Code window to the `C:\labfiles\microsoft-postgresql-developer-guide\04_EndToEndDev\samples\04-04-FunctionApp-AKS` folder
- Open a new terminal window, and ensure that an AKS connection is present, be sure to replace the `SUFFIX`:

```Powershell
$resourceGroupName = "YOUR_RESOURCEGROUP_NAME";

az login

az aks install-cli

az account set --subscription "SUBSCRIPTION_NAME"

az aks get-credentials --name "pgsqldevSUFFIX" --resource-group $resourceGroupName
```

- Run the following command to install KEDA on the AKS cluster:

```PowerShell
kubectl create namespace keda

func kubernetes install
```

## Exercise 3: Ensure Docker Connection

1. Open the Azure Portal
2. Browse to the **pgsqldevSUFFIX** Azure Container Registry
3. Under **Settings**, select **Access keys**
4. Copy the username and password
5. In the terminal windows, run the following, be sure to replace the `acrName`, `username` and `password`:

    ```powershell
    docker login {acrName}.azurecr.io -u {username} -p {password}
    ```

## Exercise 4: Configure Function App as Container

- Run the following command to set up the docker file

```PowerShell
func init --docker-only --python
```

- Deploy the function app using the following, be sure to replace the function name and `SUFFIX` value:

```PowerShell
func kubernetes deploy --name "showdatabasesfunction" --registry "pgsqldevSUFFIX.azurecr.io"
```

- After following the above steps, the function app has been turned into a container and pushed to the target registry. It should also now be deployed to the AKS cluster in the `keda` namespace.
