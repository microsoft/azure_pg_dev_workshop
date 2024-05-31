## Connect, create and query Azure Database for PostgreSQL Flexible Server using pgAdmin

This section explains how to connect to and perform queries against Azure Database for PostgreSQL Flexible Server using PostgreSQL pgAdmin, a UI-based management tool.

There are multiple ways of accomplishing each database task in pgAdmin, including (but limited to), GUI-based forms, the query tool, and the interactive shell (PSQL tool). This section will demonstrate the use of many of these tools within pgAdmin.

### Setup

Follow one of the methods in the [Create a Flexible Server database](./03_00_Getting_Started_Provision_PostgreSQL_Flexible_Server.md) document to create a Flexible Server resource. Remember the admin username and password for the Flexible Server resource for use later in this section.

Download pgAdmin tool from the [pgAdmin Downloads](https://www.pgadmin.org/download/). Alternatively, use a package manager like [Chocolatey](https://community.chocolatey.org/packages/pgadmin4) and [WinGet](https://winget.run/search?query=pgAdmin) for Windows-based machines, as well as [Homebrew](https://formulae.brew.sh/cask/pgadmin4) for macOS. For Linux-based machines, use **yum** or **apt-get** to install pgAdmin.

![The pgAdmin splash screen.](media/pgadmin-splash.png "The pgAdmin splash screen")

### Connect pgAdmin to Azure Database for PostgreSQL Flexible Server

1. In the [Azure Portal](https://portal.azure.com), navigate to the Flexible Server resource created in the previous section.

2. From the left-hand menu, select **Connect**.

3. On the **Connect** screen, locate and expand the **pgAmin 4** section to find instructions on how to add a connection to the server in the pgAdmin software.

    ![pgAdmin instructions are displayed on the Connect screen of the Flexible Server resource in the Azure Portal.](media/pgadmin4-connection-instructions.png "pgAdmin server connection instructions")

4. On the target desktop, open the `pgAdmin` application and follow the instructions from the Azure Portal.

    ![The pgAdmin application will display with a connection to the Azure Database for PostgreSQL Flexible Server.](media/flexible-server-connected.png "Connection established to Flexible Server in pgAdmin")

### Create and connect to a new database in the Flexible Server instance using the Query Tool

1. In the pgAdmin application, expand the **Servers** node in the Object Explorer pane.

2. Expand the Flexible Server resource node.

3. Expand the **Databases** node.

4. Right-click on the **postgres** admin database and select **Query Tool**.

    ![The pgAdmin Object explorer displays with the context menu open on the postgres database. Query Tool is selected in the context menu.](media/query-tool-menu-postgres-db.png "postgres database context menu")

5. This will open a query window. Paste the following SQL statement into the query window and click the **Execute script** button to create a new database named **inventory**.

    ```sql
    CREATE DATABASE inventory;
    ```

    ![The pgAdmin Query Tool displays with the SQL statement to create a new database having executed successfully.](media/query-tool-create-database.png "Query Tool with CREATE DATABASE statement")

6. In the Object Explorer, right-click on the **Databases** node and select **Refresh**. The `inventory` database will display. Expand the **inventory** node to establish a connection into the new database.

    ![The pgAdmin Object Explorer displays with the inventory database expanded to show the database objects.](media/inventory-database-created.png "inventory database created")

7. Close the query tool tab that is connected to the **postgres** database. Do not save the changes.

### Create a table in the inventory database using the interactive shell (PSQL Tool)

1. In the Object Explorer, right-click on the **inventory** database and select **PSQL Tool**.

    ![The pgAdmin Object Explorer displays with the context menu open on the inventory database. PSQL Tool is selected in the context menu.](media/psql-tool-menu-inventory-db.png "inventory database context menu")

2. At the shell prompt, paste the following code and press <kbd>Enter</kbd>. The shell will output `CREATE TABLE` indicating the successful operation.

    ```sql
    CREATE TABLE products (id serial PRIMARY KEY, name VARCHAR(50), quantity INTEGER);
    ```

    ![The pgAdmin PSQL Tool displays with the SQL statement to create a new table having executed successfully.](media/psql-tool-create-table.png "PSQL Tool with CREATE TABLE statement")

3. In the Object Explorer, right-click the **inventory** database and select **Refresh**. Expand the **Schemas** item and the **public** node. The `products` table will display under **Tables**.

    ![The pgAdmin Object Explorer displays with the inventory database expanded to show the products table.](media/products-table-created.png "products table created")

4. Keep the PSQL Tool window open for use in the next section.

### Insert data into the products table using the PSQL Tool

1. In the PSQL Tool window, paste the following code and press <kbd>Enter</kbd>. The shell will output `INSERT 0 1` indicating the successful operation.

    ```sql
    INSERT INTO products (name, quantity) VALUES ('banana', 150);
    ```

2. Repeat the previous step to insert the following records into the `products` table.

    ```sql
    INSERT INTO products (name, quantity) VALUES ('orange', 154);
    INSERT INTO products (name, quantity) VALUES ('apple', 100);
    INSERT INTO products (name, quantity) VALUES ('kiwi', 200);
    ```

    ![The pgAdmin PSQL Tool displays with the SQL statements inserting new records having executed successfully.](media/psql-tool-insert-record.png "PSQL Tool with INSERT statements")

3. Close the PSQL Tool tab.

### Query the products table using the Query Tool

1. In Object Explorer, right-click the **products** table and select **Query Tool**.

2. In the query window, enter the following query and then select the **Execute script** button.

    ```sql
    SELECT * FROM products;
    ```

    ![The pgAdmin Query Tool displays with the SQL statement to query the products table having executed successfully.](media/query-tool-select-all.png "Query Tool with SELECT statement")

3. Keep the Query Tool window open for use in the next section.

### Update data in the products table using the Query Tool results grid

The output of the previous query displays ther results in a spreadsheet-like format. This data is editable in-line.

1. Double-click the quantity value for the `orange` record and change the value to `125`. Changed values will be bolded.

2. Select the **Save data changes** button to commit the changes back to the database.

    ![The Query Tool displays with the value for orange having been changed to 125. The Save data changes button is highlighted.](media/update-row-gui.png "Update row in grid")

3. Keep the Query Tool tab open for use in the next section.

### Delete data from the inventory table using the Query Tool

1. In the Query Tool window, replace the content with the following query and then select the **Execute script** button.

    ```sql
    DELETE FROM products WHERE name = 'kiwi';
    ```

    ![The pgAdmin Query Tool displays with the SQL statement to delete a record from the products table having executed successfully.](media/query-tool-delete-record.png "Query Tool with DELETE statement")

2. Change the query to a select query and notice the `kiwi` record is no longer present.

    ```sql
    SELECT * FROM products;
    ```

    ![The pgAdmin Query Tool displays with the SQL statement to query the products table having executed successfully.](media/query-tool-select-all-after-delete.png "Query Tool with SELECT statement")

3. Close the Query Tool tab.

### Clean up - Delete the database using the pgAdmin Object Explorer

1. Right-click on the **inventory** database, and select **Delete**.

    ![The inventory database context window displays with the Delete item highlighted.](media/delete-inventory-db.png)

2. Select **Yes** on the Delete Database confirmation modal dialog.

3. In Object Explorer, notice the **inventory** database is no longer present.
