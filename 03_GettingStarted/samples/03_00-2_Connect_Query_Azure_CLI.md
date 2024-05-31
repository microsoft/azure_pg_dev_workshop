## Connect and query an Azure Database for PostgreSQL Flexible Server using the Azure CLI

pgAdmin is not the only method of running queries against a PostgreSQL database. This section explains how to perform queries against Azure Database for PostgreSQL Flexible Server using the Azure CLI and the [`az postgres flexible-server` utilities](https://learn.microsoft.com/cli/azure/postgres/flexible-server?view=azure-cli-latest) and references the steps in the [Quickstart: Connect and query with Azure CLI with Azure Database for PostgreSQL Flexible Server - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/connect-azure-cli#create-a-database) article.

The Azure CLI supports running queries interactively, via the `az postgres flexible-server connect` command, which is like running queries interactively against a PostgreSQL instance through the PostgreSQL CLI (also known as the PSQL Tool). Alternatively, It is also possible to run an individual SQL query or a SQL file using the `az postgres flexible-server execute` command.

### Setup

While the Azure Quickstart article mentioned above demonstrates how to provision a Flexible Server instance using the CLI, any of the presented provisioning methods in the [Create a Flexible Server database](./03_00_Getting_Started_Provision_PostgreSQL_Flexible_Server.md) section are possible.

Running the CLI commands from the [Azure Cloud Shell](https://shell.azure.com) is preferable, as the context is already authenticated with Azure.

>![Note icon](media/note.png "Note") **Note:** These commands require the `rdbms-connect` CLI extension, which is automatically installed if it is not present.

>![Note icon](media/note.png "Note") **Note:** The server must be setup to accept network traffic from other Azure services. Find this setting in the **Networking** section of the Flexible Server resource in the Azure Portal. It is located under the **Firewall rules** heading. Similarly, when connecting from a local machine, add the IP address to the firewall rules (or allow all traffic by adding the range: 0.0.0.0 - 255.255.255.255).

### Create a database on the Flexible Server

In this section, we will create a new database named `inventory` on the Flexible Server instance using the Azure CLI `az postgres flexible-server db create` command.

1. Retrieve the existing server name from the [Azure Portal](https://portal.azure.com) by navigating to the Flexible Server resource. The server name is displayed on the Overview page or in the header of the resource page. Do not include `.postgres.database.azure.com` in the server name. Also make note of the resource group name.

    ![The server name is displayed on the Overview page of the Flexible Server resource.](media/azure-portal-flexible-server-overview-server-name.png "Azure Portal server name")

2. Open an [Azure Cloud Shell](https://shell.azure.com/) window and run the following command to create the **inventory** database on the Flexible Server. Replace the `<resource-group>` and `<server-name>` placeholders with the resource group and server name from the previous step.

    ```bash
    az postgres flexible-server db create -g <resource-group> -s <server-name> -d inventory
    ```

    ![The Azure CLI displays the command to create a new database.](media/az-postgres-flexible-server-create-database.png "Azure CLI create database")

### Create a table in the inventory database

In this section, we will use the `az postgres flexible-server execute` command to create a table named `products` in the `inventory` database.

1. In the cloud shell, run the following command to create the `products` table in the `inventory` database. Replace the `<server-name>`, `<username>`, and `<password>` placeholders values.

    ```bash
    az postgres flexible-server execute -n <server-name> -u <username> -p <password> -d inventory -q "CREATE TABLE products (id serial PRIMARY KEY, name VARCHAR(50), quantity INTEGER);"
    ```

    ![The Azure CLI displays the command to create a new table.](media/az-postgres-flexible-server-create-table.png "Azure CLI create table")

### Insert data into the products table

In this section, we will use the `az postgres flexible-server execute` command to insert data into the `products` table with a SQL file containing the `INSERT` statements.

1. In a text editor, create and save the `products.sql` file with the following contents:

    ```sql
    INSERT INTO products (name, quantity) VALUES ('banana', 150);
    INSERT INTO products (name, quantity) VALUES ('orange', 154);
    INSERT INTO products (name, quantity) VALUES ('apple', 100);
    ```

2. In the cloud shell, upload the `proucts.sql` file to the cloud shell using the **Upload/Download files** button in the cloud shell toolbar.

    ![The cloud shell toolbar displays with the Upload/Download files button highlighted.](media/cloud-shell-upload-download-files.png "Upload/Download files")

3. Execute the following command to run the uploaded `products.sql` script.

    ```bash
    az postgres flexible-server execute -n <server-name> -u <username> -p <password> -d inventory -f products.sql
    ```

    ![The Azure CLI displays the command to execute the SQL script.](media/az-postgres-flexible-server-execute-script.png "Azure CLI execute script")

### Query the products table using the interactive shell (PSQL Tool)

In this section, we will use the `az postgres flexible-server connect` command with the `--interactive` flag to connect to the `inventory` database. This connection will open the PostgreSQL interactive shell that allows us to query the `products` table.

1. In the cloud shell, replace the `<server-name>` and `<username>` placeholders. Press **Enter** to be prompted for the password when the command is submitted.

    ```bash
    az postgres flexible-server connect -n <server-name> -u <username> -d inventory --interactive
    ```

2. Enter the password for the admin user when prompted. The Azure CLI will connect to the Flexible Server instance and display the connection information.

    ![A cloud shell terminal displays with the flexible-server connect command executed. The database prompt is shown.](media/db-connected-cli-postgres-prompt.png "Connect to the Flexible Server admin database: inventory")

3. At the database (`inventory`) prompt, run the following SQL statement to query the `products` table.

    ```sql
    SELECT * FROM products;
    ```

    ![The PSQL prompt shows the products query and displays the results in tabular format.](media/cli_psql_products_selection.png "PSQL products query result")

### Update and delete data in the products table

In this section, we will continue in the PSQL interactive shell to update and delete data in the `products` table.

1. At the database (`inventory`) prompt, run the following SQL statement to update the `quantity` of the `banana` product. When prompted to proceed with a destructive call, enter `y` to continue.

    ```sql
    UPDATE products SET quantity = 200 WHERE name = 'banana';
    ```

    ![The PSQL prompt shows the products update query update is successful.](media/cli_psql_products_update.png "PSQL update product query result")

2. Run the `SELECT` statement again to verify the `banana` product quantity is updated.

    ```sql
    SELECT * FROM products;
    ```

3. Delete the `orange` record by executing the following SQL statement. When prompted to proceed with a destructive call, enter `y` to continue.

    ```sql
    DELETE FROM products WHERE name = 'orange';
    ```

4. Run the `SELECT` statement again to verify the `orange` product is deleted.

    ```sql
    SELECT * FROM products;
    ```

5. Exit the PSQL interactive shell by running the following command. The Azure Cloud Shell prompt will be restored.

    ```bash
    exit
    ```

    ![Exit is entered at the database prompt returning to the Azure Cloud Shell prompt.](media/cli-exit-psql-interactive-shell.png "Exit the PSQL interactive shell")

### SQL Files

In addtion to running interactive commands, it is also possible to execute SQL files with Azure CLI. This can be accomplished by using the `--file-path` argument in the Azure CLI command.

### Clean up - Delete the database

In this section, we will use the `az postgres flexible-server db delete` command to delete the `inventory` database.

1. In the cloud shell, run the following command to delete the **inventory** database. Replace the `<resource-group>` and `<server-name>` placeholders values. When prompted to confirm the deletion, enter `y` to continue.

    ```bash
    az postgres flexible-server db delete -g <resource-group> -s <server-name> -d inventory
    ```

    ![The Azure CLI displays the command to delete the database.](media/az-postgres-flexible-server-delete-database.png "Azure CLI delete database")
