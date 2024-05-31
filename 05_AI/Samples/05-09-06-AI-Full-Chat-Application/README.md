# Hands-on Lab: Full Chat Application with Semantic Kernel, PostgreSQL, Azure Open AI

This solution demonstrates how to design and implement a RAG Pattern solution that incorporates PostgreSQL with Azure OpenAI Service and Azure Cognitive Search to build a vector search solution with an AI assistant user interface. The solution shows how to generate vectors on data stored in PostgreSQL using Azure OpenAI Service, how to implement vector search using the vector search capability of Azure Cognitive Search and get the response from Azure OpenAI Service's ChatGPT using the matched documents as a context. The solution includes the frontend and backend components hosted on Azure Kubernetes Service. The solution also showcases key concepts such as managing conversational context and history, managing tokens consumed by Azure OpenAI Service, as well as understanding how to write prompts for large language models such as ChatGPT so they produce the desired responses.

The scenario for this sample centers around a consumer retail "Intelligent Agent" that allows users to ask questions on vectorized product, customer and sales order data stored in the database. The data in this solution is the Cosmic Works sample. This data is an adapted subset of the Adventure Works 2017 dataset for a retail bike shop that sells bicycles, biking accessories, components and clothing. It has been ported over to PostgreSQL.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure Database for PostgreSQL Flexible Server
- Azure OpenAI-enabled subscription
- Azure AI Search
- Azure App Service Plan, Azure App Service
- Storage Account

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

### Software pre-requisites

All of this is done already in the lab setup scripts for the Lab virtual machine but is provided here for reference.

- Install Visual Studio
- Install the latest [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli-windows?tabs=powershell)

### Database Setup

1. Open a browser window to the **pgsqldevSUFFIXflex16** Azure Database for PostgreSQL Flexible Server
2. Under **Settings**, select **Server parameters**
3. Search for **extensions**
4. In the dropdown, ensure the **VECTOR** extension is checked
5. Select **Save**

### Container Creation and File Upload

1. Run the following to uplaod the system and memory prompts:

    ```powershell
    cd C:\labfiles\microsoft-postgresql-developer-guide\05_AI\Samples\05-09-06-AI-Full-Chat-Application\Scripts
    $resourceGroupName = "RESOURCE_GROUP_NAME"
    $location = "LOCATION"
    az account set --subscription "SUBSCRIPTION_NAME"
    .\UploadSystemPrompts.ps1 -resourceGroup $resourceGroupName -location $location
    ```

## Exercise 1: Setup Solution

### Task 1: Open and configure project

1. Open the `c:\labfiles\microsoft-postgresql-developer-guide\05_AI\Samples\05-09-06-AI-Full-Chat-Application\VectorSearchAiAssistance.sln`  solution file.
2. Before you can start debugging, you need to set the startup projects. To do this, right-click on the solution in the Solution Explorer and select `Configure Startup Projects...`. In the dialog that opens, select `Multiple startup projects` and set the `Action` for the `ChatServiceWebApi` and `Search` projects to `Start`.
3. Select **OK**

### Task 2: Configure local settings

This solution can be run locally post-Azure deployment. To do so, use the steps below.

1. In the `Search` project, make sure the content of the `appsettings.json` file is similar to this:

    ```json
    {
        "DetailedErrors": true,
        "Logging": {
            "LogLevel": {
            "Default": "Information",
            "Microsoft.AspNetCore": "Warning"
        }
        },
        "AllowedHosts": "*",
        "MSPostgreSQLOpenAI": {
            "ChatManager": {
                "APIUrl": "https://localhost:63279",
                "APIRoutePrefix": ""
            }
        }
    }
    ```

2. In the `ChatServiceWebApi` project, make sure the content of the `appsettings.json` file is similar to this:

    ```json
    {
        "Logging": {
            "LogLevel": {
                "Default": "Information",
                "Microsoft.AspNetCore": "Warning"
            }
        },
        "AllowedHosts": "*",
        "MSPostgreSQLOpenAI": {
            "CognitiveSearch": {
                "IndexName": "vector-index",
                "MaxVectorSearchResults": 10
            },
            "OpenAI": {
                "CompletionsDeployment": "completions",
                "CompletionsDeploymentMaxTokens": 4096,
                "EmbeddingsDeployment": "embeddings",
                "EmbeddingsDeploymentMaxTokens": 8191,
                "ChatCompletionPromptName": "RetailAssistant.Default",
                "ShortSummaryPromptName": "Summarizer.TwoWords",
                "PromptOptimization": {
                    "CompletionsMinTokens": 50,
                    "CompletionsMaxTokens": 300,
                    "SystemMaxTokens": 1500,
                    "MemoryMinTokens": 500,
                    "MemoryMaxTokens": 2500,
                    "MessagesMinTokens": 1000,
                    "MessagesMaxTokens": 3000
                }
            },
            "DurableSystemPrompt": {
                "BlobStorageContainer": "system-prompt"
            }
        }
    }
    ```

- In the `ChatServiceWebApi` project, create an `appsettings.Development.json` file with the following content (replace all `<...>` placeholders with the values from your deployment):

    ```json
    {
        "MSPostgreSQLOpenAI": {
            "CognitiveSearch": {
                "Endpoint": "https://<...>.search.windows.net",
                "Key": "<...>"
            },
            "OpenAI": {
                "Endpoint": "https://<...>.openai.azure.com/",
                "Key": "<...>"
            },
            "DurableSystemPrompt": {
                "BlobStorageConnection": "<...>"
            },
            "BlobStorageMemorySource": {
                "ConfigBlobStorageConnection": "<...>"
            },
            "CognitiveSearchMemorySource": {
                "Endpoint": "https://<...>.search.windows.net",
                "Key": "<...>",
                "ConfigBlobStorageConnection": "<...>"
            }
        }
    }
    ```

    >**NOTE**: The `BlobStorageConnection` and `ConfigBlobStorageConnection` values can be found in the Azure Portal by navigating to the Storage Account created by the deployment (the one that has a container named `system-prompt`) and selecting the `Access keys` blade. The value is the `Connection string` for the `key1` key. `CognitiveSearchMemorySource` has the same values and `CognitiveSearch` section.

4. Also, make sure the newly created `appsettings.Development.json` file is copied to the output directory. To do this, right-click on the file in the Solution Explorer and select `Properties`. In the properties window, set the `Copy to Output Directory` property to `Copy always`.
5. You are now ready to start debugging the solution locally. To do this, press `F5` or select `Debug > Start Debugging` from the menu.

    **NOTE**: With Visual Studio, you can also use alternate ways to manage the secrets and configuration. For example, you can use the `Manage User Secrets` option from the context menu of the `ChatWebServiceApi` project to open the `secrets.json` file and add the configuration values there.

## Exercise 2: Load Data

1. Create the database tables
    - Open pgAdmin and connect to the `` instance
    - Run the `C:\labfiles\microsoft-postgresql-developer-guide\05_AI\Samples\05-09-06-AI-Full-Chat-Application\data\database.sql` script
2. Run the following script to setup the customer and product data. The `ChatWebServiceApi` will need to be running to execute this successfully:

    ```powershell

    cd C:\labfiles\microsoft-postgresql-developer-guide\05_AI\Samples\05-09-06-AI-Full-Chat-Application\data

    $env:API_URL = "localhost:63280"
    
    #load the customers.json file
    $customers = Get-Content -Path "customers.json" -Raw | ConvertFrom-Json
    
    #load the products.json file
    $products = Get-Content -Path "products.json" -Raw | ConvertFrom-Json
    
    #make call to the api to upload each customer
    foreach ($customer in $customers) 
    {
        $body = $customer | ConvertTo-Json
        Invoke-RestMethod -Uri "http://$($env:API_URL)/customers" -Method Put -Body $body -ContentType "application/json"
    }
    
    #make call to the api to upload each product
    foreach ($product in $products) {
        $body = $product | ConvertTo-Json
        Invoke-RestMethod -Uri "http://$($env:API_URL)/products" -Method Put -Body $body -ContentType "application/json"
    }
    ```

## Exercise 3: Test the Chat Application

1. Browse to the web application for the solution in your browser.
2. Click [+ Create New Chat] button to create a new chat session.
3. Type in your questions in the text box and press Enter. Some sample questions you can ask:

   - What kind of socks do you have available?
   - Do you have any customers from Canada? Where in Canada are they from?
   - What kinds of bikes are in your product inventory?

## Exercise 4: Add New Data

1. Start a new chat session in the web application.
1. In the chat text box, type: "Can you list all of your socks?". The AI Assistant will list 4 different socks of two types, racing and mountain.
1. Using either CURL or Postman, send the following payload in a PUT request with a `Content-Type` header value of `application/json` to `https://<chat-service-hostname>/products` to add a product.
  
### Curl Command

1. You can use the following commands to add a product to the database:

    ```pwsh
    $jsonBody = '{
        "id": "00001",
        "categoryId": "C48B4EF4-D352-4CD2-BCB8-CE89B7DFA642",
        "categoryName": "Clothing, Socks",
        "sku": "SO-R999-M",
        "name": "Cosmic Racing Socks, M",
        "description": "The product called Cosmic Racing Socks, M",
        "price": 6.00,
        "tags": [
            {
                "id": "51CD93BF-098C-4C25-9829-4AD42046D038",
                "name": "Tag-25"
            },
            {
                "id": "5D24B427-1402-49DE-B79B-5A7013579FBC",
                "name": "Tag-76"
            },
            {
                "id": "D4EC9C09-75F3-4ADD-A6EB-ACDD12C648FA",
                "name": "Tag-153"
            }
        ]
    }'
    
    Invoke-RestMethod -Uri "http://$($env:API_URL)/products" -Method Put -Body $jsonBody -ContentType "application/json"
    ```

1. Return to the AI Assistant and type, "Can you list all of your socks again?". This time you should see a new product, "Cosmic Socks, M"
2. Run the following command to remove the previous product:

    ```pwsh
    $env:API_URL = "localhost:63280"
    Invoke-RestMethod -Uri "http://$($env:API_URL)/products/00001?categoryId=C48B4EF4-D352-4CD2-BCB8-CE89B7DFA642" -Method Delete -Body $jsonBody -ContentType "application/json"
    ```

3. Open a **new** chat session and ask the same question again. This time it should show the original list of socks in the product catalog.

**Note:** Using the same chat session after adding them will sometimes result in the Cosmic Socks not being returned. If that happens, start a new chat session and ask the same question. Also, sometimes after removing the socks, they will continue to be returned by the AI Assistant. If that occurs, also start a new chat session. The reason this occurs is that previous prompts and completions are sent to OpenAI to allow it to maintain conversational context. Because of this, it will sometimes use previous completions as a background for generating subsequent responses.

<p align="center">
    <img src="img/socks.png" width="100%">
</p>

## Exercise 5: Deployment

1. This solution deploys to Azure Kubernetes Service (AKS) using the following script.

    ```pwsh
    $resourceGroupName = "RESOURCE_GROUP_NAME"
    $location = "LOCATION"
    $subscriptionId = "SUBSCRIPTION_ID"
    ./scripts/Unified-Deploy.ps1 -deployAks 1 -resourceGroup <rg_name> -location <location> -subscription <target_subscription_id>
    ```

There are many options for deployment, including using an existing Azure OpenAI account and models. For deployment options and prerequisites, please see [How to Deploy](./docs/deployment.md) page.

## Clean-up

Delete the resource group to delete all deployed resources.

## Resources

- [Upcoming blog post announcement](https://devblogs.microsoft.com/cosmosdb/)
- [OpenAI Platform documentation](https://platform.openai.com/docs/introduction/overview)
- [Azure OpenAI Service documentation](https://learn.microsoft.com/azure/cognitive-services/openai/)
