# 08 / PostgreSQL Architectures

By progressing through this guide, there have been various ways presented to build and deploy applications using many different services in Azure. Although we covered many topics, there are many other creative and different ways to build and deploy PostgreSQL-based services.

The [Azure Architecture center](https://learn.microsoft.com/azure/architecture/) provides many different examples of how to create different architectures. Although some of them utilize other database persistence technologies, these could easily be substituted with Azure Database for PostgreSQL Flexible Server Flexible Server.

## Sample architectures

The following are a few examples of architectures using different patterns and focused on various industries from the Azure Architecture Center.

### Finance management apps using Azure Database for PostgreSQL Flexible Server

- [Finance management apps using Azure Database for PostgreSQL Flexible Server:](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/finance-management-apps-using-azure-database-for-PostgreSQL) This architecture demonstrates a three-tier app, coupled with advanced analytics served by Power BI. Tier-3 clients, like mobile applications, access tier-2 APIs in an Azure App Service, which reference tier-1 Azure Database for PostgreSQL Flexible Server. To offer additional value, [Power BI](https://learn.microsoft.com/power-bi/fundamentals/power-bi-overview) accesses Azure Database for PostgreSQL Flexible Server (possibly read replicas) through its PostgreSQL connector.

### Intelligent apps using Azure Database for PostgreSQL Flexible Server

- [Intelligent apps using Azure Database for PostgreSQL Flexible Server:](https://learn.microsoft.com/azure/architecture/databases/idea/intelligent-apps-using-azure-database-for-postgresql) This solution demonstrates an innovative app that utilizes serverless computing (Azure Function Apps), machine learning (Azure Machine Learning Studio & Cognitive Services APIs), Azure Database for PostgreSQL Flexible Server, and Power BI.

### Scalable web and mobile applications using Azure Database for PostgreSQL Flexible Server

- [Scalable web and mobile applications using Azure Database for PostgreSQL Flexible Server:](https://learn.microsoft.com/azure/architecture/solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-PostgreSQL) This generic architecture utilizes the scaling capabilities (vertical and horizontal) of Azure App Service and PostgreSQL Flexible Server.

### Multitenancy and Azure Database for PostgreSQL

- [Multitenancy and Azure Database for PostgreSQL:](https://learn.microsoft.com/azure/architecture/guide/multitenant/service/postgresql) This architecture demonstrates how to build a multi-tenant application using Azure Database for PostgreSQL leveraging row-level security (RLS), connection pooling, and horizontal scaling with sharding for performance.
  