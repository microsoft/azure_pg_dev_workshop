# Hands-on Lab: Azure Function with PostgreSQL (.NET)

In this hands-on lab, an HTTP Function Application will be created using Visual Studio and .NET. The HTTP Function Application will connect to an Azure Database for PostgreSQL Flexible Server and display database information.

## Setup

### Required Resources

Several resources are required to perform this lab. These include:

- Azure App Service Plan (Linux)
- Azure App Service (Linux)
- Azure Database for PostgreSQL Flexible Server

Create these resources using the PostgreSQL Flexible Server Developer Guide Setup documentation:

- [Deployment Instructions](../../../11_03_Setup/00_Template_Deployment_Instructions.md)

### Software pre-requisites

All this is done already in the lab setup scripts for the Lab virtual machine but is provided here for reference.

- Install [Visual Studio 2022 Community Edition](https://visualstudio.microsoft.com/downloads/)
  - Expand the **Download Visual Studio with .NET** dropdown for an installation package with the .NET SDK.
  - Once Visual Studio loads, sign in with an Azure account.
  - Open the Visual Studio installer from the Start menu.
  - Select **Modify** next to the **Visual Studio Community 2022** installation.
  - Select the **Azure development** tile below the **Web & Cloud** header. Then, select **Modify** at the lower right-hand corner of the window.
- Install the [Azure Functions core tools MSI](https://go.microsoft.com/fwlink/?linkid=2174087).

## Exercise 1: Create the Function Application

This application is based on an **Http Trigger** that will then make a call into the Azure Database for PostgreSQL Flexible Server instance and add some records. Create this function by performing the following steps.

- Open Visual Studio, if prompted, sign in.
- Select **Create a new project**.
- Search for **Azure Functions**.
- Select **C#** for the language.
- Select **Next**.
- For the name, type **ShowDatabasesFunction**.
- Select the project path.
- Select **Next**.
- For the functions works, select **.NET 8.0 Isolated (Long Term Support)**.
- For the function type, select **Http Trigger**.
- For the Storage account, select **User Azurite for runtime storage account**.
- For the authorization level, select **Function**.
- Select **Create**.
- Open the **Function1.cs** file, and update the function class (in `Function1.cs`) to the following. This Function completes the following tasks when its HTTP endpoint receives a request:
  - Connecting to the Azure Database for PostgreSQL Flexible Server instance provisioned in the ARM template.
  - Generating a list of databases on the PostgreSQL instance.
  - Building a formatted response.
  - Returning the formatted response to the caller.
- Be sure to replace the `SUFFIX` connection information:

```csharp
    public static class ShowDatabasesFunction
    {
        [Function("ShowDatabasesFunction")]
        public static string Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequestData req)
        {
            NpgsqlConnectionStringBuilder builder = new NpgsqlConnectionStringBuilder
            {
                Host = "pgsqldevSUFFIXflex16.postgres.database.azure.com",
                Username = "wsuser",
                Password = "Solliance123",
                Database = "postgres",
                SslMode = SslMode.Require
            };

            string responseMessage = "";

            using (var conn = new NpgsqlConnection(builder.ConnectionString))
            {
                conn.Open();

                using (var command = conn.CreateCommand())
                {
                    command.CommandText = "SELECT datname FROM pg_catalog.pg_database;";
                    NpgsqlDataReader r = command.ExecuteReader();

                    while (r.Read())
                    {
                        responseMessage += r["datname"] + "\r\n";
                    }
                }
            }

            return responseMessage;
        }
    }
```

- Right-click the project, then select **Manage Nuget Packages**.
- Select the **Browse** tab.
- Search for **Npgsql**, select it, then select **Install**.
- Select **Apply**.
- Select **Ok** if prompted.
- At the top of `Function1.cs` file, add the following `using` references.

    ```csharp
    using Npgsql;
    ```

- Press **F5** to start the function.
- When prompted by Windows Security dialog, select **Allow**.
- Open a browser window to the function endpoint, it will be like the following:

```text
http://localhost:7071/api/ShowDatabasesFunction
```

- A list of databases should be displayed.

## Exercise 2: Deploy the Function Application

Now that the function app is created and working locally, the next step is to publish the function app to Azure.

- Stop debugging the project.
- Right-click the project, then select **Publish**.
- Select **Azure**, then select **Next**.
- For the target, select **Azure Function App (Linux)**.

    ![This image demonstrates choosing the Azure Function App Linux deployment option.](./media/choose-linux-function-app.png "Azure Function App Linux")

- Select **Next**.
- Select the **Sign in** button, log in using the lab credentials.
- Select the account, subscription and resource group.
- Select the **pgsqldevSUFFIX-ShowDatabasesFunction** function app.
- Select **Close**.
- Select **Publish**, and if prompted, select **Yes** to update the runtime version.
- Switch to the Azure portal, browse to the lab resource group.
- Select the **pgsqldevSUFFIX-ShowDatabasesFunction** Function App instance.
- Under **Functions**, select **App keys**.
- Copy the function `default` app key value.
- It should now be possible to browse to the function endpoint and see data, replace the `APPKEY` with the copied one:

```text
https://pgsqldevSUFFIX-ShowDatabasesFunction.azurewebsites.net/api/ShowDatabasesFunction?code=APPKEY
```

## Exercise 3: Test the Function App in the Azure portal

- Switch to the Azure portal, browse to the lab resource group.
- Select the **pgsqldevSUFFIX-ShowDatabasesFunction** Function App instance.
- On the **Overview** page, select the **ShowDatabasesFunction** link.
- On the **ShowDatabasesFunction** page, select **Code + Test**. Then, select **Test/Run** to access the built-in testing interface.
- If prompted, select the warning to enable CORS.
- Issue a simple GET request to the Function App endpoint using the `master` key.

    > **NOTE** It is possible to use a *function key*, which is scoped to an individual Function App, or a *host key*, which is scoped to an Azure Functions instance.

    ![This image demonstrates how to configure a GET request to the Function App endpoint from the Azure portal.](./media/azure-portal-function-test.png "GET request test")

- The Function App should execute successfully and a list of items should display.

## Troubleshooting

- If the application builds successfully, but deployment fails, try restarting Visual Studio and publishing the Function App again to avoid transient errors.
- Enabling Application Insight logs is a useful way to debug Function Apps deployed to Azure. As Application Insights cannot be configured from the Visual Studio publish profile, consult the [Microsoft documentation](https://learn.microsoft.com/azure/azure-functions/configure-monitoring?tabs=v2#enable-application-insights-integration) for the manual setup steps.
