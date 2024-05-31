# Hands-on Lab: Azure Synapse Analytics with PostgreSQL

In this hands-on lab, Azure Synapse Analytics will be used to connect to an Azure Database for PostgreSQL Flexible Server and create Power BI reports from the data.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure Synapse Analytics
- Azure Database for PostgreSQL Flexible Server
- Power BI Workspace

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

### Software pre-requisites

All this is done already in the lab setup scripts for the Lab virtual machine but is provided here for reference.

- Install [Power BI Desktop](https://www.microsoft.com/download/details.aspx?id=58494)

### Restore the Database

- Run the following command to create the `contosostore` database, be sure to replace the `SUFFIX`:

    ```powershell
    $filePath = "c:\labfiles\microsoft-postgresql-developer-guide\artifacts\data.sql"
    $env:Path += ';C:\Program Files\PostgreSQL\16\bin'
    
    #set the password
    $env:PGPASSWORD="Solliance123"
    $serverName = "pgsqldevSUFFIXflex16"
    $databaseName = "contosostore"

    psql -h "$($serverName).postgres.database.azure.com" -d $databaseName -U wsuser -p 5432 -a -w -f $filePath
    ```

## Exercise 1: Create PostgreSQL Linked Service

- Create a new Azure Synapse Analytics workspace.
- Navigate to the **pgsqldevSUFFIX** Azure Synapse Analytics Workspace.
- Under **Security**, select **Networking**.
- Check the **Allow Azure services and resources to access this workspace** checkbox.
- Select the **+ Add client IP**.
- Select **Save**.
- Select **Overview**, then in the **Getting started** area, select the **Open** link for Synapse Studio.
- Log in if prompted.
- Select the **Manage** tab.
- Under **External connections** select **Linked services**.
- Select **+ New**.
- For the type, select **Azure Database for PostgreSQL**, then select **Continue**.
- For the name, type **contosostore**.
- For the account selection, select **From Azure Subscription**.
- Select the subscription.
- Select the **pgsqldevSUFFIX** Azure Database for PostgreSQL Flexible Server server.
- For the database name, type **contosostore**.
- For the username, type **wsuser**.
- For the password, type **Solliance123**.
- For the encryption method, select **RequestSSL**
- Select **Test connection**, then ensure a success message is displayed.
- Select **Create**.

## Exercise 2: Create PowerBI Workspace

- Open the Power BI Portal, https://powerbi.microsoft.com.
- Sign in with the lab credentials.
- In the left navigation, expand **Workspaces**.
- Select **+ New workspace**.
- For the name, type **PostgreSQL**.
- Select **Apply**.

## Exercise 3: Create PowerBI Linked Service

- Switch back to Azure Synapse.
- Select the **Manage** tab.
- Under **External connections** select **Linked services**.
- Select **+ New**.
- For the type, select **Power BI**, then select **Continue**.
- For the name, type **PowerBI**.
- Select the lab tenant.
- Select the **PostgreSQL** workspace.
- Select **Create**.

## Exercise 4: Create Integration Dataset

- Select the **Data** tab.
- Select the **+** button.
- Select **Integration Dataset**.
- For the type, select **Azure Database for PostgreSQL**, then select **Continue**.
- For the name, type **contosostore_orders**.
- For the linked service **contosostore**.
- Select **OK**.
- Select **Publish all**, then select **Publish**.

## Exercise 5: Create PowerBI Desktop Report (Dataset)

- Switch to the **pgsqldevSUFFIX-win11** virtual machine.
- Open **Power BI Desktop**, then select **New Report**
- In the ribbon, select **Get data**, then select **More**
- Select **Azure Databse for PostgreSQL**.
- Select **Connect**.
- For the server name, enter **pgsqldevSUFFIXflex16.postgres.database.azure.com**.
- For the database, select **contosostore**.
- Select **OK**.
- Select the **Database** tab.
- For the user name, type **wsuser**.
- For the password, type **Solliance123**.
- Select **Connect**.
- Check all the checkboxes.
- Select **Load**.
- Select **File->Save as**, save the report to the desktop as **PostgreSQL**.
- Select **Save**.

## Exercise 6: Publish the PowerBI report to Power BI Online

- Select **File->Publish**.
- Select **Publish to Power BI**.
- When prompted, log in with the lab credentials.
- Select the **PostgreSQL** workspace.
- Select **Select**.
- Select the **Open 'PostgreSQL.pbix' in Power BI** link.
- Login using the lab credentials.
- Ensure the **PostgreSQL** workspace is selected.
- Select the **PostgreSQL** semantic model.
- In the **Tables** window, select the **public users** table.
- Select **Create paginated report**.
- Select **File->Save**, then save the report as **Contoso Users**.
- Select **Save**, the report should load in the workspace.

## Exercise 7: Create PowerBI Report in Azure Synapse

- Switch back to Azure Synapse
- Select the **Develop** tab.
- Select the **+** button.
- Select **Power BI report**.
- Select the **PostgreSQL** data set.
- Select **Create**.
- In the **Data** window, expand the **contosostore categories** table.
- Select the `id`, `name` and `img` fields.
- Select **File->Save as**.
- Save the report as **Contoso Categories**.
- Select **Save**, the report should load in the Azure Synapse workspace.
