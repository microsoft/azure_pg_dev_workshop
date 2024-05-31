# Introduction to the Sample Application

Instead of learning multiple sample applications, the application modernication journey focuses on evolving an architecture and deployment strategies. Readers should learn the sample application structure once and focus on how the application will need to be modified to fit the deployment model and architecture evolution.

## Sample Application overview and story

Contoso NoshNow is a delivery service and logistics company focused on making delicious food accessible to its customers no matter where they are located. The company started with a simple web application they could easily maintain and add features to as the business grew. A few years later, their CIO realized the application performance and their current on-premises environment were not meeting their business's growing demand. The application deployment process took hours, yielded unreliable results, and the admin team could not easily find production issues quickly. During busy hours, customers complained the web application responds very slowly.

The development team knew migrating to Azure could help with these issues.

## Solution architecture

This is the base application that will be evolved in the future sample scripts. This PaaS architecture is a couple of steps ahead of the Classic architecture. The Classic architecture is meant to be an example of an existing on-premises environment that might be migrated to the Azure cloud. For a new application, start with the PaaS architecture depicted below. This is the easiest path for a user looking to understand the Azure basics.

![This image shows a sample architecture involving a PHP App Service instance and a Flexible Server instance.](media/sample-app-level-1-architecture.png "Basic Azure deployment architecture")

## Site map

The web application is simple, but covers the fundamentals.

![This image shows the sample app site map.](media/sample-app-site-map.png "Sample app site map")

## Running the sample lab

Find the steps to run the lab in the artifacts repo here: [Sample application tutorial](https://github.com/azure/azure-postgresql/blob/master/DeveloperGuide/step-1-sample-apps/README.md)
