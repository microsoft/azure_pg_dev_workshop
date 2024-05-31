$sourcePath = "c:\labfiles\microsoft-postgresql-developer-guide\artifacts\sample-php-app";
$targetPath = "c:\inetpub\wwwroot\";

# create a new IIS directory
mkdir $targetPath;

# copy the php files
copy-item -Path "$sourcepath" "$targetpath"

#deploy the database
$username = "wsuser";
$password = "Solliance123";
$server = "localhost";
$database = "contosostore";

#create the database
psql -h $server -U $username -e "create database $database"

#setup the schema
psql -h $server -U $username $database -e "source $sourcePath/database/schema.sql"