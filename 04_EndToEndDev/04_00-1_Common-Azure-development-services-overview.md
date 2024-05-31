## Common Azure development services overview

This section explains common cloud application architectures and Azure services. While these services are not directly related to PostgreSQL, they are often used in modern Azure applications. This content provides a fundamental understanding of the common Azure development resources. Subsequent material will reference these Azure services heavily.

### Web Apps

Developers can deploy PostgreSQL-backed apps to Azure on a Windows or Linux environment through [Azure App Service,](https://learn.microsoft.com/azure/app-service/overview) a PaaS platform that supports popular frameworks, including .NET, PHP, Java, Python, Docker containers, and more. App Service is compatible with manual deployment mechanisms, including ZIP files, FTP, and local Git repositories. It also supports automated mechanisms, like GitHub Actions, to deploy faster and minimize issues. Coupled with powerful management tools, like the Kudu console, App Service is suitable for many enterprise apps.

#### Resources

- [App Service Overview](https://learn.microsoft.com/azure/app-service/overview)
- [Deploy a Python (Django or Flask) web app with PostgreSQL in Azure](https://learn.microsoft.com/azure/app-service/tutorial-python-postgresql-app?tabs=flask%2Cwindows&pivots=azure-portal)
- [Tutorial: Deploy Django app with App Service and Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/tutorial-django-app-service-postgres?tabs=clone)
- [Deploying to App Services](https://github.com/azure/azure-postgresql/blob/master/DeveloperGuide/step-1-sample-apps/README.md)
  
### Serverless Compute

[Azure Functions](https://learn.microsoft.com/azure/azure-functions/functions-overview) and [Azure Logic Apps](https://learn.microsoft.com/azure/logic-apps/logic-apps-overview) are serverless platforms, meaning that customers are billed only for the execution time of their code. Azure automatically scales compute resources up and down in response to demand.

### Azure Functions

An Azure Functions instance consists of individual functions that execute in response to a *trigger*, like a cron job or an HTTP request. These functions interface with other Azure resources, like Cosmos DB, through bindings, though resources without default bindings, like Azure Database for PostgreSQL Flexible Server, can be accessed through language-specific connectors.

Like Azure App Service, Function Apps support multiple programming languages. Developers can extend support to unsupported languages through [custom handlers.](https://learn.microsoft.com/azure/azure-functions/functions-custom-handlers)

For long-running, stateful serverless architectures, such as when human intervention is necessary, Azure provides the Durable Functions extension. Consult the [documentation](https://learn.microsoft.com/azure/azure-functions/durable/durable-functions-overview?tabs=csharp) for more information about architectures with Durable Functions.

#### Azure Functions Resources

- [Introduction to Azure Functions](https://learn.microsoft.com/azure/azure-functions/functions-overview)
- [Azure Functions hosting options](https://learn.microsoft.com/azure/azure-functions/functions-scale)
- Azure Functions with PostgreSQL Flexible Server samples:
  - .NET: [Azure Function with PostgreSQL (.NET)](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/06-01-FunctionApp-DotNet)
  - Python: [Azure Function with PostgreSQL (Python)](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/06-02-FunctionApp-Python)

### Azure Logic Apps

Azure Logic Apps provide integration services for enterprises, connecting applications that reside on-premises and in the cloud. Azure Logic Apps *workflows* execute *actions* after a *trigger* is fired.

Azure Logic Apps interface with external systems through *managed connectors*. Microsoft provides a managed connector for PostgreSQL databases, but this connector cannot easily be used for Azure Database for PostgreSQL Flexible Server, as the PostgreSQL managed connector accesses local PostgreSQL databases through a data gateway.

#### Azure Logic Apps Resources

- [What is an Azure Logic App?](https://learn.microsoft.com/azure/logic-apps/logic-apps-overview)
- [Compare Azure Functions and Azure Logic Apps](https://learn.microsoft.com/azure/azure-functions/functions-compare-logic-apps-ms-flow-webjobs#compare-azure-functions-and-azure-logic-apps)
- [Logic Apps with PostgreSQL](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/06-05-LogicApp)

### Microservices

Organizations deploy microservices architectures to offer resilient, scalable, developer-friendly applications. Unlike traditional monolithic apps, each service operates independently and can be updated without redeploying the app. Each service also manages its persistence layer, meaning that service teams can perform database schema updates without affecting other services.

While microservices apps offer major benefits, they require advanced tools and knowledge of distributed systems. Organizations utilize domain analysis to define optimal boundaries between services.

On Azure, organizations often deploy microservices to Azure Kubernetes Service through CI/CD platforms, such as GitHub Actions.

### Microservices Resources

- [Build microservices on Azure](https://learn.microsoft.com/azure/architecture/microservices/)
- [Using domain analysis to model microservices](https://learn.microsoft.com/azure/architecture/microservices/model/domain-analysis)
- [Deploying a Laravel app backed by a Java REST API to AKS](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-1-sample-apps/sample-php-app-rest)

### API Management

Azure API Management allows organizations to manage and securely expose their APIs hosted in diverse environments from a central service. API Management simplifies legacy API modernization, API exposure to multiple platforms, and data interchange between businesses. Applications call APIs through an *API gateway* that validates credentials, enforces quotas, serializes requests in different protocols, and more. Developers operate their API Management instances through the management plane, and they expose API documentation for internal and external users through the Developer portal.

Like other Azure resources, API Management offers comprehensive RBAC support, accommodating internal administrative and development staff and external users. Moreover, as API Management integrates with APIs hosted in environments outside Azure, organizations can self-host the API gateway while retaining the Azure management plane APIs.

#### API Management Resources

- [About API Management](https://learn.microsoft.com/azure/api-management/api-management-key-concepts)
- [Self-hosted gateway overview](https://learn.microsoft.com/azure/api-management/self-hosted-gateway-overview)

### Event-driven - Azure Event Grid vs. Service Bus vs. Event Hubs

Event-driven apps create, ingest, and process events (state changes) in real time. Event producers and event consumers are loosely coupled, and every consumer sees every event. Event-driven architectures can perform complex event handling, such as aggregations over time, and operate with large volumes of data produced rapidly.

Azure provides different services for relaying *messages* and *events*. When one system sends a message to another, it expects the receiving system to handle the message in a particular way and respond. However, with events, the publisher does not care how the event is handled.

#### Azure Event Grid

Azure Event Grid is a serverless publish-subscribe system that integrates well with Azure and non-Azure services. As an event-based system, it simply relays state changes to subscribers; it does not contain the actual data that changed.

#### Azure Service Bus

Azure Service Bus provides a *queue* capability to pass each message to one consumer (first-in-first-out queue). Moreover, Service Bus includes pub-sub functionality, allowing more than one consumer to receive a message.

#### Azure Event Hubs

Azure Event Hubs facilitates the ingestion and replay of event data. It is optimized for processing millions of events per second. Event Hubs support multiple consumers through *consumer groups*, which point to certain locations in the stream.

#### Putting it all together

Using the above technologies, it is possible to create an e-commerce site that uses Service Bus to process an order, Event Hubs to capture site telemetry, and Event Grid to respond to events like an item shipped.

### Cron jobs

Developers use cron jobs to run operations on a schedule. They are often useful for administrative tasks, like taking site backups. Azure Functions and Logic Apps support cron jobs:

- [Azure Functions:](https://learn.microsoft.com/azure/azure-functions/functions-bindings-timer) The timer trigger executes a function on a schedule. Azure Functions supports more complex scheduling tasks, like specifying the cron job time precision.
- [Logic Apps:](https://learn.microsoft.com/azure/logic-apps/concepts-schedule-automated-recurring-tasks-workflows) Logic Apps supports Recurrence triggers and Sliding Window triggers. Recurrence triggers run Logic Apps on a schedule, while Sliding Window triggers extend Recurrence triggers by executing occurrences that were missed (e.g., the Logic App is disabled).

### WebJobs

Azure WebJobs, like Azure Functions, processes events in Azure services. WebJobs executes code in an App Service instance, and it works best with the WebJobs SDK. However, WebJobs with the WebJobs SDK only supports C#.

Azure Functions is built on the WebJobs SDK. It offers more developer flexibility than WebJobs and serverless execution. However, WebJobs provides more control over how events are received than what Azure Functions exposes.

### Azure Data Factory

Azure Data Factory supports serverless data integration at scale. Users author data integration *pipelines* that consist of multiple *activities*. Activities operate on *datasets* (data sources and sinks). Data Factory compute environments are known as *integration runtimes*. Integration runtimes can be hosted in Azure or on-premises.

Azure Data Factory supports both Azure PaaS and generic (on-premises) PostgreSQL instances.

Developers can execute Data Factory pipelines manually, on a schedule, or in response to Azure events through the Event Grid integration.

![Read more icon](media/read-more.png "Read more") [Copy activity performance and scalability guide](https://learn.microsoft.com/azure/data-factory/copy-activity-performance)
