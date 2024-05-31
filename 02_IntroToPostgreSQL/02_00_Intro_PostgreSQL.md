# 02 / Introduction to Azure Database for PostgreSQL Flexible Server

Before jumping into Azure Database for PostgreSQL Flexible Server, it is important to understand some PostgreSQL history. Also, it is important to cover the various PostgreSQL hosting options and their pros and cons. As part of this guide, we will cover Artificial Intelligence (AI) and how Azure Database for PostgreSQL Flexible Server plays in this exciting space.

## What is PostgreSQL?

[PostgreSQL](https://www.postgresql.org/) is an open-source object-relational database management system based on [Structured Query Language (SQL)](https://en.wikipedia.org/wiki/SQL). PostgreSQL supports a rich set of SQL query capabilities and offers excellent performance and security for multiple data workloads. Its ability to run on all major operating systems combined with the abilty to extend via addons have made PostgreSQL a popular option with many organizations. Customers can use existing programming frameworks and languages to connect easily with PostgreSQL databases. Reference the latest [PostgreSQL Feature Matrix](https://www.postgresql.org/about/featurematrix/) for a more in-depth review of PostgreSQL's features.

Watch the [Introduction to Azure Database for PostgreSQL Flexible Server](https://youtu.be/NSEmJfUgNzE) online video.

## Comparison with other RDBMS offerings

Though PostgreSQL has a distinct set of advantages, it does compete with other typical relational database offerings. Though the emphasis of this guide is operating PostgreSQL on Azure to architect scalable applications, it is important to be aware of other potential offerings such as [MySQL](https://www.mysql.com/) and [MariaDB](https://mariadb.org/).

In addition to the most popular relational database systems, new products have emerged to support vector-based systems for AI purposes. Because PostgresSQL also has this capability, it will be important to review these other offerings and how PostgreSQL compares to them.

## PostgreSQL hosting options

Like other DBMS systems, PostgreSQL has multiple deployment options for development and production environments.

### On-premises

PostgreSQL is a cross-platform offering, and corporations can utilize their on-premises hardware to deploy highly-available PostgreSQL configurations. PostgreSQL on-premises deployments are highly configurable, but they require upfront hardware capital expenditure and have the disadvantages of hardware/OS maintenance.

One benefit to choosing a cloud-hosted environment over on-premises configurations is there are no significant upfront costs. Organizations can choose to pay monthly subscription fees as pay-as-you-go or to commit to a certain usage level for discounts. Maintenance, OS software updates, security, and support all fall into the responsibility of the cloud provider so IT staff are not required to utilize precious time troubleshooting hardware or software issues.

#### Pros

- Highly configurable environment

#### Cons

- Upfront capital expenditures
- OS and hardware maintenance
- Increased operation center and labor costs
- Time to deploy and scale new solutions

### Cloud IaaS (in a VM)

Migrating an organization's infrastructure to an IaaS solution helps reduce maintenance of on-premises data centers, save money on hardware costs, and gain real-time business insights. IaaS solutions allow IT resources to scale up and down with demand. They also help to quickly provision new applications and increase the reliability of the existing underlying infrastructure.

IaaS lets organizations bypass the cost and complexity of buying and managing physical servers and data center infrastructure. Each resource is offered as a separate service component and only requires paying for resources for as long as they are needed. A cloud computing service provider like Microsoft Azure manages the infrastructure, while organizations purchase, install, configure, and manage their own software—including operating systems, middleware, and applications.

#### Pro

- Highly configurable environment
- Fast deployment of additional servers
- Reduction in operation center costs

#### Cons

- OS and middleware administration costs

### Containers

While much more lightweight, containers are like VMs and can be started and stopped in a few seconds. Containers also offer tremendous portability, making them ideal for developing an application locally on a development machine and then hosting it in the cloud, in test, and later in production. Containers can even run on-premises or in other clouds. This flexibility is possible because the development environment machine travels with the container. The application runs in a consistent manner. Containerized applications are flexible, cost-effective, and deploy quickly.

PostgreSQL offers a [Docker image](https://hub.docker.com/_/postgres) to operate PostgreSQL in customized and containerized applications. A container-based PostgreSQL instance can persist data to the hosting environment via the container runtime, allowing for high availability across container instances and environments.

#### Pro

- Application scalability
- Portability between environments
- Automated light-weight fast deployments
- Reduced operating costs

#### Cons

- Networking and configuration complexity
- Container monitoring

### Cloud PaaS

PostgreSQL databases can be deployed on public cloud platforms by utilizing VMs, container runtimes, and Kubernetes. However, these platforms require a middle ground of customer management. If a fully managed environment is required, cloud providers offer their own managed PostgreSQL products, such as Amazon RDS for PostgreSQL and Google Cloud SQL for PostgreSQL. Microsoft Azure offers Azure Database for PostgreSQL Flexible Server.

- **Video** - [Introducing Azure Database for PostgreSQL and Azure Database for MySQL](https://www.youtube.com/watch?v=ElKfEurMi9E)
