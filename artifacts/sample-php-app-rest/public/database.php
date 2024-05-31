<?php

$servername = "localhost";
$username = "postgres";
$password = "Solliance123";
$dbname = "contosostore";
$port = "5432"

// connection string with SSL certificate files
$conn_str  = 'host=' . $servername . ' ';
$conn_str .= 'port=' . $port . ' ';
$conn_str .= 'dbname=' . $dbname . ' ';
$conn_str .= 'user=' . $username . ' ';
$conn_str .= 'password=' . $password . ' ';
//$conn_str .= 'sslmode=verify-full ';
//$conn_str .= 'sslrootcert=/home/site/wwwroot/public/DigiCertGlobalRootCA.crt.pem ';

// attempt connection
$conn = pg_connect($conn_str); //or die('Cannot connect to database.');

// Check connection
if (!$conn) {
  die("Connection failed: " . pg_last_error());
}

$sql = "SELECT count(*) FROM users";

$result = pg_query($conn, $sql);

if  (!$result) {
    echo "query did not execute";
}

while ($row = pg_fetch_array($result)) {
    echo $row[0] . " records" ;
}

pg_close();

?>
