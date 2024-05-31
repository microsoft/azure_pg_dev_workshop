# Hands-on Lab: Azure Batch with PostgreSQL

In this hands-on lab, Azure Batch will be used to connect to an Azure Database for PostgreSQL Flexible Server.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure Batch
- Azure Database for PostgreSQL Flexible Server

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

## Exercise 1: Configure Batch Service

- Browse to the Azure Portal.
- Select the `pgsqldevSUFFIX` batch account.
- Under **Features** select **Pools**.
- Ensure a pool called **main** is displayed, if not create it.
- Select the **main** pool.
- Under **Settings**, select **Scale**.
- Modify the `Target Spot/low-priority nodes` to **1**.
- Select **Save**.
- Navigate back to the Azure Batch instance.
- Under **Settings**, select **Identity**.
- Select **System assigned**.
- Select **Save**, and then from the dialog select **Yes**.

## Exercise 2: Create a Batch Job

- Under **Features**, select **Jobs**.
- Select **+ Add**.
- For the name, type **PostgreSQL_job**.
- For the current pool, select the **main** pool.
- For **ADVANCED SETTINGS**, select **Custom**.
- Select the **Environment Settings** link.
- Add the following environment variables:
  - DB_HOST = pgsqldevSUFFIXflex16.postgres.database.azure.com
  - DB_DATABASE = contosostore
  - DB_PORT = 5432
  - DB_USER = wsuser
  - DB_PASSWORD = Solliance123
- Select **Select**.
- Select **OK**.

## Exercise 3: Create an application

- Zip the `C:\labfiles\microsoft-postgresql-developer-guide\04_EndToEndDev\samples\04-09-AzureBatch\applications` folder, notice the contents.
- Switch to the Azure Portal and the Azure Batch instance.
- Under **Features** select **Applications**.
- Select **+Add**.
- For the Application Id/Name, type **app01_PostgreSQL**.
- For the version, type **1.0.0***.
- For the application package, browse to the newly created zip file.
- Select **Submit**.

## Exercise 4: Create a Batch Task

- Under **General**, select **Jobs**.
- Select the new **PostgreSQL_job**, click **Refresh** if the job is not displayed.
- Under **General**, select **Tasks**.
- Select **+ Add**.
- For the task id, type **main_01**.
- For the display name, type **PostgreSQL_copy_orders**.
- For the command line, type the following:

    ```powershell
    powershell powershell -command ("(Get-ChildItem Env:AZ_BATCH_APP_PACKAGE_app01_PostgreSQL#1.0.0).Value" + '\applications\PostgreSQL_copy_orders.ps1')
    ```

- For the **Elevation level**, select **Pool autouser, Admin**.
- Select the **Application packages** link.
- Select the **app01_PostgreSQL** package and version **1.0.0**.
- Select **Select**.
- Select **Submit**, after a few seconds, the state will show **Running**.

## Exercise 5: Review the job status

- Select the **main_01** task.
- Review the results in the `stdout.txt` file, it should contain data, if no data is present, review the `stderr.txt` and fix any issues.

## Exercise 6: Setup Managed Identity (certificate)

The steps above utilize hardcoded values to gain access to the target database instance. It is possible to set up a managed identity with Azure Batch such that credentials can be retrieved at runtime using a managed identity of the Azure Batch node pool.

- On the **pgsqldevSUFFIX-win11** virtual machine, run the following:

```powershell
choco install openssl -y

cd c:\temp

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";C:\Program Files\OpenSSL-Win64\bin"

openssl genrsa -out server.pem 2048

openssl req -new -key server.pem -out server.csr
```

- When prompted, enter the requested information (press `ENTER` to select all the defaults).

```PowerShell
openssl x509 -req -days 365 -in server.csr -signkey server.pem -out server.crt

openssl pkcs12 -export -out certificate.pfx -inkey server.pem -in server.crt

```

- Enter the certificate password, **Solliance123**.
- Run the following to create a service principal based on the certificate, be sure to replace the `SUFFIX`:

```powershell
Connect-AzAccount

Select-AzSubscription "SUBSCRIPTION_NAME";

$certificateFilePath = "c:\temp\server.crt";
$now = [System.DateTime]::Now;

# Set this to the expiration date of the certificate
$expirationDate = [System.DateTime]::now.Addyears(1);

# Point the script at the cer file created $cerCertificateFilePath = 'c:\temp\batchcertificate.cer'
$cer = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$cer.Import($certificateFilePath)

# Load the certificate into memory
$credValue = [System.Convert]::ToBase64String($cer.GetRawCertData())

#create a new app registration...
$newADApplication = New-AzADApplication -DisplayName "Batch Key Vault Access" -certValue $credValue -StartDate $cer.NotBefore -EndDate $cer.NotAfter

# Create new AAD service principal that uses this application
$newAzureAdPrincipal = New-AzADServicePrincipal -DisplayName $newAdApplication.AppId -CertValue $credValue -StartDate $cer.NotBefore -EndDate $cer.NotAfter;
```

- Run the following to grant permission to the new service principal, be sure to replace the `SUFFIX`:

```PowerShell
Set-AzKeyVaultAccessPolicy -VaultName 'pgsqldevSUFFIX-kv' -ServicePrincipalName $newAzureAdPrincipal.AppId -PermissionsToSecrets 'Get'
```

- Get the needed information for the environment variables:

```PowerShell
$thumbprint = $cer.Thumbprint
$tenantId = $(Get-AzContext).Tenant.Id
$appId = $newAzureAdPrincipal.AppId

write-host "Thumbprint: $thumbprint"
write-host "TenantId: $tenantId"
write-host "AppId: $appId"
```

- Upload the PFX certificate to Azure Batch
  - Browse to the Batch instance
  - Under **Features**, select **Certificates**
  - Select **+Add**
  - Browse to the `c:\temp\certificate.pfx` file
  - Type the password, **Solliance123**
  - Paste the thumbprint into the thumbprint textbox
  - Select **Create**, a dialog showing the certificate as **Active** should be displayed
  - Under **Features**, select **Pools**
  - Select the **main** pool
  - Under **Settings**, select **Certificates**
  - For the thumbprint, select the certificate thumbprint of the newly created certificate
  - For the store location, select **LocalMachine**
  - Select **Save**
  - Under **General**, select **Nodes**
  - Select the ellipses for the single node, select **Reboot**
  - Select **Reboot**, continue with the next few steps

### Create Key Vault values

- Browse to the `pgsqldevSUFFIX` key vault.
- Under **Settings**, select **Access Policies**.
- Select **Add Access Policy**.
- For **Key permissions**, select **Get** and **List**.
- For **Secret permissions**, select **Get**, **List** and **Set**.
- For the **Select principal**, select **None selected**.
- Add the lab username.
- Select **Save**.
- Select **Add**.
- Select **Secrets**.
- Select **Generate/Import**, then create the following secrets:
  - DB-PASSWORD = Solliance123
  - DB-SERVER = localhost
  - DB-USER = wsuser
  - DB-DATABASE = contosostore

### Create a new task with secure settings

- Navigate back to the Azure Batch instance.
- Under **General**, select **Jobs**.
- Select the **PostgreSQL_job**.
- Under **General**, select **Tasks**.
- Select **+ Add**.
- For the task id, type **main_02**.
- For the display name, type **PostgreSQL_copy_orders_secure**.
- For the command line, type the following:

    ```powershell
    powershell powershell -command ("(Get-ChildItem Env:AZ_BATCH_APP_PACKAGE_app01_PostgreSQL#1.0.0).Value" + '\applications\postgresql_copy_orders_secure.ps1')
    ```

- For the **User identity**, select **Pool autouse, Admin**.
- Select **Application packages** link.
- Select the **app01_PostgreSQL** package and version **1.0.0**.
- Select **Select**.
- Select **Environment settings**, create the following replacing the values from the PowerShell window:
  - Batch_Thumbprint = {THUMBPRINT}
  - Batch_TenantId = {TENANT_ID}
  - Batch_AppId = {APP_ID}
  - Batch_VaultName = {pgsqldevSUFFIX-kv}
- Select **Submit**.
- Select the **main_02** task.
- Review the results in the `stdout.txt` file, data should be present, if there is no data, review the `stderr.txt` and fix any issues.
