## Java

This section describes tools to interact with Azure Database for PostgreSQL Flexible Server through [Java](https://learn.microsoft.com/azure/developer/java/?view=azure-java-stable).

### Getting started

Refer to the [Quickstart: Use Java and JDBC with Azure Database for PostgreSQL Flexible Server](https://learn.microsoft.com/azure/PostgreSQL/flexible-server/connect-java?tabs=passwordless) for detailed instructions on how to get started with Java and Azure Database for PostgreSQL Flexible Server. This example uses JDBC to connect to the database and perform basic data access operations.

### General information on Java and Azure

#### Eclipse

While all Java IDEs are supported for Azure development, [Eclipse](https://www.eclipse.org/downloads/) is a popular choice. It supports extensions for enterprise Java development, including powerful utilities for Spring applications. Moreover, through the [Azure Toolkit for Eclipse](https://learn.microsoft.com/azure/developer/java/toolkit-for-eclipse/installation), developers can quickly deploy their applications to an Azure App Service [directly from Eclipse](https://learn.microsoft.com/azure/developer/java/toolkit-for-eclipse/create-hello-world-web-app).

#### Maven

[Maven](https://maven.apache.org/guides/getting-started/index.html) improves the productivity of Java developers by managing builds, dependencies, releases, documentation, and more. Maven projects are created from archetypes. Microsoft provides the [Maven Plugins](https://learn.microsoft.com/training/modules/develop-azure-functions-app-with-maven-plugin/) for Azure to help Java developers work with Azure Functions, Azure App Service, and Azure Spring Cloud from their Maven workflows.

>![Note icon](media/note.png "Note") **Note:** Application patterns with Azure Functions, Azure App Service, and Azure Spring Cloud are addressed in the [04 / End to End application development] story.

#### Spring Data JPA

Developers use persistence frameworks like Spring Data JPA to accelerate development. They can focus on the application business logic, not basic database communication. [Spring Data JPA](https://www.baeldung.com/the-persistence-layer-with-spring-data-jpa) extends the Java Persistence API(JPA) specification, which governs *object-relational mapping* (ORM) technologies in Java.

Microsoft provides a [full tutorial](https://learn.microsoft.com/azure/developer/java/spring-framework/configure-spring-data-jpa-with-azure-postgresql?tabs=passwordless%2Cservice-connector&pivots=postgresql-passwordless-flexible-server) and [sample application](https://github.com/Azure-Samples/quickstart-spring-data-jpa-postgresql) using Spring Data JPA with Azure Database for PostgreSQL Flexible Server. The tutorial demonstrates how to create a Spring Boot application that connects to Azure Database for PostgreSQL Flexible Server and performs basic data access operations using Spring Data JPA. The tutorial also provides a link on how to [deploy the application to Azure App Service](https://learn.microsoft.com/azure/spring-apps/quickstart?tabs=Azure-portal%2CAzure-CLI%2CConsumption-workload&pivots=sc-enterprise).
