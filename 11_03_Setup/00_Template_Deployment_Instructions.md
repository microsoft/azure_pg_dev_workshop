# Getting Started

1. Clone the [whitepaper GitHub repository](https://github.com/solliancenet/microsoft-PostgreSQL-developer-guide.git) to the development machine.

    ```cmd
    mkdir c:\labfiles
    cd c:\labfiles
    git clone https://github.com/solliancenet/microsoft-PostgreSQL-developer-guide.git
    ```

2. Install the [PowerShell Azure module](https://learn.microsoft.com/powershell/azure/install-az-ps) if not already installed.

    > [PowerShell Core](https://github.com/PowerShell/PowerShell)  is a cross-platform tool that is useful for managing Azure resources through the `Az` module.

    > Try the `-AllowClobber` flag if the install does not succeed.

3. Utilize the `Connect-AzAccount` to interactively authenticate the Azure PowerShell environment with Azure.

## Ensure Resource Providers

1. Open the Azure Portal
2. Browse to your lab subscription
3. Under **Settings**, select **Resource providers**
4. Search for **Microsoft.OperationsManagement**
5. Select it
6. Select **Register**

## Create a Lab Resource Group

1. Use Azure PowerShell to create a new resource group. Substitute the `rgName` and `location` parameters with the name of the resource group and its location, respectively.

    ```powershell
    $rgName = "RESOURCE_GROUP_NAME"
    $location = "REGION"
    New-AzResourceGroup -Name $rgName -Location $location
    ```

> NOTE:  Because of some automation account mapping settings, these templates are designed to only be deployed to `eastus2`, `eastus`, `southcentralus`, `westcentralus`, `westus2`, `westus`, `northcentralus`

### Verify capacity

Be sure to validate that your subscription can deploy resources in the target region.  In some cases, the template will not create all resources if you have not enabled them.  Reference [Resolve capacity errors for Azure Database for PostgreSQL Flexible Server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/how-to-resolve-capacity-errors?tabs=portal).

## Deploy the ARM Template

The deployment with take about ~75 minutes to setup the Virtual Machine used for the labs and samples.

1. There are two ARM templates provided with the whitepaper.

    - The secure deployment uses private endpoints to securely access the PostgreSQL database instances through private IP addresses. It costs roughly ... per month.
    - The standard deployment routes traffic to the PostgreSQL instances over the public internet. It costs roughly ... per month.

2. If deploying the [secure ARM template](../Artifacts/template-secure.json) (`template-secure.json`), edit the associated [parameters file](../Artifacts/template-secure.parameters.json) (`template-secure.parameters.json`).

    - The `prefix` specifies a unique identifier for Azure resources
    - The `administratorLogin` specifies the login for the Azure resources (such as PostgreSQL and the VM)
    - The `administratorLoginPassword` specifies the password for the deployed Azure resources
    - The `location` should be set to an Azure environment closest to the users

3. If deploying the [insecure ARM template](../Artifacts/template.json) (`template.json`), edit the associated [parameters file](../Artifacts/template.parameters.json) (`template.parameters.json`).
    - The `uniqueSuffix` specifies a unique identifier for Azure resources
    - The `administratorLogin` specifies the login for the Azure resources (such as PostgreSQL and the VM)
    - The `administratorLoginPassword` specifies the password for the deployed Azure resources
    - The `vmSize` specifies the VM tier
    - The `dnsPrefix` specifies the DNS prefix for the load balancer public IP address

4. If deploying the secure ARM template, issue the following command from the repository root.

    ```powershell
    cd "C:\labfiles\microsoft-postgres-docs-project"

    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile .\artifacts\template-secure.json -TemplateParameterFile .\artifacts\template-secure.parameters.json
    ```

    Use `template.json` and `template.parameters.json` for the insecure ARM template deployment.

## Setup Application Modernization

If you are exploring the application modernization labs, you will also need to run the script to setup the extra components.

1. Connect to the **paw-1** virtual machine
2. Open a PowerShell window
3. Browse to the **C:\labfiles\microsoft-postgres-docs-project\artifacts** directory
4. Run the following command:

```powershell
app-modernization-setup.ps1
```
