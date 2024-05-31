# Hands-on Lab: Securing Azure Function Apps With Managed Identity

In the previous Function App samples, the connection information is embedded into the function app code. As covered in the application modernization traditional deployment models, it is a best practice to remove this information and place it into Azure Key Vault. Here we will utilize the features of Azure to use Managed Identities to connect to the database.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure App Service Plan (Linux)
- Azure App Service (Linux)
- Azure Database for PostgreSQL Flexible Server

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

### Software pre-requisites

All this is done already in the lab setup scripts for the Lab virtual machine but is provided here for reference.

- Install [Visual Studio Code](https://code.visualstudio.com/download)
- Install the [`Azure Functions`](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) extension
- Install the [`Python`](https://marketplace.visualstudio.com/items?itemName=ms-python.python) extension
- Install [Python 3.11.x](https://www.python.org/downloads/)
- Install the [Azure Functions core tools MSI](https://go.microsoft.com/fwlink/?linkid=2174087)
- Install [pgAdmin](https://www.pgadmin.org/download/)

## Exercise 1: Enable PostgreSQL Microsoft Entra Authentication

- Switch to the Azure Portal
- Browse to the **pgsqldevSUFFIXflex16** Azure Database for PostgreSQL Flexible Server instance
- Under **Security**, select **Authentication**
- Ensure **Assign access to** is set to `PostgreSQL and Microsoft Entra authentication`
- Select **Add Microsoft Entra Admins**
- Select the lab credentials
- Select **Select**
- Select **Save**

## Exercise 2: Create Managed Identity

- Browse to the **pgsqldevSUFFIX-ShowDatabasesFunction** Function App
- Under **Settings**, select **Identity**
- For the **System assigned** identity, toggle to **On**
- Select **Save**, then select **Yes**
- Run the following to get the application id, be sure to replace the `SUFFIX`:

```powershell
az ad sp list --display-name pgsqldevSUFFIX-ShowDatabasesFunction --query [*].appId --out tsv
```

- Copy the value for later use

## Exercise 3: Log in to the Azure Database with Microsoft Entra credentials

- Switch to the **pgsqldevSUFFIX-win11** virtual machine
- Create a file called `c:\temp\GetAzADToken.ps1` and paste the following into it:

```PowerShell
If ($null -eq (Get-AzContext)) {
    # User Account
    Connect-AzAccount -WarningAction SilentlyContinue | Out-Null
}
 
$AzAccessTokenSplat = $null
$AzAccessTokenSplat = @{
    ResourceUrl = "https://ossrdbms-aad.database.windows.net"
}
  
$AzAccessToken = $null
$AzAccessToken = Get-AzAccessToken @AzAccessTokenSplat
  
$AzAccessToken.Token
```

- Open the pgAdmin
- Create a new server connection, right-click **Servers**, select **Register**
- For the name, type **AzureADPostgreSQL**
- For the hostname, type the DNS of the Azure Database for PostgreSQL Flexible Server (ex `pgsqldevSUFFIXflex16.postgres.database.azure.com`)
- For the username, type the lab user UPN (aka the email address for the lab account)
- Select the **Advanced** tab, for the password exec command, type the following:

```cmd
powershell -file "C:\temp\GetAzADToken.ps1"
```

- For the password exec expiration, type `3480`
- Select **Save**
- Right-click the new server, select **Connect**

> NOTE: `pgadmin` does have a password limit and the access token will exceed this limit. If for some reason pgadmin will not connect, fall back to using `psql`

- In a PowerShell windows, run the following to get an access token (be sure to log in using a PostgreSQL admin with the proper Tenant ID when generating the access token), be sure to replace `SUFFIX`:

```powershell
az login

$env:PGPASSWORD=$(az account get-access-token --resource https://ossrdbms-aad.database.windows.net --query accessToken --output tsv)

psql -h pgsqldevSUFFIXflex16.postgres.database.azure.com -U user@contoso.com -d postgres
```

## Exercise 4: Add MSI to the Database

- Switch to the Azure Portal
- Browse to the `` Azure Database for PostgreSQL Flexible Server
- Under **Security**, select **Authentication**
- Select **Add Microsoft Entra Admin**
- Search for the `APP_ID` from above. Select it and then select **Select**
- Select **Save**
- The same could be performed using psql. From a psql connection, run the following, then replace the `APP_ID` with the one copied from above:

    ```sql
    select * from pgaadauth_create_principal('APP_ID', false, false);
    ```

## Exercise 5: Entra Users and Groups (Optional)

Microsoft Entra Groups can be used to assign permissions in Azure Database for PostgreSQL Flexible Server. If the lab account has access to create Microsoft Entra groups, it is possible to attempt the next set of steps:

- Switch to the Azure Portal
- Open the **Microsoft Entra ID** app
- Under **Manage**, select **Groups**
- Select **New Group**
- For the group type, select **Security**
- Enter a group name (ex. **Test_PG_Admins**)
- Select the **No members selected** link
- Search for the `APP_ID` and select it, then select **Select**
- Select **Create**
- Switch back to the **pgsqldevSUFFIX-win11** virtual machine
- Switch to Windows PowerShell with psql as the Microsoft Entra user from above

> NOTE: It is only possible to assign roles using an authenticated Microsoft Entra User (not a PostgreSQL user)

- Attempt to assign the group access to the database with the following script (it should fail):
  - First parameter `true` = isAdmin
  - Second paremeter `false` = isMfa

```psql
select * from pgaadauth_create_principal('Test_PG_Admins', true, false);
```

> NOTE: This is equilvalent to executing `CREATE ROLE "Test_PG_Admins" LOGIN CREATEROLE CREATEDB in role azure_pg_admin;`.  An Azure database user is not a super user, therefore the Azure Portal must be used to assign this level of permissions. It is possible to add non-admin users by changing the first parameters to `false`.

- Find the current Microsoft Entra users by running the following:

```psql
select * from pgaadauth_list_principals(false);
```

- It is possible to add Microsoft Entra users to the database (be sure to use their primary UPN/Email address):

```psql
select * from pgaadauth_create_principal('chris@contoso.com', false, false);
```

- Switch to Windows PowerShell, then connect to the database using the following command:

```powershell

```

> NOTE: If the Azure Database for PostgreSQL Flexible Server instance that is on a private network, be sure to create an outbound path (also a route if using route tables) to the **AzureActiveDirectory** service tag.

## Exercise 6: Utilize MSI Authentication

- Open the `C:\labfiles\microsoft-postgresql-developer-guide\04_EndToEndDev\samples\04-05-FunctionApp-MSI` function app folder in Visual Studio Code
- Review the code to get an access token \ password for the managed identity in the `\ShowDatabasesFunction\__init__.py` file:

    ```python
    from azure.identity import DefaultAzureCredential, AzureCliCredential, ChainedTokenCredential, ManagedIdentityCredential
    managed_identity = ManagedIdentityCredential()
    scope = "https://management.azure.com"
    token = managed_identity.get_token(scope)
    access_token = token.token
    ```

- Notice how the access_token is used as the password. Update the connection code to use the `application id` and the access token. Be sure to replace `SUFFIX`:

    ```python
    # Connect to PostgreSQL
        cnx = psycopg2.connect(database="postgres",
            host="pgsqldevSUFFIXflex16.postgres.database.azure.com",
            user="APP_ID",
            password=access_token,
            port="5432",
            sslmode='require',
            sslrootcert=crtpath)
    ```

- Run the following to deploy the updated Azure Function App:

```powershell
func azure functionapp publish pgsqldevSUFFIX-ShowDatabasesFunction --force --python
```

Browse to the function endpoint and see the data (the output of the previous command will include this information). The function app is now running as a managed identity and connecting to the database using that identity:

```text
https://pgsqldevSUFFIX-ShowDatabasesFunction.azurewebsites.net/api/ShowDatabasesFunction?code=APPKEY
```
