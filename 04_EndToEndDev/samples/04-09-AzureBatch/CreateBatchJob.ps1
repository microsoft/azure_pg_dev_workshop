function AddTask($jobId, $taskName, $command, $userIdentity, $envVariables)
{
    New-AzureBatchTask -DisplayName $taskName -jobId $jobId -BatchContext $batchContext -EnvironmentSettings $envVariables -CommandLine $command -UserIdentity $userIdentity;
}
function AddPackage($applicationName, $applicationPath, $applicationVersion)
{
    New-AzBatchApplicationPackage -AccountName $batchAccountName -ResourceGroupName $batchResourceGroupName -ApplicationName $applicationName -ApplicationVersion $applicationVersion -FilePath $applicationPath -Format "zip"
}

function AddJob($jobName, $poolName)
{
    $PoolInformation = New-Object -TypeName "Microsoft.Azure.Commands.Batch.Models.PSPoolInformation";
    $PoolInformation.PoolId = $poolName;
    
    New-AzureBatchJob -Id $jobName -PoolInformation $PoolInformation -BatchContext $Context
}

$batchAccountName = "pgsqldevSUFFIX";
$batchResourceGroupName = "RG_NAME";

$context = Get-AzBatchAccount -ResourceGroupName $batchResourceGroupName -AccountName $batchAccountName

AddPackage "app01_PostgreSQL" "c:\temp\application.zip" "1.0.0";
$job = AddJob "PostgreSQL" "main";
$jobId = $job.Id;

$command = "powershell powershell -command (`"(Get-ChildItem Env:AZ_BATCH_APP_PACKAGE_app01_PostgreSQL#1.0.0).Value`" + '\applications\PostgreSQL_copy_orders.ps1')";

$userIdentity = New-Object Microsoft.Azure.Commands.Batch.Models.PSUserIdentity -ArgumentList($userAccount.Name)
$userIdentity = New-Object Microsoft.Azure.Commands.Batch.Models.PSAutoUserSpecification -ArgumentList @("Pool", "Admin") 

$envVariables = @{};
$envVariables.Batch_VaultName = "pgsqldevSUFFIX";
$envVariables.Batch_Thumbprint = "pgsqldevSUFFIX";
$envVariables.Batch_AppId = "pgsqldevSUFFIX";
$envVariables.Batch_TenantId = "pgsqldevSUFFIX";

AddTask $jobId "task01" $command $userIdentity $envVariables;