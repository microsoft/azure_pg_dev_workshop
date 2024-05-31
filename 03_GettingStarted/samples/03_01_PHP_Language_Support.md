## PHP

This section describes tools to interact with Azure Database for PostgreSQL Flexible Server through PHP.

### Setup

1. Follow one of the methods in the [Create a Flexible Server database](./03_00_Getting_Started_Provision_PostgreSQL_Flexible_Server.md) document to create a Flexible Server instance.

2. Use [pgAdmin](./03_00-1_Query_PostgreSQL_pgAdmin.md) or the [Azure CLI](./03_00-2_Connect_Query_Azure_CLI.md) to create the `inventory` database on the Flexible Server.

3. Moreover, install and setup PHP from the [downloads page](https://windows.php.net/download/). These instructions have been tested with PHP 8.0.30 (any PHP 8.0 version should work). Optionally use a tool such as [XAMPP](https://www.apachefriends.org/download.html) to greatly simplify the installation process.

Prior to running the example code, the `php.ini` file needs to uncomment the `extension=pgsql` line by removing the leading semi-colon. This will include the PostgreSQL extension in the PHP runtime.

A text editor such as Visual Studio Code may also be useful.

### Getting started

Refer to the [Quickstart: Use PHP to connect and query data in Azure Database for PostgreSQL - Single Server](https://learn.microsoft.com/azure/postgresql/single-server/connect-php). While the article does indicate the example is for Azure Database for PostgreSQL - Single Server, it has also been tested with the Flexible Server architecture. The quickstart article demonstrates standard CRUD operations against the PostgreSQL instance from a PHP page.

### Further information

The following resources provide additional information on PHP on Azure and PostgreSQL references.

1. [Create a PHP web app in Azure App Service](https://aka.ms/php-qs)
2. [Introduction to PDO](https://www.php.net/manual/en/intro.pdo.php)
3. [Configure a PHP app for Azure App Service](https://learn.microsoft.com/azure/app-service/configure-language-php?pivots=platform-linux)
4. The [php.ini directives](https://www.php.net/manual/en/ini.list.php) allow for the customization of the PHP environment.

### Cleanup

This document introduced the `inventory` database. To remove the database, use [pgAdmin](./03_00-1_Query_PostgreSQL_pgAdmin.md) or the [Azure CLI](./03_00-2_Connect_Query_Azure_CLI.md) to drop the database.
