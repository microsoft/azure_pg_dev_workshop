## Flexible Server deployment sample ARM template

### Create public network Flexible Server

Utilize the ARM template provided in this directory (`PostgreSQL-flexible-server-template.json`) to quickly deploy a PostgreSQL Flexible Server instance to Azure. When deploying, simply provider the `serverName`, `administratorLogin`, and `administratorLoginPassword` for the template to deploy successfully. It is possible to edit these values in the provided parameter file (`PostgreSQL-flexible-server-template.parameters.json`).

Once completed, use the Azure CLI to deploy the template.

```bash
az deployment group create --resource-group [RESOURCE GROUP] --template-file ./PostgreSQL-flexible-server-template.json --parameters @PostgreSQL-flexible-server-template.parameters.json
```

### Create Private network Flexible Server

- Browse to the Azure Portal
- Select the lab resource group
- Select **Create**
- Search for **PostgreSQL**, then select **Azure Database for PostgreSQL Flexible Server**
- Select **Create*
- In the drop-down, select **Flexible Server**
- Select **Create**
- Select the lab subscription and resource group
- For the name, type **pgsqldevSUFFIXflex**
- For the PostgreSQL version, select **16**
- For the admin username, type **wsuser**
- For the password and confirm password, type **Solliance123**
- Select **Next: Networking>**
- Select **Private Network access**
- Select the lab subscription
- Select the **pgsqldevSUFFIX-db** virtual network
- Select the **default** subnet
- For the private DNS zone, select **private.postgres.database.azure.com**
- Select **Review + create**
- Select **Create**
