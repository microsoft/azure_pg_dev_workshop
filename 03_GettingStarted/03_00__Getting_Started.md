# 03 / Getting Started - Setup and Tools

With a firm understanding of PostgreSQL and other offerings available in Azure, it is time to review how to start using these various services in applications. In this chapter, we explore how to get Azure subscriptions configured and ready to host PostgreSQL applications. Common PostgreSQL application types and the various tools to simplify their deployment will reviewed. Sample code will make it easier to get started faster and understand high-level concepts.

## Azure free account

Azure offers a [$200 free credit for developers to trial Azure](https://azure.microsoft.com/free) or jump right into a Pay-as-you-go subscription. The free account includes credits for 750 compute hours of Azure Database for PostgreSQL Flexible Server - Flexible Server. [Innovate faster with fully managed PostgreSQL and an Azure free account.](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-deploy-on-azure-free-account)

## Azure subscriptions and limits

As explained in the [Introduction to Azure resource management](../02_IntroToPostgreSQL/02_02_Introduction_to_Azure_resource_mgmt.md), subscriptions are a critical component of the Azure hierarchy: resources cannot be provisioned without an Azure subscription, and although the cloud is highly scalable, it is not possible to provision an unlimited number of resources. A set of initial limits applies to all Azure subscriptions. However, the limits for some Azure services can be raised, assuming that the Azure subscription is not a free trial. Organizations can raise these limits by submitting support tickets through the Azure Portal. Limit increase requests help Microsoft capacity planning teams understand if they need to provide more capacity when needed.

Since most Azure services are provisioned in regions, some limits apply at the regional level. Developers must consider both global and regional subscription limits when developing and deploying applications.

Consult [Azure's comprehensive list of service and subscription limits](https://learn.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits) for more details.

## Microsoft Entra authentication

As mentioned previously, Azure Database for PostgreSQL Flexible Server consists of a data plane (data storage and data manipulation) and a control plane (management of the Azure resource). Authentication is separated between the control plane and the data plane as well.

In the control plane, Microsoft Entra authenticates users and determines whether users are authorized to operate against an Azure resource. Review Azure RBAC in the [Introduction to Azure Resource Management section for more information.

The built-in PostgreSQL account management system governs access for administrator and non-administrator users in the data plane. Moreover, Azure Database for PostgreSQL Flexible Server supports security principals in Microsoft Entra, like users and groups, for data-plane access management. Using AAD data-plane access management allows organizations to enforce credential policies, specify authentication modes, and more. Refer to the [Microsoft docs](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-azure-ad-authentication) for more information.

## Development editor tools

Developers have various code editor tools to choose from to complete their IT projects. Commercial organizations and OSS communities have produced tools and plug-ins making Azure application development efficient and rapid.

### Visual Studio Code

Visual Studio Code (VS Code) is an open-source, cross-platform text editor. It offers useful utilities for various languages through extensions. Download VS Code from the [Microsoft download page.](https://code.visualstudio.com/download)

![A simple screenshot of Visual Studio Code.](media/VSCode_screenshot.png "Visual Studio Code")

The [PostgreSQL](https://marketplace.visualstudio.com/items?itemName=ckolkman.vscode-postgres) extension allows developers to:

- Management of PostgreSQL connections
- List Servers/Database/Functions/Tables/Columns (primary key/type)
- Quickly select top * (with limit) of a table
- Run Queries
- All queries in a pgsql file (; delimited)
- Selected query in pgsql file
- Selected query in ANY file (via context menu or command palette)
- Individual editors can have different connections
- Quickly change connection database by clicking the DB in the status bar
- Syntax Highlighting
- Connection aware code completion (keywords, functions, tables, and fields)
- In-line error detection powered by EXPLAIN (one error per query in editor)
- Basic function signature support (connection aware)

Consider adding it to Visual Studio Code environment to make working with PostgreSQL instances more efficient.

### Azure Data Studio

Another useful tool that can be used is Azure Data Studio. Azure Data Studio provides a rich set of features to enhance productivity and collaboration. It supports advanced editing capabilities, intelligent code completion, and integrated source control. Users can also leverage built-in extensions and integrations with other Azure services to streamline their data management tasks.

One of the key advantages of Azure Data Studio is its cross-platform compatibility, as it can be installed and used on Windows, macOS, and Linux systems. This flexibility enables users to work seamlessly across different operating systems and collaborate effectively.

Leverage the [extension for PostgreSQL](https://learn.microsoft.com/azure-data-studio/quickstart-postgres) to connect to Azure Database for PostgreSQL Flexible Server.

## Cost saving tip

>![Note icon](media/note.png "Note") **Note:** When done developing for the day, stop the Azure Database for Flexible Server. This feature helps keep the organizational costs low.
