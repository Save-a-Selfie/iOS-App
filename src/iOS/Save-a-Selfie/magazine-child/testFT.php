<?php

// Fusion Tables API has to be turned on in the Console for this to work!!!!
// Use Client ID for a SERVICE ACCOUNT !!!
// Also need to set sharing in Google Docs for the Fusion Table – supply 937274562770-su20su3p3ll5lqjpd5hnamnbnkjn8fu9@developer.gserviceaccount.com !!!
//
// Reference at https://developers.google.com/fusiontables/docs/v1/sql-reference
//

require_once 'google-api-php-client/autoload.php';
require_once 'google-api-php-client/src/Google/Service/Fusiontables.php';
/* Define all constants */
// API Key	AIzaSyAHGFUApBhAkkM_DG2a8CqDSd1AqqhLscw
const CLIENT_ID = '937274562770-su20su3p3ll5lqjpd5hnamnbnkjn8fu9.apps.googleusercontent.com'; // OK
const FT_SCOPE = 'https://www.googleapis.com/auth/fusiontables'; // allows read and write
const SERVICE_ACCOUNT_NAME = '937274562770-su20su3p3ll5lqjpd5hnamnbnkjn8fu9@developer.gserviceaccount.com'; // OK
const KEY_FILE = 'Save a Selfie-331ca5babbcf.p12'; // OK
$client = new Google_Client();
$client->setApplicationName("Save a Selfie");
$client->setClientId(CLIENT_ID);
$client->setDeveloperKey("AIzaSyAHGFUApBhAkkM_DG2a8CqDSd1AqqhLscw");
$tableID = '1YvmYPXQYA_3-IIIQ9xj_UCpCdiDEP-4Aof_8-iy0';
// //add key
$key = file_get_contents(KEY_FILE);
// echo "Key is $key<br>\n";
$client->setAssertionCredentials(new Google_Auth_AssertionCredentials(
    SERVICE_ACCOUNT_NAME,
    array(FT_SCOPE),
    $key)
);
$service = new Google_Service_Fusiontables($client);
$number = rand(1,100);
$updateQuery = "update $tableID set typeOfObject = $number where rowid = '2'";
echo "<p><strong>SQL</strong>: ".$updateQuery."</p>";
echo "<pre>";
// print_r($service->query->sql($updateQuery));
$selectQuery = "select rowid from $tableID where key = '20141103204637'";
echo "<p><strong>SQL</strong>: ".$selectQuery."</p>";
$result = $service->query->sql($selectQuery);
print_r($result);
echo "</pre>";
$row = $result['rows'][0][0];
echo "row is $row<br>\n";
$updateQuery = "update $tableID set caption = 'test caption via Fusion Tables' where rowid = '$row'";
echo "<pre>";
echo "<p><strong>SQL</strong>: ".$updateQuery."</p>";
$result = $service->query->sql($updateQuery);
print_r($result);
echo "</pre>";
?>
