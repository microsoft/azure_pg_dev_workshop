# AppMod 05 : Deployment via CI/CD

This is a simple app that runs PHP code to connect to a PostgreSQL database. Both the application and database are deployed via Docker containers.

## Azure DevOps Option

### Create DevOps Project

1. Login to Azure Dev Ops (https://dev.azure.com)
2. Select **New project**
3. For the name, type **contosostore**
4. For the visibiilty, select **Private**
5. Select **Create**

### Setup Git Origin and push code

1. In the new project, select **Repos**
2. In the **Push an existing repository from command line** section, select the **Copy** button
3. In the **pgsqldevSUFFIX-win11** virtual machine, switch to Visual Studio code
4. In the terminal window, run the following:

    ```powershell
    cd c:\labfiles\microsoft-postgresql-developer-guide\sample-php-app

    git remote remove origin
    git remote remove azure
    ```

5. In the terminal window, paste the repo url copied from above (it will look something like the following):

    ```powershell
    git remote add origin https://ORG_NAME@dev.azure.com/ORG_NAME/contosostore/_git/contosostore
    git push -f origin main
    ```

6. Press **ENTER** (be sure to replace ORG_NAME)
7. In the dialog, login using the Microsoft Entra credentials for the repo. The files will get pushed to the repo.

   > NOTE:  If using sensitive credentials, be sure to remove them or delete the virtual machine when finished with the developer guide content.

8. Switch back to Azure Dev Ops, refresh the repo, all the repo files should be visible.

### Create Service Connection

1. In the lower left, select **Project Settings**
2. Under **Pipelines**, select **Service Connections**
3. Select **Create service connection**
4. Select **Azure Resource Manager**
5. Select **Next**
6. For the authentication, select **Service principal (automatic)**
7. Select **Next**
8. Select the lab subscription and resource group

    > **NOTE** If no subscriptions are displayed, open Azure Dev Ops in a in-private window and try again

9. For the service connection name, type **PostgreSQLDev**
10. Select **Grant access permission to all pipelines**
11. Select **Save**

### Create Pipeline

1. In the left navigation, select **Pipelines**
2. Select **Create Pipeline**
3. Select **Azure Repos Git**
4. Select the **ContosoStore** repo
5. Select **Existing Azure Pipelines YAML file**
6. Select the **/azure-pipelines.yaml** file
7. Select **Continue**
8. Select **Run**

> **NOTE** Check the Dev Ops repo is setup with the appropriate branch (`master` vs `main`). Update the YAML and supporting steps accordingly.

### Create Release

1. In the left navigation, select **Releases**
2. Select **New pipeline**
3. Select the **Azure App Service Deployment**
4. Select **Apply**
5. In the **Artifacts** section, select the **Add an artifact** shape
6. For the project, select **contosostore**
7. For the source, select **contosostore**
8. Select **Add**
9. Select the **Lighting** icon to add an trigger
10. Select **Enabled** for the `Creates a release every time a new build is available`
11. Select the **1 job, 1 task** link
12. Select the **PostgreSQLDev** connection
13. For **App type**, select **Web App on Linux**
14. Select the **pgsqldevSUFFIXlinux** app service
15. Select **Save**, in the dialog, select **OK**

### Commit some changes

1. Switch back to the **pgsqldevSUFFIX-win11** virtual machine
2. Run the following:

    ```powershell
    git add -A
    git commit -a -m "Pipeline settings"
    git push -f origin main
    ```

### Perform the deployment

1. Select **Pipelines**.
2. Select the **contosostore** pipeline, then select **Run pipeline**.
3. Select **Run**.
4. Select **Releases**.
5. Select the **PostgreSQL Dev** pipeline.
6. The release should show as being deployed, wait for the pipeline to complete execution.

### Test the DevOps deployment

1. Browse to `https://pgsqldevSUFFIXlinux.azurewebsites.net/default.php`, the site should be displayed.
2. Browse to `https://pgsqldevSUFFIXlinux.azurewebsites.net/database.php`, the results should display.

## GitHub Option

### Create Github repo

1. Browse to `https://github.com`.
2. Login with GitHub credentials.
3. In the top right, select the **+** then select **New repository**.
4. For the name, type **contosostore**.
5. Select **Create repository**.

### Upload the application

1. Switch to Visual Studio code.
2. In the terminal window, run the following:

    ```powershell
    git remote remove origin
    ```

3. In the terminal window, paste the code copied above, press **ENTER**

    ```powershell
    git remote add origin https://github.com/USERNAME/contosostore.git
    git branch -M main
    git push -u origin main
    ```

4. In the dialog, login using GitHub credentials for the repo. The files get pushed to the repo.
5. Switch back to GitHub, refresh the repo, the files should display.

### Generate Credentials

1. Run the following commands to generate the azure credentials (be sure to replace the token values for subscription and resource group):

    ```PowerShell
    az login

    az ad sp create-for-rbac --name "pgsqldevSUFFIX" --sdk-auth --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group}
    ```

2. Copy the json that is outputted
3. Switch back to the GitHub repository, select **Settings** then select **Secrets**
4. Select **New repository secret**
5. For the name, type **AZURE_CREDENTIALS**
6. Paste the json from above as the value
7. Select **Save**

### Deploy the code

1. In the GitHub browser window, select **Actions**
2. Select **set up a workflow yourself**
3. Copy and paste the `github-pipelines.yaml` into the `main.yml` file
4. Update the `AZURE_WEBAPP_NAME: pgsqldevSUFFIX` line to replace the SUFFIX
5. Select **Start commit**
6. Select **Commit new file**
7. Select **Actions**, then select the `Create main.yml` workflow instance, the `Contoso Store` job should be displayed, select it
8. Review the tasks that were executed

### Test the GitHub deployment

1. Browse to `https://pgsqldevSUFFIXlinux.azurewebsites.net/default.php`, the application should be displayed.
2. Browse to `https://pgsqldevSUFFIXlinux.azurewebsites.net/database.php`, results should be displayed.

<!--
## Terraform


## Azure Bicep


-->