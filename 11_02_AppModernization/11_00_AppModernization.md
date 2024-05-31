# Application Modernization Journey

- [Application Modernization Journey](#application-modernization-journey)
    - [Classic deployment](#classic-deployment)
    - [Azure VM deployment](#azure-vm-deployment)
    - [Simple App Service deployment with Azure Database for PostgreSQL Flexible Server](#simple-app-service-deployment-with-azure-database-for-postgresql-flexible-server)
    - [Continuous Integration (CI) and Continuous Delivery (CD)](#continuous-integration-ci-and-continuous-delivery-cd)
    - [Containerizing layers with Docker](#containerizing-layers-with-docker)
    - [Azure Container Instances (ACI)](#azure-container-instances-aci)
    - [App Service Containers](#app-service-containers)
    - [Azure Kubernetes Service (AKS)](#azure-kubernetes-service-aks)
    - [AKS with PostgreSQL Flexible Server](#aks-with-postgresql-flexible-server)
      - [Start the application modernization journey](#start-the-application-modernization-journey)
          - [Determining the evolutionary waypoint](#determining-the-evolutionary-waypoint)

Let us discuss the journey overview. The journey will start with a classic deployment to a typical web and database server on a `physical` or `virtualized` host operating system. Next, explore the evolution of the potential deployment options from a simple web app deployed to App Service through a complex progression ending with the application running as containers in Azure Kubernetes Service (AKS) with Azure Database for PostgreSQL Flexible Server hosting the database.

The following scenarios will be discussed and demonstrated as part of this Azure PostgreSQL developer's guide. All of the following deployments will utilize the same application and database backend and what is needed to modify the application to support the targets. Topics will be discussed in the following simple to complex architecture order.

### Classic deployment

In a classic deployment, development and operations staff will typically set up a web server (such as Internet Information Services (IIS), Apache, or NGINX) on physical or virtualized **on-premises** hardware.

Some web servers are relatively easier to set up than others. The complexity depends on what the target operating system is and what features the application and database are using, for example, SSL/TLS.

In addition to the web server, it is also necessary to install and configure the physical PostgreSQL database server. This includes creating the schema and the application users that will be used to access the target database(s).

As part of our sample application and supporting Azure Landing zone created by the ARM templates, most of this gets set up automatically. Once the software is installed and configured, it is up to the developer to deploy the application and database on the system. Classical deployments tend to be manual such that the files are copied to the target production web server and then deployed the database schema and supported data via PostgreSQL tools or the pgAdmin tool.

The biggest advantage of a classic on-premises deployment is the infrastructure team will have full control of the environment. The biggest weakness is they must also maintain every aspect of the environment as well.

Follow the [Classic deployment](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/01-ClassicDeploy) guide to deploy the application and database.

### Azure VM deployment

An Azure VM Deployment is similar to a classical deployment but rather than deploying to physical hardware, deployment is to virtualized hardware in the Azure cloud. The operating system and software will be the same as in a classic deployment, but to open the system to external apps and users, the virtual networking must be modified to allow database access to the web server. This is known as the IaaS (infrastructure as a service) approach.

The advantages of using Azure to host virtual machines include the ability to enable backup and restore services, disk encryption, and scaling options that require no upfront costs and provide flexibility in configuration options with just a few clicks of the mouse. This is in contrast to the relatively complex and extra work needed to enable these types of services on-premises.

Follow the [Azure VM deployment](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/02-01-CloudDeploy-Vm) guide to deploy the application and database.

### Simple App Service deployment with Azure Database for PostgreSQL Flexible Server

If supporting the operating system and the various other software is not a preferred approach, the next evolutionary path is to remove the operating system and web server from the list of setup and configuration steps. This can be accomplished by utilizing the Platform as a Service (PaaS) offerings of Azure App Service and Azure Database for PostgreSQL Flexible Server.

However, modernizing an application and migrating it to these aforementioned services may introduce some relatively small application changes.

Follow the [Simple App Service deployment with Azure Database for PostgreSQL Flexible Server](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/02-02-CloudDeploy-AppSvc) guide to deploy the application and database.

### Continuous Integration (CI) and Continuous Delivery (CD)

Doing manual deployments every time a change is made can be a very time-consuming endeavor. Utilizing an automated deployment approach can save a lot of time and effort. Azure DevOps and Github Actions can be used to automatically deploy code and databases each time a new commit occurs in the codebase.

Whether using Azure DevOps or Github, there will be some setup work to support the deployments. This typically includes creating credentials that can connect to the target environment and deploy the release artifacts.

Follow the [Continuous Integration (CI) and Continuous Delivery (CD)](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/02-03-CloudDeploy-CICD) guide to deploy the application and database.

### Containerizing layers with Docker

By building the application and database with a specific target environment in mind, it will need to be assumed that the operations team will have deployed and configured that same environment to support the application and data workload. If they miss any items, the application will either not load or may error during runtime.

Containers solve the potential issue of misconfiguration of the target environment. By containerizing the application and data, the application will run exactly as intended. Containers can also more easily be scaled using tools such as Kubernetes.

Containerizing an application and data layer can be relatively complex, but once the build environment is set up and working, it is possible to push container updates very quickly to multi-region load-balanced environments.

Follow the [Containerizing layers with Docker](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/03-00-Docker) guide to deploy the application and database.

### Azure Container Instances (ACI)

After application and data layers are migrated to containers, a hosting target must be selected to run the containers. A simple way to deploy a container is to use Azure Container Instances (ACI).

Azure Container Instances can deploy one container at a time or multiple containers to keep the application, API, and data contained in the same resource.

Follow the [Azure Container Instances (ACI)](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/03-01-CloudDeploy-ACI) guide to deploy the application and database.

### App Service Containers

Developers can extend the benefits of App Service, like scalability, elasticity, and simple CI/CD integration, to their containerized apps using App Service for Containers. This offering supports individual containers and multi-container apps through Docker Compose files. Containers give teams added flexibility beyond the platforms supported directly by App Service.

Follow the [App Service Containers](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/03-02-CloudDeploy-AppService-Container) guide to deploy the application and database.

### Azure Kubernetes Service (AKS)

ACI and App Service Container hosting are effective ways to run containers, but they do not provide many enterprise features: deployment across nodes that live in multiple regions, load balancing, automatic restarts, redeployment, and more.

Moving to Azure Kubernetes Service (AKS) will enable the application to inherit all the enterprise features provided by AKS. Moreover, Kubernetes apps that persist data in PostgreSQL Flexible Server unlock numerous benefits:

- In supported regions, co-locating Flexible Server and AKS nodes in the same availability zone minimizes latency.

Follow the [Azure Kubernetes Service (AKS)](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/04-AKS) guide to deploy the application and database to AKS.

### AKS with PostgreSQL Flexible Server

Running the database layer in a container is better than running it in a VM, but not as great as removing all the operating system and software management components.

Follow the [AKS with PostgreSQL Flexible Server](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/05-CloudDeploy-PostgreSQLFlex) guide to deploy the application and database.

#### Start the application modernization journey

To reiterate, it is recommended to follow the application modernization developer journey from start to finish in the following order:

1. [Classic deployment](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/01-ClassicDeploy)
2. [Azure VM Deployment](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/02-01-CloudDeploy-Vm)
3. [Simple App Service Deployment with Azure Database for PostgreSQL Flexible Server](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/02-02-CloudDeploy-AppSvc)
4. [Continuous Integration / Continuous Delivery](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/02-03-CloudDeploy-CICD)
5. [Containerizing layers with Docker](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/03-00-Docker)
6. [Azure Container Instances (ACI)](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/03-01-CloudDeploy-ACI)
7. [App Service Containers](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/03-02-CloudDeploy-AppService-Container)
8. [Azure Kubernetes Service (AKS)](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/04-AKS)
9. [AKS with Azure Database for PostgreSQL Flexible Server](https://github.com/azure/azure-postgresql/tree/master/DeveloperGuide/step-2-developer-journey-steps/05-CloudDeploy-PostgreSQLFlex)

###### Determining the evolutionary waypoint

In this module, we have explored the evolution from classic development and deployment to current modern development and deployment methods. As a review, be sure to reference this information to find a starting point and pick the final target.
