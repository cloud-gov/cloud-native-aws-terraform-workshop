<?
$db_config = getenv("HTTP_DB_URI");
$db_hostname = explode(":", getenv("HTTP_DB_URI"));
try {
    $connection = new PDO("mysql:host=".$db_hostname[0].";dbname=workshop;charset=utf8", "workshop", getenv("HTTP_DB_PASSWORD"));
} catch (Exception $e) {
    http_response_code(500);
    error_log("Couldn't create database connection with URI: ".$db_config." Error: ".$e->getMessage());
}
?>