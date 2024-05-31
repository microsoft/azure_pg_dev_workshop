# AppMod 02 : Migrate to Azure Container Instances (ACI)

Now that containerized versions of the application exist, they can now be hosted in several resource types in Azure. Here, we explore Azure Container Instances (ACI).

## Required Resources

Several resources are required to perform this lab. These include:

- Development Server with web server and PHP
- Composer
- Azure App Service (Linux)
- Azure Container Registry

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation. **Note the last section that requires you to run the provided setup PowerShell script**:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

## Push images to Azure Container Registry

1. If they haven't been already, push the images to the Azure Container Registry using the [Push Images to Acr](./../Misc/01_PushImagesToAcr.md) article.

## Run images in ACI

1. Run the following commands to create two new container instances:

    ```PowerShell
    Connect-AzAccount -identity

    $resourceGroups = Get-AzResourceGroup

    $rg = $resourceGroups[0]
    $resourceGroupName = $rg.ResourceGroupName

    $suffix = $rg.tags['Suffix']
    $resourceName = "pgsqldev$suffix"
    $acrName = $resourceName
    
    $acr = Get-AzContainerRegistry -Name $acrName -ResourceGroupName $resourceGroupName;
    $creds = $acr | Get-AzContainerRegistryCredential

    $imageRegistryCredential = New-AzContainerGroupImageRegistryCredentialObject -Server "$acrName.azurecr.io" -Username $creds.username -Password (ConvertTo-SecureString $creds.password -AsPlainText -Force)

    $storageKey = $(Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $resourceName).Value[0];
    $context = $(New-AzStorageContext -StorageAccountName $resourceName -StorageAccountKey $storageKey);

    #create a new azure file share
    New-AzStorageShare -Name "db-volume" -Context $context
    
    $containerName = "store-db";
    $env1 = New-AzContainerInstanceEnvironmentVariableObject -Name "POSTGRES_DB" -Value "contosostore";
    $env2 = New-AzContainerInstanceEnvironmentVariableObject -Name "POSTGRES_PASSWORD" -Value "Solliance123";
    $env3 = New-AzContainerInstanceEnvironmentVariableObject -Name "POSTGRES_USER" -Value "Solliance123";
    $port1 = New-AzContainerInstancePortObject -Port 5432 -Protocol TCP;
    $volume = New-AzContainerGroupVolumeObject -Name "db-volume" -AzureFileShareName "db-volume" -AzureFileStorageAccountName $resourceName -AzureFileStorageAccountKey (ConvertTo-SecureString $storageKey -AsPlainText -Force);
    $vMount = @{};
    $vMount.MountPath = "/var/lib/postgresql";
    $vMount.Name = "db-volume";
    $container = New-AzContainerInstanceObject -Name $containerName -Image "$acrName.azurecr.io/store-db" -Port @($port1) -EnvironmentVariable @($env1, $env2, $env3) -VolumeMount @($vMount);
    New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerName -Container $container -OsType Linux -Location $rg.location -ImageRegistryCredential $imageRegistryCredential -IpAddressType Public -Volume $volume;
    ```

2. Browse to the Azure Portal
3. Search for the **store-db** `Container instance` and select it
4. Copy the public IP address
5. Setup the web container, replace the `IP_ADDRESS` with the one copied above:

    ```Powershell
    $ipAddress = "IP_ADDRESS";
    $containerName = "store-web";
    $env1 = New-AzContainerInstanceEnvironmentVariableObject -Name "DB_DATABASE" -Value "contosostore";
    $env2 = New-AzContainerInstanceEnvironmentVariableObject -Name "DB_USERNAME" -Value "postgres";
    $env3 = New-AzContainerInstanceEnvironmentVariableObject -Name "DB_PASSWORD" -Value "Solliance123";
    $env4 = New-AzContainerInstanceEnvironmentVariableObject -Name "DB_HOST" -Value $ipAddress;
    $env5 = New-AzContainerInstanceEnvironmentVariableObject -Name "APP_URL" -Value "";
    $port1 = New-AzContainerInstancePortObject -Port 80 -Protocol TCP;
    $port2 = New-AzContainerInstancePortObject -Port 8080 -Protocol TCP;
    $container = New-AzContainerInstanceObject -Name postgresql-dev-web -Image "$acrName.azurecr.io/store-web" -EnvironmentVariable @($env1, $env2, $env3, $env4, $env5) -Port @($port1, $port2);
    New-AzContainerGroup -ResourceGroupName $resourceGroupName -Name $containerName -Container $container -OsType Linux -Location $rg.location -ImageRegistryCredential $imageRegistryCredential -IpAddressType Public;
    ```

## Test the images

1. Browse to the Azure Portal
2. Search for the **store-web** Container instance and select it
3. Copy the public IP address and then open a browser window to `http://IP_ADDRESS/default.php`

## Multi-container single app service deployment

In the previous steps, each container received a container instance, however, it is possible to create a multi-container instance where all services are encapsulated into one container instance using Azure CLI.

1. Create the following `C:\labfiles\microsoft-postgresql-developer-guide\artifacts\docker-compose-contoso.yml` file, be sure to replace the `SUFFIX`:

    ```yaml
    version: '3.8'
    services:
      web:
        image: pgsqldevSUFFIX.azurecr.io/store-web:latest
        environment:
          - DB_DATABASE=contosostore
          - DB_USERNAME=postgres
          - DB_PASSWORD=Solliance123
          - DB_HOST=db
          - DB_PORT=5432
        ports:
          - "8080:80" 
        depends_on:
          - db 
      db:
        image: pgsqldevSUFFIX.azurecr.io/store-db:latest
        volumes:
          - ${WEBAPP_STORAGE_HOME}/site/database:/var/lib/postgresql
        restart: always
        environment:
          - POSTGRES_PASSWORD=Solliance123
          - POSTGRES_USER=postgres
          - POSTGRES_DB=contosostore
        ports:
          - "5432:5432"
      pgadmin:
        image: pgsqldevSUFFIX.azurecr.io/dpage/pgadmin4
        ports:
          - '8081:80'
        restart: always
        environment:
          - PGADMIN_DEFAULT_PASSWORD=Solliance123
          - PGADMIN_DEFAULT_EMAIL=postgres@contoso.com
        depends_on:
          - db
    ```

2. In a PowerShell window, run the following command, be sure to replace the `SUFFIX` and other variable values:

    ```powershell
    cd "C:\labfiles\microsoft-postgresql-developer-guide\artifacts"

    Connect-AzAccount -identity

    $resourceGroups = Get-AzResourceGroup

    $rg = $resourceGroups[0]
    $resourceGroupName = $rg.ResourceGroupName

    $suffix = $rg.tags['Suffix']
    $resourceName = "pgsqldev$suffix-linux"
    $acrName = $resourceName

    $acr = Get-AzContainerRegistry -Name $acrName -ResourceGroupName $resourceGroupName;
    $creds = $acr | Get-AzContainerRegistryCredential;

    az login -identity;

    az webapp create --resource-group $resourceGroupName --plan $resourceName --name $resourceName --multicontainer-config-type compose --multicontainer-config-file docker-compose-contoso.yml;

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings DOCKER_REGISTRY_SERVER_USERNAME=$($creds.Username)

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings DOCKER_REGISTRY_SERVER_URL="$resourceName.azurecr.io"

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings DOCKER_REGISTRY_SERVER_PASSWORD=$($creds.Password)

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings DB_HOST="DB"

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings DB_USERNAME="postgres"

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings DB_PASSWORD="Solliance123"

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings DB_DATABASE="contosostore"

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings DB_PORT="5432"

    az webapp config appsettings set --resource-group $resourceGroupName --name $resourceName --settings WEBSITES_ENABLE_APP_SERVICE_STORAGE=TRUE

    az webapp config container set --resource-group $resourceGroupName --name $resourceName --multicontainer-config-type compose --multicontainer-config-file docker-compose-contoso.yml --debug
    ```

3. Switch back to the Azure Portal, browse to the Azure App Service.
4. If troubleshooting is needed, view the container logs by browsing to `https://pgsqldevSUFFIX-linux.scm.azurewebsites.net/api/logs/docker`.
5. Copy the path to the docker file and paste it into a new browser window, review the logs and fix any errors.
