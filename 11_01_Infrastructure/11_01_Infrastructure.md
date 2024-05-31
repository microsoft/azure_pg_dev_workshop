## Infrastructure Concepts

### Monitoring

Once the application and database are deployed, the next phase is to manage the new cloud-based data workload and supporting resources. Microsoft proactively performs the necessary monitoring and actions to ensure the databases are highly available and performed at the expected level.

Flexible server is equipped with built-in performance monitoring and alerting features. All Azure metrics have a one-minute frequency, each providing 30 days of history. Alerts can be configured on metrics. The service exposes host server metrics to monitor resource utilization and allows configuring slow query logs. Using these tools, it is possible to quickly optimize workloads and configure the server for the best performance.

Azure can monitor all of these types of operational activities using tools such as [Azure Monitor](https://learn.microsoft.com/azure/azure-monitor/overview), [Log Analytics](https://learn.microsoft.com/azure/azure-monitor/platform/design-logs-deployment), and [Azure Sentinel](https://learn.microsoft.com/azure/sentinel/overview). In addition to the Azure-based tools, external security information and event management (SIEM) systems can be configured to consume these logs as well.

Administrators should [plan their monitoring strategy](https://learn.microsoft.com/azure/azure-monitor/best-practices-plan) and resource configuration for the best results. Some data collection and features are free, while others have associated costs. Focus on maximizing the applications' performance and reliability. Identify the data and logs that indicate the highest potential signs of failure to optimize costs. See [Azure Monitor Pricing](https://azure.microsoft.com/pricing/details/monitor/) for more information on planning monitoring costs.

### Application Insights cost management

Application Insights comes with a free allowance that tends to be relatively large enough to cover the development and publishing of an app for a small number of users. As a best practice, setting a limit can prevent more data than necessary from being processed and keep costs low.

Larger volumes of telemetry are charged by the gigabyte and should be monitored closely to ensure the finance department does not get a larger-than-expected Azure invoice. [Manage usage and costs for Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/pricing)

## Monitoring database operations

Azure can be configured to monitor Azure Database for PostgreSQL Flexible Server instances and databases. This includes items such as metrics and logs.

### Azure Database for PostgreSQL Flexible Server Overview

The Azure Portal resource overview excellent overview of the PostgreSQL metrics. This high-level dashboard provides insight into the typical database monitoring counters, like CPU, IO, Query Count, etc.

![This image shows PostgreSQL metrics in the Azure portal.](media/azure-portal-PostgreSQL-overview.png "PostgreSQL metrics in the Azure portal")

### Metrics

For more specific metrics, navigate to the **Monitoring** section. Select **Metrics**. More custom granular metrics can be configured and displayed.

![This image shows Metrics on the Monitoring tab in the Azure portal.](media/PostgreSQL-azure-portal-metrics.png "Monitoring tab in the Azure portal")

![Read more icon](media/read-more.png "Read more")  [Monitor Azure Database for PostgreSQL Flexible Servers with built-in metrics](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-monitoring)

### Diagnostic settings

Diagnostic settings allow for the re-route of platform logs and metrics continuously to other storage and ingestion endpoints.

![This image shows how to graph metrics in the Azure portal Monitoring tab.](media/PostgreSQL-diagnostic-settings.png "Graphing metrics in the Azure portal")

![Read more icon](media/read-more.png "Read more")  [Set up diagnostics](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-audit)

### Log Analytics

Once Diagnostic Settings are configured, it is possible to navigate to the Log Analytics workspace and perform specific filtered queries on interesting categories. Looking for slow queries?  Using KQL it is possible to find them.

![This image shows a KQL query.](media/azure-diagnostic-query.png "Sample KQL query")

Now, review the results from the query. There is a wealth of information about the category.

![This image shows KQL query results.](media/azure-diagnostic-query-result.png "Sample KQL query results")

PostgreSQL audit log information is also available.

![This image shows a KQL query that polls the PostgreSQL audit log.](media/PostgreSQL-log-analytics-audit-log-query.png "KQL query for the PostgreSQL audit log")

![Read more icon](media/read-more.png "Read more")  [View query insights by using Log Analytics](https://learn.microsoft.com/azure/postgresql/flexible-server/flexible-server/tutorial-query-performance-insights#view-query-insights-by-using-log-analytics)

### Workbooks

As mentioned previously, a Workbook is a simple canvas to visualize data from various sources, like Log Analytics workspace. It is possible to view performance and storage metrics all in a single pane.

![This image shows Azure Monitor Workbooks visualizations.](media/workbook-example.png "Visualizations in Azure Monitor Workbooks")

CPU, IOPS, and other common monitoring metrics are available. It is also possible to access Query Performance Insight.

![This image shows QPI in the Azure portal.](media/query-performance-insight.png "Azure portal QPI configuration")

In addition to the fundamental server monitoring aspects, Azure provides tools to monitor application query performance. Correcting or improving queries can lead to significant increases in the query throughput. Use the [Query Performance Insight tool](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-query-performance-insight) to:

- Analyze the longest-running queries and determine if it is possible to cache those items.
- If they are deterministic within a set period, modify the queries to increase their performance.

In addition to the query performance insight tool, `Wait statistics` provides a view of the wait events that occur during the execution of a specific query.

>![Warning](media/warning.png "Warning") **Warning**: Wait statistics are meant for troubleshooting query performance issues. It is recommended to be turned on only for troubleshooting purposes.

Finally, the `slow_query_log` can be set to show slow queries in the PostgreSQL log files (default is OFF). The `long_query_time` server parameter can be used to log long-running queries (default long query time is 10 sec).

![Read more icon](media/read-more.png "Read more")  [Monitor Azure Database for PostgreSQL Flexible Server by using Azure Monitor workbooks](https://learn.microsoft.com/azure/mysql/flexible-server/concepts-workbooks)

### Resource health

It is essential to know if the PostgreSQL service has experienced downtime and the related details. Resource health can assist with this information. If additional assistance is needed, a contact support link is available.

![This image shows Azure Resource Health.](media/resource-health-example.png "Azure Resource Health")

### Activity logs

This area captures the administrative events captured over some time.

![This image shows administrative events in the Azure Activity Log.](media/activity-logs-example.png "Administrative events")

The event details can be viewed as well. These details can be extremely helpful when troubleshooting.

![This image shows the details of an Activity Log event.](media/activity-log-example-detail.png "Activity Log event details")

### Creating alerts

It is possible to create alerts in a couple of ways. Navigate to the **Alerts** menu item in the portal and create it manually.

![This image shows how to create resource alerts in the Azure portal.](media/create-alert.png "Creating resource alerts")

Alerts can be created from the Metrics section.

![This image shows how to create resource alerts from the Metrics section in the Azure portal.](media/configure-alert-example.png "Creating resource alerts from the Metrics section")

Once the alert has been configured, create an action group to send a notification to the operations team.

![Read more icon](media/read-more.png "Read more")  [Set up alerts on metrics for Azure Database for PostgreSQL Flexible Server-Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/howto-alert-on-metrics)

### Server Logs

By default, the server logs feature in Azure Database for PostgreSQL - Flexible Server is disabled. However, after the feature is enabled, a flexible server starts capturing events of the selected log type and writes them to a file. Azure portal or the Azure CLI can be used to download the files to assist with troubleshooting efforts.

For more information on how to enable and download the server logs, reference [Enable, list and download server logs for Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-server-logs-portal).

### Server Resource Logs

Server logs from Azure Database for PostgreSQL Flexible Server can also be extracted through the Azure platform *resource logs*, which track data plane events. Azure can route these logs to Log Analytics workspaces for manipulation and visualization through KQL.

In addition to Log Analytics, the data can also be routed to Event Hubs for third-party integrations and Azure storage for long-term backup.

For more information on basic PostgreSQL logs, reference [Logs in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-logging).

### PostgreSQL audit logs (pgAudit)

In addition to metrics, it is also possible to enable PostgreSQL logs to be ingested into Azure Monitor. While metrics are better suited for real-time decision-making, logs are also useful for deriving insights. One source of logs generated by Flexible Server is PostgreSQL audit logs, which indicate connections, DDL and DML operations, and more. Many businesses utilize audit logs to meet compliance requirements, but enabling audit logs can impact performance.

PostgreSQL has a robust built-in audit log feature available through the `pgaudit` extension. This [audit log feature is [disabled](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-audit) in the Azure Database for PostgreSQL Flexible Server by default. Server-level logging can be enabled by adding the `pgaudit` server extension and then modifying various server parameters. For information on configuring these parameters, reference [Audit logging in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-audit).

![Shared preload libraries](media/shared-preload-libraries.png)

![PGAUDIT configuration](media/pgaudit-config.png)

Once enabled, logs can be accessed through [Azure Monitor](https://learn.microsoft.com/azure/azure-monitor/overview) and [Log Analytics](https://learn.microsoft.com/azure/azure-monitor/platform/design-logs-deployment). The following KQL query can be used to access `AUDIT:` based logs:

```kql
AzureDiagnostics
| where Resource =~ "myservername"
| where Category == "PostgreSQLLogs"
| where TimeGenerated > ago(1d)
| where Message contains "AUDIT:"
```

Custom error messages can be sent from workloads using the `RAISE WARNING` command.

```psql
CREATE OR REPLACE PROCEDURE my_proc(schema_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE WARNING 'my_proc executed for schema %', schema_name;
  -- add the procedure logic here
END;
$$;

CALL my_proc('my_schema');
```

Find the data by using the following KQL query:

```kql
AzureDiagnostics
| where Category == "PostgreSQLLogs"
| where Message contains "my_proc executed for schema" 
```

It is also possible to change the prefix of the log by changing the `log_line_prefix` server parameter. For example, get the user name in the log line prefix by adding `%u` to log_line_prefix. For example:

```text
'%m [%p] %q%u@%d (%h) '
```

>![Warning](media/warning.png "Warning") **Warning**: Excessive audit logging can degrade server performance, so be mindful of the events and users configured for logging.

### Azure Advisor

The Azure Advisor system uses telemetry to issue performance and reliability recommendations for the PostgreSQL database. Azure Database for PostgreSQL Flexible Server prioritizes the following types of recommendations:

- **Performance**: To improve the speed of the PostgreSQL server. This includes CPU usage, memory pressure, connection pooling, disk utilization, and product-specific server parameters. For more information, see Advisor Performance recommendations.
- **Reliability**: To ensure and improve the continuity of the business-critical databases. This includes storage limits and connection limits. For more information, see Advisor Reliability recommendations.
- **Cost**: To optimize and reduce the overall Azure spending. This includes server right-sizing recommendations. For more information, see Advisor Cost recommendations.

For the latest information reference [Azure Advisor for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-azure-advisor-recommendations).

### Azure Database for PostgreSQL Flexible Server Release Notes

Typically each month a new set of release notes is published for Flexible Server. Read more about these by reviewing the [Release notes - Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/release-notes) document.

## Networking

The Azure Database for PostgreSQL Flexible Server network configuration can adversely affect security, application performance (latency), and compliance. This section explains the fundamentals of Azure Database for PostgreSQL Flexible Server networking concepts.

Azure Database for PostgreSQL Flexible Server provides several mechanisms to secure the networking layers by limiting access to only authorized users, applications, and devices.

### Public vs. Private Access

As with any cloud-based resources, it can be exposed to the Internet or be locked down to only be accessible by Azure connections resources. However, it does not have to be just Azure-based resources. VPNs and Express route circuits can be used to provide access to Azure resources from on-premises environments. The following section describes how to configure Azure Database for PostgreSQL Flexible Server instances for network connectivity.

#### Public Access

By default, Azure Database for PostgreSQL Flexible Server allows access to internet-based clients, including other Azure services. If this is an undesirable state, firewall access control lists (ACLs) can limit access to hosts that fall within the allowed trusted IP address ranges.

The first line of defense for protecting a PostgreSQL instance access is to implement [firewall rules](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-firewall-rules). IP addresses can be limited to only valid locations when accessing the instance via internal or external IPs. If a PostgreSQL instance's purpose is to serve internal applications, then [restrict public access](https://learn.microsoft.com/azure/postgresql/flexible-server/howto-deny-public-network-access).

![Firewall rule diagram](media/firewall-rule-diagram.png)

Firewall rules are set at the server level, meaning that they govern network access to all databases on the server instance. While it is best practice to create rules that allow specific IP addresses or ranges to access the instance, developers can also enable network access from all Azure resources. This feature is useful for Azure services without fixed public IP addresses, such as [Azure Functions](https://learn.microsoft.com/azure/azure-functions/functions-overview) that use public networks to access the server and databases.

>![Note icon](media/note.png "Note") **Note:** Restricting access to Azure public IP addresses still provides network access to the instance to public IPs owned by other Azure customers.

- Flexible Server
  - [Manage firewall rules for Azure Database for PostgreSQL Flexible Server - Flexible Server using the Azure portal](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-manage-firewall-portal)
  - [Manage firewall rules for Azure Database for PostgreSQL Flexible Server - Flexible Server using Azure CLI](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-manage-firewall-cli)
  - [ARM Reference for Firewall Rules](https://learn.microsoft.com/azure/templates/microsoft.dbforPostgreSQL/flexibleservers/firewallrules?tabs=json)

#### Private Access

As mentioned, Azure Database for PostgreSQL Flexible Server supports public connectivity by default. However, most organizations will utilize private connectivity to limit access to Azure virtual networks and resources.

> **Note:** There are many other [basic Azure Networking considerations](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-networking-private) that must be taken into account that are not the focus of this guide.

## Virtual Network Hierarchy

An Azure virtual network is similar to an on-premises network. It provides network isolation for workloads. Each virtual network has a private IP allocation block. Choosing an allocation block is an important consideration, especially if the environment requires multiple virtual networks to be joined.

>![Warning](media/warning.png "warning") **Warning:**  The allocation blocks of the virtual networks cannot overlap. It is best practice to choose allocation blocks from [RFC 1918.](https://datatracker.ietf.org/doc/html/rfc1918)

> **Note**: When deploying a resource such as a VM into a virtual network, the virtual network must be located in the same region and Azure subscription as the Azure resource. Review the [Introduction to Azure](../02_IntroToPostgreSQL/02_02_Introduction_to_Azure.md) document for more information about regions and subscriptions.

Each virtual network is further segmented into subnets. Subnets improve virtual network organization and security, just as they do on-premises.

When moving an application to Azure along with the PostgreSQL workload, there will likely be multiple virtual networks set up in a hub and spoke pattern that will require [Virtual Network Peering](https://learn.microsoft.com/azure/virtual-network/virtual-network-peering-overview) to be configured. Virtual networks are joined through *peering*. The peered virtual networks can reside in the same or different Azure regions.

Lastly, it is possible to access resources in a virtual network from on-premises. Some organizations opt to use VPN connections through [Azure VPN Gateway](https://learn.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways), which sends encrypted traffic over the Internet. Others opt for [Azure ExpressRoute](https://learn.microsoft.com/azure/expressroute/expressroute-introduction), which establishes a private connection to Azure through a service provider.

For more information on Virtual Networks, reference the following:

- [Introduction to Azure Virtual Networks](https://learn.microsoft.com/learn/modules/introduction-to-azure-virtual-networks/)
- Creating virtual networks
  - [Portal](https://learn.microsoft.com/azure/virtual-network/quick-create-portal)
  - [PowerShell](https://learn.microsoft.com/azure/virtual-network/quick-create-powershell)
  - [CLI](https://learn.microsoft.com/azure/virtual-network/quick-create-cli)
  - [ARM Template](https://learn.microsoft.com/azure/virtual-network/quick-create-template)

### Flexible Server VNet Integration

Flexible Server supports deployment into a virtual network for secure access. When enabling virtual network integration, the target virtual network subnet must be *delegated*, meaning that it can only contain Flexible Server instances. Because Flexible Server is deployed in a subnet, it will receive a private IP address. To resolve the DNS names of Azure Database for PostgreSQL Flexible Server instances, the virtual networks are integrated with a private DNS zone to support domain name resolution for the Flexible Server instances.

>![Note icon](media/note.png "Note") **Note:** If the Flexible Server client, such as a VM, is located in a peered virtual network, then the private DNS zone created for the Flexible Server must also be integrated with the peered virtual network.

>![Note icon](media/note.png "Note") **Note:** Private DNS zone names must end with PostgreSQL.database.azure.com. When connecting to the Azure Database for PostgreSQL Flexible Server - Flexible sever with SSL and are using an option to perform full verification (sslmode=VERIFY_IDENTITY) with certificate subject name, use <servername>.postgres.database.azure.com in the connection string.

![Read more icon](media/read-more.png "Read more")  [Private DNS zone overview](https://learn.microsoft.com/azure/dns/private-dns-overview)

For more information on configuring Private Access for Flexible Server, reference the following:

- [Azure Portal](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-manage-virtual-network-private-endpoint-portal)
- [Azure CLI](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-manage-virtual-network-cli)

Flexible server also has a [builtin PgBouncer](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-pgbouncer) connection pooler. Once enabled, connect applications to the database server via PgBouncer using the same hostname with port 6432.Networking Best Practices for Flexible Server

- If deploying an application in an Azure region that supports *Availability Zones*, deploy the application and the Flexible Server instance in the same zone to minimize latency.

> For a review of availability zones, consult the [Introduction to Azure Database for PostgreSQL Flexible Server] document.

- Organize the components of the application into multiple virtual networks, such as in a [hub and spoke configuration.](https://learn.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli) Employ virtual network peering or VPN Gateways to join the application's virtual networks.

- Configure data protection at rest and in motion (see the [Security and Compliance document](03_PostgreSQL_Security_Compliance.md)).

- [General Azure Networking Best Practices](https://learn.microsoft.com/azure/cloud-adoption-framework/migrate/azure-best-practices/migrate-best-practices-networking)
  - Determine IP addressing and subnetting.
  - Determine DNS setup and whether forwarders are needed.
  - Employ tools like network security groups to secure traffic within and between subnets.

## Security

Moving to cloud-based services does not mean the entire Internet will have access to it at all times. Azure provides best-in-class security that ensures data workloads are continually protected from bad actors and rogue programs. Additionally, Azure provides several certifications that ensure the resources are compliant with local and industry regulations, a crucial factor for many organizations today.

Organizations must take proactive security measures to protect their workloads in today's geopolitical environment. Azure simplifies many of these complex tasks and requirements through the various security and compliance resources provided out of the box. This section will focus on many of these tools.

### Encryption

Azure Database for PostgreSQL Flexible Server offers various encryption features, including encryption for data, backups, and temporary files created during query execution.

Data stored in the Azure Database for PostgreSQL Flexible Server instances are encrypted at rest by default. Any automated backups are also encrypted to prevent potential leakage of data to unauthorized parties. This encryption is typically performed with a key generated when the Azure Database for PostgreSQL Flexible Server instance is created.

Encryption of these artifacts is done using a Microsoft-managed key by default, however it is possible to use customer-managed keys. This can be accomplished by using Azure Key Vault and managed identities. The key must be continuously accessible or the server will go into an `inaccessible` state.

Reference [Azure Database for PostgreSQL - Flexible Server Data Encryption with a Customer-managed Key](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-data-encryption) for the latest information and [Create and manage Azure Database for PostgreSQL - Flexible Server with data encrypted by Customer Managed Keys (CMK) using Azure portal](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-create-server-customer-managed-key-portal).

In addition to be encrypted at rest, data can be encrypted during transit using SSL/TLS. SSL/TLS is enabled by default. As previously discussed, it may be necessary to [modify the applications](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-connect-tls-ssl) to support this change and configure the appropriate TLS validation settings. It is possible to allow insecure connections for legacy applications or enforce a minimum TLS version for connections, **but this should be used sparingly and in highly network-protected environments**. Flexible Server's TLS enforcement status can be set through the `require_secure_transport` PostgreSQL server parameter. Consult the guides below.

- [Encrypted connectivity using Transport Layer Security in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-connect-tls-ssl)

### Microsoft Sentinel

Many of the items discussed thus far operate in their sphere of influence and are not designed to work directly with each other. Every secure feature provided by Microsoft Azure and corresponding applications, like Microsoft Entra, contains a piece of the security puzzle.

Disparate components require a holistic solution to provide a complete picture of the security posture and the automated event remediation options.

[Microsoft Sentinel](https://learn.microsoft.com/azure/sentinel/overview) is the security tool that provides the needed connectors to bring all security log data into one place and then provide a view into how an attack may have started.

Microsoft Sentinel works with Azure Log Analytics and other Microsoft security services to provide a log storage, query, and alerting solution. Through machine learning, artificial intelligence, and user behavior analytics (UEBA), Microsoft Sentinel provides a higher understanding of potential issues or incidents that may not have seen in a disconnected environment.

### Microsoft Purview

Data privacy has evolved into an organizational priority over the past few years. Determining where sensitive information lives across the data estate is a requirement in today's privacy-centered society.

[Microsoft Purview](https://learn.microsoft.com/azure/purview/overview) can scan the data estate, including Azure Database for PostgreSQL Flexible Server instances, to find personally identifiable information or other sensitive information types. This data can then be analyzed, classified and lineage defined across cloud-based resources.

### Security baselines

In addition to all the topics discussed above, the Azure Database for PostgreSQL Flexible Server [security baseline](https://learn.microsoft.com/security/benchmark/azure/baselines/azure-database-for-postgresql-flexible-server-security-baseline) is a basic set of potential tasks that can be implemented on the Azure Database for PostgreSQL Flexible Server instances to further solidify the security posture.

### Compliance

To help customers achieve compliance with national/regional and industry-specific regulations and requirements Azure Database for PostgreSQL - Flexible Server built upon Microsoft Azure's compliance offerings to provide the most rigorous compliance certifications to customers at service general availability. To help customers meet their compliance obligations across regulated industries and markets worldwide, Azure maintains the largest compliance portfolio in the industry both in terms of breadth (total number of offerings), as well as depth (number of customer-facing services in assessment scope). Azure compliance offerings are grouped into four segments: globally applicable, US government, industry-specific, and region/country specific. Compliance offerings are based on several types of assurances, including formal certifications, attestations, validations, authorizations, and assessments produced by independent third-party auditing firms, as well as contractual amendments, self-assessments and customer guidance documents produced by Microsoft. More detailed information about Azure compliance offerings is available from the [Trust Center](https://www.microsoft.com/trust-center/compliance/compliance-overview).

For a list of compliance certifications, reference [Security and Compliance Certifications in Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-compliance).

Protecting the data and control plane is just another piece to the puzzle of having a robust, secure and performant application environment.

Deciding what risks the organization can accept will typically help guide what security features discussed in this section should be enabled and paid for.

If the data is vital, important and business-critical, everything possible should be done to ensure it's protected and secure.

This section discussed many tools Microsoft Azure provides to give an organization peace of mind that the cloud-based workload will be just as secure as if running it on-premises.

## Security checklist

- Utilize the most robust possible authentication mechanisms such as Microsoft Entra.
- Enable Advanced Threat Protection and Microsoft Defender for Cloud.
- Enable all auditing features.
- Enable encryption at every layer that supports it.
- Consider a Bring-Your-Own-Key (BYOK) strategy, where supported.
- Implement firewall rules.
- Utilize private endpoints for workloads that do not travel over the Internet.
- Integrate Microsoft Sentinel for advanced SIEM and SOAR.
- Utilize private endpoints and virtual network integration where possible.

## Testing

Testing is a crucial part of the application development lifecycle. Architects, developers, and administrators should continually assess and evaluate their applications for *availability* (minimal downtime) and *resiliency* (recovery from failure). Microsoft recommends performing tests regularly and highly suggests automating them to minimize any errors in the process or setup. Tests can be run in the application build or deployment process.

This chapter discusses the several types of tests that can be run against Azure Database for PostgreSQL Flexible Server application and database. Running tests ensures the optimal performance of application and database deployments.

### Functional testing

Functional testing ensures that an app functions as documented in the user and business requirements. Testers do not know how software systems function; they ensure systems perform the business functions specified in the documentation. Functional tests validate things like data limits (field lengths and validation) and that specific actions are taken in response to various triggers. The tests usually involve some type of application user interface. It is usually the most complete type of testing for UI applications.

#### Function testing tools

[Selenium](https://www.selenium.dev/) automates functional tests for web apps. Developers can create web application test scripts in several supported languages, like Ruby, Java, Python, and C#. Once scripts are developed, the Selenium WebDriver executes the scripts using browser-specific APIs. Teams can operate parallel Selenium tests on different devices using [Selenium Grid](https://www.selenium.dev/documentation/grid/).

To get started with Selenium, developers can install the [Selenium IDE](https://www.selenium.dev/selenium-ide/) to generate testing scripts from browser interactions. The Selenium IDE is not intended for production tests. Still, it can speed up the development of test script creation tasks.

Teams can include [Selenium tests in Azure DevOps](https://techcommunity.microsoft.com/t5/testingspot-blog/continuous-testing-with-selenium-and-azure-devops/ba-p/3143366). The screenshot below demonstrates a Selenium test running in a DevOps Pipeline.

![This image demonstrates screenshots from a Selenium test in Azure DevOps.](./media/selenium-test-azure-devops.png "Selenium test screenshots")

### Resiliency and version testing

Testers can only execute so many test cases within a set period. Users tend to test application functionality not imagined by the development or test teams. Allowing real users to test the application while limiting deployment downtime and version risk can be difficult. One strategy to test for resiliency is the `blue-green` method. The latest version of an application operates in a second production environment. Developers test the most recent version in the second production environment by adding some production users to the new version. If the new version functions adequately, the second environment begins handling more production user requests. Developers can roll back the application by serving requests from the older environment if an unexpected error occurs.

![This image shows how to implement a Blue/Green test using Azure Traffic Manager.](media/azure-traffic-manager-blue-green.png "Azure Traffic Manager Blue/Green test")

> ![Tip](media/tip.png "Tip") **Tip**: Newer versions of an application often require database updates. It is recommended to update the database to support the new and previous versions of the software before deploying application updates to the second environment.

Azure has the capability to support this type of testing via Deployment Center, Azure Traffic Manager, and other tools.

The following links provide resources on Blue-green deployment options:

- [Deployment Center example](https://learn.microsoft.com/azure/app-service/deploy-github-actions?tabs=applevel)
- [Azure Traffic Manager example](https://azure.microsoft.com/blog/blue-green-deployments-using-azure-traffic-manager/)
- [Application Gateway example](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/upgrading-aks-version-with-blue-green-deployment-i/ba-p/2527145)

### Performance testing

#### Load testing

Load testing determines an application's performance as load increases. Load testing tools typically simulate users or requests, and they help companies meet their user and business SLAs. Proper load testing requires knowledge of the load a production system normally experiences and potential Azure service limits (e.g. [Event Hub throughput by tier](https://learn.microsoft.com/azure/event-hubs/event-hubs-quotas#basic-vs-standard-vs-premium-vs-dedicated-tiers)).

#### Stress testing

Stress testing determines the maximum load a system can handle before failure. A proper stress testing approach would be to perform stress testing at different Azure service tiers and determine appropriate thresholds when scaling within those tiers. This will give administrators an idea of how to build alerts for monitoring if the application starts to approach these known limits. Knowing the acceptable low and high stress range levels is necessary to minimize costs (by selecting the appropriate tier and scaling) and thereby provide a positive user experience.

#### Performance testing tools

### Apache JMeter

[Apache JMeter](https://jmeter.apache.org/) is an open-source tool to test that a system functions and performs well under load. It can test web applications, REST APIs, databases, and more. JMeter provides a GUI and a CLI, and it can export test results in a variety of formats, including HTML and JSON.

The image below demonstrates one approach to operating JMeter at scale using Azure Container Instances. The `jmeter-load-test` pipeline manages the test infrastructure and provides the test definition to the **JMeter Controller**.

![This image demonstrates how to perform a load test at scale using CI/CD, JMeter, and ACI.](./media/load-testing-pipeline-jmeter.png "Load testing at scale")

It is also possible to run JMeter load tests using [Azure Load Testing Preview.](https://learn.microsoft.com/azure/load-testing/quickstart-create-and-run-load-test)

### K6

[Grafana K6](https://k6.io/) is a load-testing tool hosted locally or in the cloud. Developers script tests using ES6 JavaScript. Supporting over 20 integrations, including [Azure DevOps Pipelines](https://techcommunity.microsoft.com/t5/azure-devops/load-testing-with-azure-devops-and-k6/m-p/2489134), K6 is a popular choice for many teams.

## Testing data capture tools

### Azure Monitor

Azure Monitor allows developers to collect, analyze, and act on telemetry. *Application Insights*, a subset of Azure Monitor, tracks application performance, usage patterns, and issues. It integrates with common development tools, like Visual Studio. Similarly, *Container insights* measures the performance of container workloads running on Kubernetes clusters. These powerful tools are backed by Azure Log Analytics workspaces and the Azure Monitor metrics store.

The image below demonstrates container logs from a containerized deployment of the ContosoNoshNow sample app running in AKS. These logs are analyzed in the cluster's Log Analytics workspace.

![This image demonstrates container logs in the AKS cluster's Log Analytics workspace.](./media/container-logs-in-log-analytics.png "AKS cluster container logs")

The image below demonstrates the cluster's maximum CPU usage over a half-hour period. It utilizes metrics provided by AKS, though more granular metrics from Container insights can also be used.

![This image demonstrates the maximum CPU usage of the AKS cluster's nodes, a feature provided by metrics from AKS.](./media/metric-visualization.png "Maximum CPU usage graph")

#### Resources

- [Supported languages for Azure App Insights](https://learn.microsoft.com/azure/azure-monitor/app/platforms)
- Comparison of *metrics* and *logs* in Azure Monitor
  - [Azure Monitor Metrics overview](https://learn.microsoft.com/azure/azure-monitor/essentials/data-platform-metrics)
  - [Azure Monitor Logs overview](https://learn.microsoft.com/azure/azure-monitor/logs/data-platform-logs)
- [Monitoring Azure Kubernetes Service (AKS) with Azure Monitor](https://learn.microsoft.com/azure/aks/monitor-aks#scope-of-the-scenario)

### Grafana and Prometheus

Prometheus is a powerful tool for developers to capture metrics, store them in a time-series database on disk, and analyze them through a custom query language. However, due to the storage of metrics on disk, Prometheus is not ideal for long-term retention.

Grafana is a visualization tool to create customizable dashboards from time-series databases. These visualizations supplement the raw metrics exposed by services such as Prometheus.

The image below demonstrates two charts in Grafana demonstrating the CPU usage of a Laravel pod in the Contoso Nosh Now AKS deployment. The `requests` and `limits` values were supplied in the Kubernetes deployment file.

![This image demonstrates a dashboard in Grafana showing CPU usage for a pod.](./media/grafana-dashboard.png "Pod CPU usage in Grafana")

### Recommended content

The following resources are helpful for exploring various approaches to using the previously mentioned tools and concepts.

- [Using Azure Kubernetes Service with Grafana and Prometheus](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/using-azure-kubernetes-service-with-grafana-and-prometheus/ba-p/3020459)

- [Prometheus Overview](https://prometheus.io/docs/introduction/overview)

- [What is Grafana](https://grafana.com/docs/grafana/latest/fundamentals/)

- [Store Prometheus Metrics with Thanos, Azure Storage and Azure Kubernetes Service (AKS)](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/store-prometheus-metrics-with-thanos-azure-storage-and-azure/ba-p/3067849)

- [What are Azure Pipelines?](https://learn.microsoft.com/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops#:~:text=Azure%20Pipelines%20automatically%20builds%20and,ship%20it%20to%20any%20target)

- [What is Azure Load Testing?](https://learn.microsoft.com/azure/load-testing/overview-what-is-azure-load-testing?wt.mc_id=loadtesting_acompara4_webpage_cnl)

Testing applications after they have been deployed to an existing or a new environment is a vital step in the development cycle. It could prevent unwanted downtime or loss of application functionality.

### Checklist

- Perform functional testing on applications and databases.
- Perform performance testing on applications and databases.
- Utilize industry standard tools and benchmarks to ensure accurate and comparable results.
- Integrate reporting tools such as Azure Monitor, Grafana or Prometheus into testing suites.

## Performance

After organizations migrate their PostgreSQL workloads to Azure, they unlock turnkey performance monitoring solutions, scalability, and the benefits of Azure's global footprint. Operation teams must establish performance baselines before fine-tuning their PostgreSQL instances to ensure that changes, especially those that require application downtime, are worth doing. When possible, **simulate your workload in a test environment** and make adjustments in test before implementing changes in a production environment.

Before jumping into specific and time consuming performance enhancements/investigation, there are some general tips that can improve performance in the environment that this section will explore.

### General performance tips

The following are some basic tips for how to increase or ensure the performance of Azure Database for PostgreSQL Flexible Server applications and database workloads:

- Ensure the input/output operations per second (IOPS) are sufficient for the application needs. Keep the IO latency low.
- Create and tune the table indexes. Avoid full table scans.
- Performance of regular database maintenance.
- Make sure the application/clients (e.g. App Service) are physically located as close as possible to the database. Reduce network latency.
- Use accelerated networking for the application server when using an Azure virtual machine, Azure Kubernetes, or App Services.
- Use connection pooling when possible. Avoid creating new connections for each application request. Balance workloads with multiple read replicas as demand requires without any changes in application code.
- Set timeouts when creating transactions.
- Set up a read replica for read-only queries and analytics.
- Consider using query caching solution like Heimdall Data Proxy. Limit connections based on per user and per database. Protect the database from being overwhelmed by a single application or feature.
- Temporarily scale Azure Database for PostgreSQL Flexible Server resources for taxing tasks. Once the tasks are complete, scale it down.
After developers benchmark their PostgreSQL Flexible Server workloads, they can tune server parameters, scale compute tiers, and optimize their application containers to improve performance. Through Azure Monitor and KQL queries, teams monitor the performance of their workloads.

### Summary + Checklist

Caching is a common way to increase the performance of applications. Through disk or memory-based cache, a developer and architect should always be on the lookout for deterministic areas that can be cached. Azure CDN provides caching via POP servers to users of global-scale web apps.

Lastly, an important balance should be struck between the performance of the cache and costs.

#### Performance Checklist

- Monitor for slow queries.
- Periodically review the Performance Insight dashboard.
- Utilize monitoring to drive tier upgrades and scale decisions.
- Consider moving regions if the users' or application's needs change.
- Adjust server parameters for the running workload.
- Utilize caching techniques to increase performance.
- Get data closer to users by implementing content delivery networks.

## BCDR

Azure Database for PostgreSQL Flexible Server offers several BCDR options that meet or exceed any RPO or RTO objectives. These include:

- Automatic backups
- Zone redundant high availability
- Same zone high availability
- Premium managed disks
- Zone redundant backup
- Geo-redundant backups
- Geo-Replication (Read replicas)

Reference [Overview of business continuity with Azure Database for PostgreSQL - Flexible Server](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-business-continuity) for the latest information.

### Configure maintenance scheduling and alerting

- [Manage scheduled maintenance settings using the Azure Portal (Flexible Server)](https://learn.microsoft.com/azure/postgresql/flexible-server/how-to-maintenance-portal)
- [View service health notifications in the Azure Portal](https://learn.microsoft.com/azure/service-health/service-notifications)
- [Configure resource health alerts using Azure Portal](https://learn.microsoft.com/azure/service-health/resource-health-alert-monitor-guide)

### Platform as a Service

Since Azure Database for PostgreSQL Flexible Server is a PaaS offering, administrators are not responsible for the management of the updates on the operating system or the PostgreSQL software. Also, administrators need to plan for database version upgrades. Cloud providers are continuously upgrading and improving their supported offerings. Older versions eventually fall into the unsupported status.

![Warning](media/warning.png) **Warning:** It is important to be aware the upgrade process can be random. During deployment, the PostgreSQL server workloads will stop being processed on the server. Plan for these downtimes by rerouting the workloads to a read replica in the event the particular instance goes into maintenance mode.

>![Note icon](media/note.png "Note") **Note:** This style of failover architecture may require changes to the applications data layer to support this type of failover scenario. If the read replica is maintained as a read replica and is not promoted, the application will only be able to read data and it may fail when any operation attempts to write information to the database.

The [planned maintenance notification](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-monitoring#planned-maintenance-notification) feature will inform resource owners up to 72 hours in advance of the installation of an update or critical security patch. Database administrators may need to notify application users of planned and unplanned maintenance.

>![Note icon](media/note.png "Note") **Note:** Azure Database for PostgreSQL Flexible Server maintenance notifications are incredibly important. The database maintenance can take the database and connected applications down for a brief period of time.

### Version Policy

Each major version of PostgreSQL will be supported by Azure Database for PostgreSQL Flexible Server from the date on which Azure begins supporting the version until the version is retired by the PostgreSQL community.

Before PostgreSQL version 10, the PostgreSQL versioning policy considered a major version upgrade to be an increase in the first or second number. For example, 9.5 to 9.6 was considered a major version upgrade. As of version 10, only a change in the first number is considered a major version upgrade. For example, 10.0 to 10.1 is a minor release upgrade. Version 10 to 11 is a major version upgrade.

## Running retired versions

As the community won't be releasing any further bug fixes or security fixes, Azure Database for PostgreSQL Flexible Server won't patch the retired database engine for any bugs or security issues, or otherwise take security measures concerning the retired database engine. It is possible to experience security vulnerabilities or other issues as a result. However, Azure will continue to perform periodic maintenance and patching for the host, OS, containers, and any other service-related components.

In the extreme event of a serious threat to the service caused by the PostgreSQL database engine vulnerability identified in the retired database version, Azure might choose to stop the database server to secure the service. In such a case, a notification to upgrade the server before bringing the server online will be displayed.

For the latest information on the versioning policy, see [Azure Database for PostgreSQL versioning policy](https://learn.microsoft.com/azure/postgresql/single-server/concepts-version-policy)

### Summary + Checklist

A solid BCDR plan is critical for every organization. The operation team should leverage strategies covered in this chapter to ensure business continuity. Downtime events are not only disaster events but also include normal scheduled maintenance. This chapter pointed out that platform as a service instances such as Azure Database for PostgreSQL Flexible Server still have some downtime that must be taken into consideration. Older versions of PostgreSQL will trigger end-of-life (EOL) support. A plan should be developed to ensure that the possibility of upgrades will not take applications offline. Consider using read-only replicas that will maintain the application availability during these downtimes. To support these types of architectures, the applications may need to be able to gracefully support the failover to read-only nodes when users attempt to perform write-based activities.

#### Checklist

- Perform backups regularly, and ensure the backup frequency meets requirements.
- Set up read replicas for read-intensive workloads and regional failover.
- Use resource locks to prevent accidental deletions.
- Create resource locks on resource groups.
- Implement a load-balancing strategy for applications for quick failover.
- Be aware that service outages will occur and plan appropriately.
- Develop a scheduled maintenance plan and set up maintenance notifications.
- Develop a database version upgrade plan.
