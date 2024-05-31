az login --identity

$acrList = $(az acr list -o json | ConvertFrom-Json)
$acrName = $acrList[0].name

$creds = $(az acr credential show --name $acrname -o json | ConvertFrom-Json)

$username = $creds.username
$password = $creds.passwords[0].value

docker login "$($acrName).azurecr.io" -u $username -p $password

docker tag dpage/pgadmin4 "$($acrName).azurecr.io/dpage/pgadmin4"

docker tag store-db "$($acrName).azurecr.io/store-db"

docker tag store-web "$($acrName).azurecr.io/store-web"

docker push "$($acrName).azurecr.io/store-db"

docker push "$($acrName).azurecr.io/store-web"

docker push "$($acrName).azurecr.io/dpage/pgadmin4"