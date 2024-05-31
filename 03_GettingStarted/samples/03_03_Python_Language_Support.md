## Python

This section will demonstrate how to query Azure Database for PostgreSQL Flexible Server using the `psycopg2` library on Python 3.

### Setup

Follow one of the methods in the [Create a Flexible Server database](./03_00_Getting_Started_Provision_PostgreSQL_Flexible_Server.md) document to create a Flexible Server resource. Remember the admin username and password for the Flexible Server resource.

Moreover, install Python 3.8 or above from the [Downloads page](https://www.python.org/downloads/).

A text editor like Visual Studio Code will greatly help.

Though a Python Virtual Environment is not necessary for the sample to run, using one will avoid conflicts with packages installed globally on the development system. The commands below will create a Virtual Environment called `venv` and activate it on Windows. [Instructions](https://python.land/virtual-environments/virtualenv) will differ for other operating systems.

```cmd
python -m venv venv
.\venv\Scripts\activate
```

### Azure SDK for Python

The [Azure SDK for Python](https://learn.microsoft.com/azure/developer/python/sdk/azure-sdk-overview) is an open-source collection of over 180 libraries and tools that allow developers to build applications that provision, manage, and use a wide range of Azure services.

The libraries are organized clearly delineated to distinguish between [management (control plane)](https://learn.microsoft.com/azure/developer/python/sdk/azure-sdk-overview#create-and-manage-azure-resources-with-management-libraries) and [client (data plane)](https://learn.microsoft.com/azure/developer/python/sdk/azure-sdk-overview#connect-to-and-use-azure-resources-with-client-libraries) libraries.

#### Use the Azure SDK management library to create a Flexible Server database

In this section, we will create a Flexible Server database using the Azure SDK for Python.

>![Note icon](media/note.png "Note") **Note:** The ability to create resource groups and the [PostgreSQL Flexible Server instances](https://learn.microsoft.com/azure/postgresql/flexible-server/quickstart-create-server-python-sdk) are also available in the SDK.

This code must be run in a terminal or notebook that is authenticated to Azure. For more information, see [Authenticate the Azure SDK for Python](https://learn.microsoft.com/azure/developer/python/azure-sdk-authenticate?tabs=cmd#authenticate-with-azure-cli). Also ensure the proper subscription is selected, if needed run the `az account set --subscription <subscription_id>` command.

1. Install the required libraries.

    ```bash
    pip install azure-mgmt-resource
    pip install azure-identity 
    pip install azure-mgmt-rdbms
    ```

2. Create a file named `create_flexible_server_database.py` and paste the following code into it. Replace the placeholders for `subscription_id`, `resource_group_name`, and `server_name` to reflect the environment.

      ```python
      from azure.identity import DefaultAzureCredential
      from azure.mgmt.rdbms.postgresql_flexibleservers import PostgreSQLManagementClient
      from azure.mgmt.rdbms.postgresql_flexibleservers.models import Database

      credential = DefaultAzureCredential()
      subscription_id = "<subscription_id>"
      resource_group_name = "<resource_group_name>"
      server_name = "<server_name>"
      database_name = "inventory"

      # Authenticate with Azure account
      credential = DefaultAzureCredential()
      # Create PostgreSQL management client
      postgres_client = PostgreSQLManagementClient(credential, subscription_id)

      # Create the inventory database
      postgres_client.databases.begin_create(
          resource_group_name = resource_group_name,
          server_name = server_name,
          database_name = database_name,
          parameters = Database(charset="UTF8", collation="en_US.UTF8")
      ).result()
      ```

3. Run the code and then verify the database is created.

    ```bash
    python create_flexible_server_database.py
    ```

### Getting started

Refer to the [Quickstart: Use Python to connect and query data in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/connect-python). for detailed instructions on how to get started with Python and Azure Database for PostgreSQL Flexible Server. This article covers connecting to the database, creating a table, and performing CRUD operations.

Reference the Python sample (06-02-FunctionApp-Python) in this developer guide.

### Further information

Microsoft has a tutorial on one of the popular applications of Azure Database for PostgreSQL Flexible Server, using Python. See [building a Python web application with Flask or Django with Azure Database for PostgreSQL Flexible Server](https://learn.microsoft.com/azure/app-service/tutorial-python-postgresql-app?tabs=flask%2Cwindows&pivots=azure-portal) for more information.

### Cleanup

The following Azure SDK code will delete the database created earlier. Alternatively, use the portal or Azure CLI to delete the database.

```python
postgres_client.databases.begin_delete(
    resource_group_name = resource_group_name,
    server_name = server_name,
    database_name = database_name
).result()
```

If a Python Virtual Environment was created, enter `deactivate` into the console to remove it.
