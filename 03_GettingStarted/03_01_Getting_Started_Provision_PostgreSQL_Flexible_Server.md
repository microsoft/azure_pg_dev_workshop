## Create a Flexible Server database

The focus of this guide is on demonstrating practical uses of Azure Database for PostgreSQL Flexible Server, such as querying Flexible Server with common languages and administrative tools. This section illustrates how to deploy Azure Database for PostgreSQL g Flexible Server using various Azure management tools in preparation to follow the guide application samples.

### Azure portal

Azure provides a [Quickstart document](https://learn.microsoft.com/azure/postgresql/flexible-server/quickstart-create-server-portal) for users who want to use the Azure portal to provision Flexible Server. While this is a fantastic opportunity to explore the configuration parameters of Azure Database for Flexible Server, IaC approaches, like the imperative Azure CLI or the declarative ARM template, are preferable to create deployments that can easily be replicated in other environments.

### Azure CLI

The Azure CLI `az postgresql flexible-server` set of commands is very robust. [Azure's quickstart guide](https://learn.microsoft.com/azure/postgresql/flexible-server/quickstart-create-server-cli) demonstrates how the `az postgresql flexible-server create` and `az postgresql flexible-server db create` commands can create new instances.

>![Note icon](media/note.png "Note") **Note:** It is possible to exercise greater control over these commands by reviewing the documentation for the [`flexible-server create`](https://learn.microsoft.com/cli/azure/postgres/flexible-server?view=azure-cli-latest#az-postgres-flexible-server-create) and [`flexible-server db create`](https://learn.microsoft.com/cli/azure/postgres/flexible-server/db?view=azure-cli-latest#az-postgres-flexible-server-db-create) commands.

Running the CLI commands from [Azure Cloud Shell](https://shell.azure.com) is preferable, as the context is already authenticated with Azure.

### ARM template

TODO: Update to Microsoft Repo

Azure provides a [Quickstart document](https://learn.microsoft.com/azure/postgresql/flexible-server/quickstart-create-server-arm-template) with a basic ARM template for a Flexible Server deployment. We have also provided an ARM template to support the applications explored in this guide (https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-0-create-development-vm/basic-template/template.json). The Azure sample template requires additional parameters to run. It can be deployed with the `New-AzResourceGroupDeployment` PowerShell command in the Quickstart or the `az deployment group create` CLI command. It is also possible to paste it into a new template deployment in the Azure Portal.

### Bicep

Bicep is a declarative language for describing and deploying Azure resources. It offers concise syntax, reliable type safety, and support for code reuse. Bicep is a domain-specific language (DSL) used to deploy Azure resources declaratively. It is a transparent abstraction over Azure Resource Manager (ARM) templates. Bicep uses the same template language as ARM and JSON but with a cleaner syntax and improved type safety. Bicep is a fantastic way to deploy Azure resources, including Azure Database for PostgreSQL Flexible Server. Azure provides a [Quickstart document](https://learn.microsoft.com/azure/postgresql/flexible-server/quickstart-create-server-bicep) with Bicep code for a Flexible Server deployment.

### Terraform

Terraform is a third-party open-source infrastructure as code software tool that enables organizations to safely and predictably create, change, and improve infrastructure. Azure documentation provides an [article](https://learn.microsoft.com/azure/developer/terraform/deploy-postgresql-flexible-server-database?tabs=azure-cli) outlining Terraform code for a Flexible Server deployment.

### Default settings

When creating an instance using the tools above, without passing any additional configuration parameters, an instance with the following defaults will be created:

- Default connectivity method is Public access
- The same location as the target resource group
- Auto-generated admin username and admin password (this should be saved in a secure place)
- A default database named "flexibleserverdb"
- Service defaults for remaining server configurations:
  - Compute tier (General Purpose)
  - Compute size/SKU (Standard_D2s_v3 - 2 vCore, 8 GB RAM)
  - Backup retention period (7 days)
  - PostgreSQL version (13)

Reference the [Compute and storage options in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-compute-storage) for more information on all the available compute, storage and memory options available for Azure Database for PostgreSQL Flexible Server. Azure Database for PostgreSQL Flexible Server can accommodate a very large set of use cases and workloads.

### After Creation

After creating an Azure Database for Flexible Server, several configuration settings can be modified to support the application workload needs.

### Storage

Azure Database for PostgreSQL - Flexible Server uses [Azure managed disks](https://learn.microsoft.com/azure/virtual-machines/disks-types). When increasing storage, the default behavior is to increase the disk size to the next premium tier. This increase is always double in both size and cost, regardless of whether the storage scaling operation is performed manually or through storage auto grow. Enabling storage autogrow is valuable when with unpredictable workloads because it automatically detects low-storage conditions and scales up the storage accordingly.

> NOTE: After increasing the storage size, it is not possible to go back to a smaller storage size.

There are [some limitations](https://learn.microsoft.com/azure/virtual-machines/disks-types) when working with Azure managed disk storage.

Although currently in preview and with [some limitations](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-compute-storage#premium-ssd-v2-early-preview-limitations), Premium SSD v2 will become generally available for Azure Database for PostgreSQL Flexible Server and will increase the performance IOPS and disk sizes.

Another advantage of Premium SSD v2 is that, as of writing, they come with 3000 IOPS and 125MB/s free of charge.

### Networking

The connectivity method cannot be changed after creating the server. For example, if Private access is selected (VNet Integration) during creation, then it cannot be changed to Public access (allowed IP addresses) later. It is highly recommended to create a server with Private access to enable secure restricted access to the server using VNet Integration.

Connections to Azure Database for PostgreSQL Flexible Server communicate over port 5432. Trying to connect from within a corporate network, outbound traffic over port 5432 might not be allowed. If this is the case, it may not be possible to connect to the server unless the IT department opens port 5432.

Options like Express Route may also be used to open network paths to the cloud instances if accessing over the public internet is against corporate policies.

### PgBouncer

[PgBouncer](https://github.com/pgbouncer/pgbouncer) is a lightweight connection pooler for PostgreSQL that is included with Azure Database for PostgreSQL Flexible Server free of charge and enabled via the `pgbouncer.enabled` server parameter. The purpose of connection pooling is to make it efficient for applications to connect to Postgres instances.

Every time a new connection is created, PostgreSQL spawns a new process using the postmaster process, which consumes more resources. It tends to be costly to establish a database connection, taking around 1.5–14.5 MB per connection. If there are 100 open connections to the database, that will take a maximum of ~1.45GB of RAM just to maintain the connections. In addition to allowing more connections to the database, PgBouncer can be used to:

- Protect the instance from massive number of connections. In pgbouncer, set the maximum number of connections to the PostgreSQL server. If an external system tries to open more connections than the maximum number of allowed connections, PgBouncer will reject the connection before reaching the upstream database server.

> NOTE: PgBouncer is not used to speed up queries. In later sections other Azure Database for PostgreSQL Flexible Server tools will be discussed to help find and assist with improving query performance.

For an example of real-world PgBouncer usage, reference [Scaling the GitLab database](https://about.gitlab.com/blog/2017/10/02/scaling-the-gitlab-database/).

For the latest on PgBouncer and Azure Database for PostgreSQL Flexible Server support, reference [PgBouncer in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-pgbouncer).

Also reference [Connection pooling strategy for PostgreSQL Using PgBouncer](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-connection-pooling-best-practices).

### Troubleshooting

When attempting to connect to the instance, if the connection fails, try these simple solutions:

- Check if port 5432/6432 is accessible.
- If the server administrator user name and password are correct.
- If the configured firewall rule is created for the client machine.
- If the configured firewall rule for the sync server instance.
- If private access has been configured in virtual networking, make sure the client machine is in the same virtual network or has access to route to the server.

Note that if PgBouncer is enabled on the instance of Flexible Server and applications want to connect through it, it is important that port 6432 is opened for traffic.

Because Azure Database for PostgreSQL Flexible Server is a managed database service, users are not provided host or OS access to view or modify configuration files such as `pg_hba.conf`. The content of the files is automatically updated based on the network settings.

For more information, review:

- [Networking overview for Azure Database for PostgreSQL - Flexible Server with public access (allowed IP addresses)](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-networking-public)
- [Networking overview for Azure Database for PostgreSQL - Flexible Server with private access (VNET Integration)](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-networking-private)
- [Azure Database for PostgreSQL Flexible Server Networking with Private Link - Preview](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-networking-private-link)

We explore working with VNET Integration in the `Logic App` developer lab. This lab will set up an Azure Gateway in a Virtual Machine to allow a cloud-based Logic App access to a private network Azure Database for PostgreSQL instance.

### Firewall Rules

With public access, the Azure Database for PostgreSQL Flexible Server is accessed through a public endpoint. By default, the firewall blocks all access to the server. Server-level firewall rules are used to specify which IP addresses can access the server. Firewall rules specify allowed public IP address ranges. The firewall grants access to the server based on the originating IP address of each request. With private access no public endpoint is available and only hosts located on the same network can access Azure Database for PostgreSQL Flexible Server.

There are some limitations to firewall rules, reference [Troubleshoot firewall problems](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-firewall-rules#troubleshoot-firewall-problems) for the latest information. The two most important items to note:

- Firewall does not support allowing dynamic IP addresses : This can occur when an ISP cycles the public IP address for an outbound connection.
- Firewall rules are not available for IPv6 format: The firewall rules must be in IPv4 format. Specifying firewall rules in IPv6 format will cause validation error.

When connecting from other Azure services, it may be difficult to keep track of IP addresses these services use. The **Allow public access from any Azure service within Azure to this server** option is designed to allow access from these services. However, this option configures the firewall to allow **all** connections from Azure, including connections from the subscriptions of other customers. When using this option, make sure sign-in and user permissions limit access to only authorized users.

### SSL

Once an Azure Database for PostgreSQL Flexible Server instance has been created, the next step is to connect to it. The next few sections will demonstrate how to connect from various languages. All of them will have the option to connect with or without SSL.

Most of the libraries support SSL connectivity, but modifying applications to support SSL connectivity can be non-trivial.

In all cases, it is necessary to download the SSL certificate from `https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem`. How it is stored and referenced will be a varying factor.

For example, with `psql`, a typical SSL-based connection string will look something like the following:

```cmd
psql --host=mydemoserver-pg.postgres.database.azure.com --port=5432 --username=myadmin --dbname=postgres --set=sslmode=require --set=sslrootcert=DigiCertGlobalRootCA.crt.pem
```

Notice the two additional command line switches (`sslmode` and `sslrootcert`) that enable SSL and tell the tool where the certificate resides.

Read more about TLS and SSL by referencing [Secure connectivity with TLS and SSL](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-networking-ssl-tls).

### Admin users

While creating a server, it is required to set up the credentials for the admin user. The admin user is the highest privileged user on the server that is available to be used. It belongs to the role `azure_pg_admin`. This role does not have full `superuser` permissions.

The PostgreSQL `superuser` attribute is assigned to the `azure_superuser`, which belongs to the managed service. This role cannot be accessed by Azure customers.

An Azure Database for PostgreSQL Flexible Server has default databases:

- **postgres** - The default database when a server is created.
- **azure_maintenance** - This database is used to separate the processes that provide the managed service from user actions. Access to this database is not allowed.

### Microsoft Entra Authentication

In addition to basic PostgreSQL usernames and passwords, Azure Entra authentication can be used to log in to the PostgreSQL instance. This must be enabled via the Portal, Azure CLI, PowerShell, or REST APIs.

Once enabled, utilize basic Microsoft Entra flows to generate access tokens that are used as the password for the connection.

There are some drawbacks to utilizing this approach. One such drawback is the token will expire typically after about 60 minutes. Unless a mechanism to re-try and get a new token is used, it is possible that long-running operations may break after an hour.

Reference the pgAdmin retry using the **Advanced** tab and `password exec` feature in the [06-04-FunctionApp-MSI] developer lab.

For more information, reference [Microsoft Entra authentication with PostgreSQL Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-azure-ad-authentication).

### Managed Service Identities (MSI)

When Microsoft Entra Authentication is enabled, is becomes possible to assign other service-managed identities (both system and user) to be able to access the PostgreSQL instance. These can be assigned in the same way as assigning Entra Administrators or they can be given granular permissions.

It is also possible to assign Entra groups to Azure Database for PostgreSQL roles and permissions. In most cases, it will be easier to create a group and then add the MSI to the group. After assigning to a group, assign the required permissions to the group rather than the individual identities.

When working with MSI, be sure to follow the steps for Azure Database for Flexible Server and not steps that might be related to other instance types. It can be confusing when browsing articles on the internet or even the Microsoft Docs pages.

Reference the [FunctionApp-MSI] developer lab for examples of how to do this. Also, reference [Connect with Managed Identity to Azure Database for PostgreSQL Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-connect-with-managed-identity) and [Manage Microsoft Entra roles in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-manage-azure-ad-users).

> NOTE: If the system is using VNet integration, ensure outbound connectivity to **AzureActiveDirectory** service tag. Additionally, if using a route table, create a rule with destination service tag AzureActiveDirectory and next hop Internet.

### SCRAM

The [Salted Challenge Response Authentication Mechanism (SCRAM)](https://datatracker.ietf.org/doc/html/rfc5802) greatly improves the security of password-based user authentication by adding several key security features that prevent rainbow-table attacks, man-in-the-middle attacks, and stored password attacks, while also adding support for multiple hashing algorithms and passwords that contain non-ASCII characters.

Each client driver must be able to support SCRAM in order to utilize it. Find a list of drivers and their ability to support SCRAM [here](https://wiki.postgresql.org/wiki/List_of_drivers). Most, if not all, of the latest versions of the clients support SCRAM.

### Row-Level Security

Row -level security (RLS) is a PostgreSQL security feature that allows database administrators to define policies to control how specific rows of data display and operate for one or more roles. Row-level security is an additional security filter that can be applied to a PostgreSQL database table.

In PostgreSQL, it is possible for a user to be assigned the `BYPASSRLS` attribute by another `superuser`. With this permission, a user can bypass RLS for all tables in Postgres, as is `superuser`. That permission cannot be assigned in Azure Database for PostgreSQL - Flexible Server, since the administrator role has no superuser privileges, as common in cloud-based PaaS PostgreSQL service.

### Extensions

Flexible Server supports all `contrib` extensions and more. Please refer to [PostgreSQL extensions](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-extensions#extension-versions).

### Limitations

As a recap, not all PostgreSQL features are available in Azure Database for PostgreSQL Flexible Server. To read more about these limitations, reference [Limits in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-limits).
