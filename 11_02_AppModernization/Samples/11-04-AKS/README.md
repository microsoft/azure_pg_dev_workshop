# AppMod 08 : Migrate to Azure Kubernetes Services (AKS)

Now that a containerized version of the applications exists, it can now be hosted in several places in Azure. Here we explore Azure App Service Containers.

## Push images to Azure Container Registry

1. If they haven't already, push the images to the Azure Container Registry using the [Push Images to Acr](./../Misc/01_PushImagesToAcr.md) article.

## Run images in Azure Kubernetes Service (AKS)

1. Open the `C:\labfiles\microsoft-postgresql-developer-guide\Artifacts\11-04-AKS` directory with Visual Studio Code
2. Open a new terminal window, ensure kubectl is installed:

    ```powershell
    Connect-AzAccount -identity

    $resourceGroups = Get-AzResourceGroup

    $rg = $resourceGroups[0]
    $resourceGroupName = $rg.ResourceGroupName

    $suffix = $rg.tags['Suffix']
    $resourceName = "pgsqldev$suffix"
    
    az aks install-cli

    az aks get-credentials --name "pgsqldev$suffix" --resource-group $resourceGroupName
    ```

3. Run the following commands to deploy the containers (be sure to update the variable values). The lab account must be able to create RBAC in the Microsoft Entra tenant to run these commands. If it does not have this access, enable the anonymous access to the container registry using (`az acr update --name myregistry --anonymous-pull-enabled false`):

    ```powershell
    $acr = Get-AzContainerRegistry -Name $acrName -ResourceGroupName $resourceGroupName;
    $creds = $acr | Get-AzContainerRegistryCredential;
    
    kubectl create namespace postgresqldev

    $ACR_REGISTRY_ID=$(az acr show --name $ACRNAME --query "id" --output tsv);
    $SERVICE_PRINCIPAL_NAME = "acr-service-principal";
    $PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query "password" --output tsv)
    $USERNAME=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query "[].appId" --output tsv)

    kubectl create secret docker-registry acr-secret `
    --namespace postgresqldev `
    --docker-server="https://$($acr.loginserver)" `
    --docker-username=$username `
    --docker-password=$password

    #ensure that MSI is enabled
    az aks update -g $resourceGroupName -n $resourceName --enable-managed-identity

    #get the principal id
    az aks show -g $resourceGroupName -n $resourceName --query "identity"

    az aks update -n $resourceName -g $resourceGroupName --attach-acr $acrName
    az aks check-acr --resource-group $resourceGroupName --name $resourceName --acr $acrName
    
    ```

> NOTE: It is possible to use the Azure Key Vault provider for AKS to utilize secrets. Reference [Azure Key Vault Provider for Secrets Store CSI Driver](https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/). Additionally, consider using [Managed Identities](https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/configurations/identity-access-modes/) for the pods.

4. Create a managed disk:

  ```powershell
  az disk create --resource-group $resourceGroupName --name "disk-store-db" --size-gb 200 --query id --output tsv
  ```

5. Copy its `id` (ex : `/subscriptions/SUBSCRIPTON_ID/resourceGroups/RESOURCE_GROUP/providers/Microsoft.Compute/disks/disk-store-db` for later use:
6. Open and review the following `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\storage-db.yaml` deployment file:

  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: postgresql-data
    namespace: postgresqldev
  spec:
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 200Gi
  ```

6. Open and review the `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\store-db.yaml` deployment file, be sure to replace the `<REGISTRY_NAME>` and `ID` tokens:

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: store-db
    namespace: postgresqldev
    labels:
        app: store-db
  spec:
    volumes:
    - name: postgresql-data
      persistentVolumeClaim:
        claimName: postgresql-data
    containers:
      - name: store-db
        image: <REGISTRY_NAME>.azurecr.io/store-db:latest
        volumeMounts:
        - mountPath: "/var/lib/postgresql/"
          name: postgresql-data
        imagePullPolicy: IfNotPresent
        env:
        - name: POSTGRES_DB
          value: "contosostore"
        - name: POSTGRES_PASSWORD
          value: "root"
    imagePullSecrets:
      - name: acr-secret
    volumes:
    - name: postgresql-data
      persistentVolumeClaim:
        claimName: postgresql-data
  ```

7. Run the deployment:

    ```powershell
    cd "C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS"

    kubectl create -f storage-db.yaml

    kubectl create -f store-db.yaml
    ```

8. Create the following `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\store-web.yaml` deployment file, be sure to replace the `<REGISTRY_NAME>` token:

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: store-web
    namespace: postgresqldev
  spec:
    containers:
      - name: store-web
        image: <REGISTRY_NAME>.azurecr.io/store-web:latest
        imagePullPolicy: IfNotPresent
        env:
        - name: DB_DATABASE
          value: "contosostore"
        - name: DB_USERNAME
          value: "postgres"
        - name: DB_PASSWORD
          value: "Solliance123"
        - name: DB_HOST
          value: "store-db"
    imagePullSecrets:
      - name: acr-secret
  ```

6. Run the deployment:

    ```powershell
    cd "C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS"

    kubectl create -f store-web.yaml
    ```

## Add services

1. Open and review the  `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\store-db-service.yaml` yaml file:

  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: store-db
  spec:
    ports:
    - port: 5432
    selector:
      app: store-db
  ```

2. Open and review the `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\store-web-service.yaml` yaml file:

  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: store-web
  spec:
    ports:
    - port: 80
    selector:
      app: store-web
  ```

3. Run the deployment:

    ```powershell
    cd "C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS"

    kubectl create -f store-web-service.yaml

    kubectl create -f store-db-service.yaml
    ```

## Create a Loadbalancer

1. Review the `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\store-web-lb.yaml` file:
2. Execute the deployment:

  ```powershell
  kubectl create -f store-web-lb.yaml
  ```

3. Review the `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\store-db-lb.yaml` file:
4. Execute the deployment:

  ```powershell
  kubectl create -f store-db-lb.yaml
  ```

## Test the images

1. Browse to the Azure Portal
2. Navigate to the AKS cluster and select it
3. Under **Kubernetes resources**, select **Service and ingresses**
4. For the **store-web-lb** service, select the external IP link. A new web browser tab should open to the web front end. Ensure that an order can be created without a database error.
5. Fix any issues and then restart the node pool:

```powershell
az aks nodepool stop --resource-group $resourceGroupName --cluster-name $resourceName --nodepool-name agentpool
az aks nodepool start --resource-group $resourceGroupName --cluster-name $resourceName --nodepool-name agentpool
```

## Create a deployment

Kubernetes deployments allow for the creation of multiple instances of pods and containers in case nodes or pods crash unexpectiantly. 

1. Review the `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\store-web-deployment.yaml` file be sure to replace the Azure Container Registry link:

  ```powershell
  kubectl create -f store-web-deployment.yaml
  ```

2. Review the `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\11-04-AKS\store-db-deployment.yaml` file be sure to replace the Azure Container Registry link:
3. Execute the deployment:

  ```powershell
  kubectl create -f store-db-deployment.yaml
  ```

4. This deployment is now very robust and will survive multiple node failures.

## Extra Resources

For an example of deploying a Django app that uses Azure Database for PostgreSQL Flexible Server on AKS, reference [Tutorial: Deploy Django app on AKS with Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/tutorial-django-aks-database).