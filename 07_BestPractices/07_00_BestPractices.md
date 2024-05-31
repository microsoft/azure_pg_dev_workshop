# 07 / Best practices

## Best practices for PostgreSQL Flexible Server apps

Organizations developing cloud apps backed by Azure Database for PostgreSQL Flexible Server should consider implementing the following best practices. Note, that this list is not comprehensive.

Consult the [Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/) for more information regarding the core principles of efficient cloud workloads. Assess existing Azure workloads for Well-Architected Framework compliance with the [Azure Well-Architected Review utility.](https://learn.microsoft.com/assessments/?id=azure-architecture-review&mode=pre-assessment)

### 1. Co-locate resources

Locating Azure services in the same region minimizes network traffic costs and network latency. Flexible Server supports co-location in the same region and co-location in the same Availability Zone for [regions that support Availability Zones.](https://learn.microsoft.com/azure/availability-zones/az-region) Azure Database for PostgreSQL Flexible Server couples well with zonal services, like Virtual Machines.

### 2. Implement connection pooling

Developers can significantly improve application performance by reducing the number of times that connections are established and increasing the duration of those connections through connection pooling. Microsoft recommends the [pgBouncer connection pooling solution](https://techcommunity.microsoft.com/t5/azure-database-for-postgresql/steps-to-install-and-setup-pgbouncer-connection-pooling-on-azure/ba-p/3633043), hosted on application servers or container orchestrators, like Azure Kubernetes Service (AKS).

### 3. Monitor and size containers adequately

To ensure that containerized applications function optimally, verify that application containers are allocated sufficient resources. It may be necessary to adjust application parameters for container environments, like Java heap size parameters.

Developers can identify container resource issues using monitoring utilities, like [Container Insights,](https://learn.microsoft.com/azure/azure-monitor/containers/container-insights-overview) which supports Azure Kubernetes Service, Azure Container Instances, on-premises Kubernetes clusters, and more.

- Identify AKS containers that are running on the node and their average processor and memory utilization. This knowledge can assist in identifying resource bottlenecks.

- Identify processor and memory utilization of container groups and their containers hosted in Azure Container Instances.

- Review the resource utilization of workloads running on the host that are unrelated to the standard processes that support the pod.

### 4. Implement network isolation and SSL connectivity

PostgreSQL Flexible Server natively supports connectivity through Azure Virtual Networks, meaning that the database endpoint does not face the public Internet, and database traffic remains within Azure. Consider the [06 / Networking and Security] document for more information regarding public and private access.

Microsoft also recommends securing data in motion through SSL for applications that support SSL connectivity. Legacy applications should only use lower SSL versions or disable SSL connectivity in secure network environments.

### 5. Retry on transient faults

Given that cloud environments are more likely to encounter transient faults, like network connectivity interruptions or service timeouts, applications must implement logic to deal with them, typically by retrying requests after a delay.

Applications must first determine if a fault is transient or more persistent. Typically, API responses indicate the nature of the issue, sometimes even specifying a retry interval. If the fault is transient, applications must retry requests without consuming excessive resources. Common retry strategies include sending requests at regular intervals, exponential intervals, or random intervals. If a given number of retry requests fail, applications consider the operation failed.

Azure SDKs typically provide native support for retrying service requests. Consult the documentation's [list of per-service retry recommendations.](https://learn.microsoft.com/azure/architecture/best-practices/retry-service-specific)

For some ORMs that are commonly used with PostgreSQL databases, like PHP's **PDO PostgreSQL**, it may be necessary to write custom retry code that retries database connections if particular PostgreSQL error codes are thrown.

### 6. Size database compute resources adequately

Teams must be diligent with sizing their Flexible Server instances to be cost-effective while maintaining sufficient application performance. There are [three different tiers of Flexible Server instances](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-compute-storage), each with different intended use cases and memory configurations.

- **Burstable**:
  - Up to **2 GiB** memory per vCore
  - Intended for workloads that do not use the CPU continuously
  - Cost-effective for smaller web applications and development workloads
- **General Purpose**:
  - **4 GiB** per vCore
  - Intended for applications that require more throughput
- **Memory Optimized**:
  - **8 GiB** per vCore
  - Intended for high-throughput transactional and analytical workloads, like real-time data processing

Flexible Server instances can be resized after creation. Azure stops database VM instances and needs up to 120 seconds to scale compute resources.

Use Azure Monitor Metrics to determine if a Flexible Server instance requires to be scaled. Monitor metrics like **Host CPU percent**, **Active Connections**, **IO percent**, and **Host Memory Percent** to make scaling decisions. To test database performance under realistic application load, consider utilities like [sysbench.](https://wiki.postgresql.org/wiki/SysBench)

### 7. Utilize Reserved Capacity

In addition to resizing instances, compute resources can also be prepaid with reserved capacity. With Azure Database for PostgreSQL Flexible Server reserved capacity, an upfront commitment on PostgreSQL server can be made for a one or three-year period to get a significant discount on the compute costs. To purchase Azure Database for PostgreSQL Flexible Server reserved capacity, it is required to specify the Azure region, deployment type, performance tier, and term. For more information, see [Prepay for Azure Database for PostgreSQL compute resources with reserved capacity](https://learn.microsoft.com/azure/postgresql/single-server/concept-reserved-pricing).
