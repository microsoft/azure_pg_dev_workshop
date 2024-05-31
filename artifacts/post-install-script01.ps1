#Disable-InternetExplorerESC
function DisableInternetExplorerESC
{
  $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
  $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
  Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force -ErrorAction SilentlyContinue -Verbose
  Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force -ErrorAction SilentlyContinue -Verbose
  Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green -Verbose
}

#Enable-InternetExplorer File Download
function EnableIEFileDownload
{
  $HKLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
  $HKCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
  Set-ItemProperty -Path $HKLM -Name "1803" -Value 0 -ErrorAction SilentlyContinue -Verbose
  Set-ItemProperty -Path $HKCU -Name "1803" -Value 0 -ErrorAction SilentlyContinue -Verbose
  Set-ItemProperty -Path $HKLM -Name "1604" -Value 0 -ErrorAction SilentlyContinue -Verbose
  Set-ItemProperty -Path $HKCU -Name "1604" -Value 0 -ErrorAction SilentlyContinue -Verbose
}

function ConfigurePhp($iniPath)
{
    write-host "Configuring PHP ($iniPath)" -ForegroundColor Green -Verbose

    $content = get-content $iniPath -ea SilentlyContinue;

    if ($content)
    {
      $content = $content.replace(";extension=curl","extension=curl");
      $content = $content.replace(";extension=fileinfo","extension=fileinfo");
      $content = $content.replace(";extension=mbstring","extension=mbstring");
      $content = $content.replace(";extension=openssl","extension=openssl");
      $content = $content.replace(";extension=pdo_pgsql","extension=pdo_pgsql");
      $content = $content.replace(";extension=pdo_mysql","extension=pdo_mysql");

      set-content $iniPath $content;

      $phpDirectory = $iniPath.replace("\php.ini","");
      $phpPath = "$phpDirectory\php-cgi.exe";

      New-WebHandler -Name "PHP_via_FastCGI" -Path "*.php" -ScriptProcessor "$phpPath" -Module FastCgiModule -Verb *

      # Set the max request environment variable for PHP
      $configPath = "system.webServer/fastCgi/application[@fullPath='$php']/environmentVariables/environmentVariable"
      $config = Get-WebConfiguration $configPath
      if (!$config) {
          $configPath = "system.webServer/fastCgi/application[@fullPath='$php']/environmentVariables"
          Add-WebConfiguration $configPath -Value @{ 'Name' = 'PHP_FCGI_MAX_REQUESTS'; Value = 10050 }
      }

      # Configure the settings
      # Available settings: 
      #     instanceMaxRequests, monitorChangesTo, stderrMode, signalBeforeTerminateSeconds
      #     activityTimeout, requestTimeout, queueLength, rapidFailsPerMinute, 
      #     flushNamedPipe, protocol   
      $configPath = "system.webServer/fastCgi/application[@fullPath='$phpPath']"
      Set-WebConfigurationProperty $configPath -Name instanceMaxRequests -Value 10000
      Set-WebConfigurationProperty $configPath -Name monitorChangesTo -Value '$phpDirectory\php.ini'
    }
}

function AddPhpApplication($path, $port)
{
  #create an IIS web site on the path and port
  New-IISSite -Name "contosostore" -BindingInformation "*:$($port):" -PhysicalPath "$path\Public"

  #add IIS permissions
  $ACL = Get-ACL -Path "$path\storage";
  $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IUSR","FullControl","Allow");
  $ACL.SetAccessRule($AccessRule);
  $ACL | Set-Acl -Path "$path\storage";

  $ACL = Get-ACL -Path "$path\bootstrap\cache";
  $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IUSR","FullControl","Allow");
  $ACL.SetAccessRule($AccessRule);
  $ACL | Set-Acl -Path "$path\bootstrap\cache";

  iisreset /restart 
}

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append

[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 

mkdir "c:\temp" -ea SilentlyContinue;
mkdir "c:\temp\python-function" -ea SilentlyContinue;
mkdir "c:\labfiles" -ea SilentlyContinue;

#download the solliance pacakage
$WebClient = New-Object System.Net.WebClient;
$WebClient.DownloadFile("https://raw.githubusercontent.com/solliancenet/common-workshop/main/scripts/common.ps1","C:\LabFiles\common.ps1")
$WebClient.DownloadFile("https://raw.githubusercontent.com/solliancenet/common-workshop/main/scripts/httphelper.ps1","C:\LabFiles\httphelper.ps1")
$WebClient.DownloadFile("https://raw.githubusercontent.com/solliancenet/common-workshop/main/scripts/rundeployment.ps1","C:\LabFiles\rundeployment.ps1")

#run the solliance package
. C:\LabFiles\Common.ps1
. C:\LabFiles\HttpHelper.ps1

Set-Executionpolicy unrestricted -force

DisableInternetExplorerESC

EnableIEFileDownload

EnableDarkMode

SetFileOptions

InstallChocolaty

InstallAzPowerShellModule

InstallChrome

InstallNotepadPP

InstallGit
        
InstallAzureCli

#will get port 5432
InstallPostgres16

#will get port 5433
InstallPostgres14

InstallPython "3.11";

InstallPgAdmin

Write-Host "Install Azure Functions core tools." -ForegroundColor Green -Verbose
choco install azure-functions-core-tools

Write-Host "Install VS build tools." -ForegroundColor Green -Verbose
choco install visualstudio2022buildtools

Write-Host "Install VCPP build tools." -ForegroundColor Green -Verbose
choco install visualcpp-build-tools

InstallPgAdmin

$extensions = @("ms-vscode-deploy-azure.azure-deploy", 
  "ms-azuretools.vscode-docker", 
  "ms-python.python", 
  "ms-azuretools.vscode-azurefunctions",
  "ms-vscode-remote.remote-wsl");

InstallVisualStudioCode $extensions;

InstallFiddler;

InstallPowerBI;

Uninstall-AzureRm -ea SilentlyContinue

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";C:\Program Files\PostgreSQL\16\bin"

cd "c:\labfiles";

$branchName = "main";
$workshopName = "microsoft-postgresql-developer-guide";
$repoUrl = "solliancenet/$workshopName";

#download the git repo...
Write-Host "Download Git repo." -ForegroundColor Green -Verbose
git clone https://github.com/solliancenet/$workshopName.git $workshopName

#do the deployment...
Connect-AzAccount -Identity

$subscription = Get-AzSubscription
$subscriptionId = $subscription.Id

#setup the sql database.
#get the database server name
$servers = Get-AzPostgreSqlFlexibleServer -SubscriptionId $subscriptionId

$ipAddress = (Invoke-WebRequest -uri "https://ifconfig.me/ip" -UseBasicParsing).Content 

$resourceGroups = Get-AzResourceGroup
$ResourceGroupName = $resourceGroups[0].ResourceGroupName
$suffix = $resourceGroups[0].tags["Suffix"]

#add the VM ip address
foreach($server in $servers)
{
  $serverName = $server.Name

  Write-Host "Setup Flexible Server [$serverName]." -ForegroundColor Green -Verbose

  New-AzPostgreSqlFlexibleServerFirewallRule -FirewallRuleName $([Guid]::newguid().tostring())  -StartIpAddress '0.0.0.0' -EndIpAddress '0.0.0.0' -ServerName $serverName  -ResourceGroupName $ResourceGroupName

  $databaseName = "airbnb"
  New-AzPostgreSqlFlexibleServerDatabase -Name $databaseName -ResourceGroupName $ResourceGroupName -ServerName $serverName

  $databaseName = "chat"
  New-AzPostgreSqlFlexibleServerDatabase -Name $databaseName -ResourceGroupName $ResourceGroupName -ServerName $serverName

  $databaseName = "contosostore"
  New-AzPostgreSqlFlexibleServerDatabase -Name $databaseName -ResourceGroupName $ResourceGroupName -ServerName $serverName

  $databaseName = "products"
  New-AzPostgreSqlFlexibleServerDatabase -Name $databaseName -ResourceGroupName $ResourceGroupName -ServerName $serverName

  $databaseName = "ailabs"
  New-AzPostgreSqlFlexibleServerDatabase -Name $databaseName -ResourceGroupName $ResourceGroupName -ServerName $serverName

  New-AzPostgreSqlFirewallRule -Name AllowMyIP -ServerName $serverName -ResourceGroupName $ResourceGroupName -StartIPAddress $ipAddress -EndIPAddress $ipAddress

  #add vm ip addresses
  $publicIpAddress = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name "pgsqldev$($suffix)-linux-1-pip" | Select-Object -ExpandProperty ipAddress
  New-AzPostgreSqlFirewallRule -Name "pgsql$($suffix)-linux-1" -ServerName $serverName -ResourceGroupName $ResourceGroupName -StartIPAddress $ipAddress -EndIPAddress $ipAddress -ea SilentlyContinue

  #add vm ip addresses
  $publicIpAddress = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name "pgsqldev$($suffix)-win11-pip" | Select-Object -ExpandProperty ipAddress
  New-AzPostgreSqlFirewallRule -Name "pgsql$($suffix)-win11" -ServerName $serverName -ResourceGroupName $ResourceGroupName -StartIPAddress $ipAddress -EndIPAddress $ipAddress -ea SilentlyContinue

  #add vm ip addresses
  $publicIpAddress = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name "pgsqldev$($suffix)-paw-1-pip" | Select-Object -ExpandProperty ipAddress
  New-AzPostgreSqlFirewallRule -Name "pgsql$($suffix)-paw-1" -ServerName $serverName -ResourceGroupName $ResourceGroupName -StartIPAddress $ipAddress -EndIPAddress $ipAddress -ea SilentlyContinue
}

$filePath = "c:\labfiles\$workshopName\artifacts\data\airbnb.sql"

$env:Path += ';C:\Program Files\PostgreSQL\16\bin'

Write-Host "Setting up airbnb [$serverName]." -ForegroundColor Green -Verbose

#set the password
$databaseName = "airbnb"
$env:PGPASSWORD=$password
$serverName = "pgsqldev$($suffix)flex14"
psql -h "$($serverName).postgres.database.azure.com" -d $databaseName -U wsuser -p 5432 -a -w -f $filePath

$filePath = "c:\labfiles\$workshopName\microsoft-postgresql-developer-guide\05_AI\Samples\05-09-06-AI-Full-Chat-Application\data\database.sql"

Write-Host "Setting up chat [$serverName]." -ForegroundColor Green -Verbose

#set the password
$databaseName = "chat"
$env:PGPASSWORD=$password
$serverName = "pgsqldev$($suffix)flex14"
psql -h "$($serverName).postgres.database.azure.com" -d $databaseName -U wsuser -p 5432 -a -w -f $filePath

#set the password
$databaseName = "chat"
$env:PGPASSWORD=$password
$serverName = "pgsqldev$($suffix)flex16"
psql -h "$($serverName).postgres.database.azure.com" -d $databaseName -U wsuser -p 5432 -a -w -f $filePath

InstallVisualStudio "community" "2022";

choco install visualstudio2022-workload-azure

Stop-Transcript