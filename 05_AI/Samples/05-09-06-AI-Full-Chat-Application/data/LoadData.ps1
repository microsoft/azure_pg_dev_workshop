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