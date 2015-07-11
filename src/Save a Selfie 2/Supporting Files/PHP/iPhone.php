<?php
define('DB_USER', 'xx');

/** MySQL database password */
define('DB_NAME', 'xx');

/** MySQL database username */
define('DB_USER', 'xx');

/** MySQL database password */
define('DB_PASSWORD', 'xx');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

error_reporting(E_ALL);
ini_set("display_errors", 1);

$root = '/var/www/vhosts/saveaselfie.org/httpdocs/wp/wp-content/themes/storedImages/';
$images = ""; $markers = "";
// $date = date('m/d/Y h:i:s a', time());
// $datetime = new DateTime($date);
// $datetime->setTimezone(new DateTimeZone('UTC'));
// $datetime = $datetime->format('YmdHis'); // . rand(0, 9999);
// echo "Date and time: $date ($datetime)<br><br>\n";
date_default_timezone_set('Europe/Dublin');
$datetime = date('YmdHis');
$connection = '';
if ($connection == '') {
	$connection = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD) or die ("unable to connect to database");
	$result = mysqli_query($connection, "use " . DB_NAME);
	countRows('Before');
}

// if (htmlspecialchars($_POST['k']) == 'y') { // clear directory and database table
// }
$typeOfObject = $_POST['typeOfObject'];
$locationName = $_POST['location'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$key = $_POST['id'];
$image = $_POST['image'];
$thumbnail = $_POST['thumbnail'];
$source = 'ipho';
$caption = $_POST['caption'];
	if (($caption == 'no save') || ($caption == 'No save')) exit;
$caption = str_replace("'", "\'", $caption);
$locationName = mysqli_real_escape_string($connection, $locationName);

file_put_contents('iPhone.txt', "Results:\n$key, $typeOfObject, $locationName, $longitude, $latitude, $caption\n" . substr($image, 0, 30) . "...\n" . substr($thumbnail, 0, 30) . "...");
$image = str_replace(' ','+', $image);
$thumbnail = str_replace(' ','+', $thumbnail);
$filename = 'ip' . $key;
$standard_resolution = $filename . '_m.jpg';
file_put_contents($root.$standard_resolution, base64_decode($image));
$thumbnail_resolution = $filename . '_s.jpg';
file_put_contents($root.$thumbnail_resolution, base64_decode($thumbnail));

function countRows($beforeAfter) {
	global $connection; if ($connection == '') return;
	$query = "select count(*) from selfie_info"; $result = doQuery2($query); checkResult($query, $result);
	while ($row = mysqli_fetch_array($result, MYSQL_ASSOC)) {
		echo "$beforeAfter: there are " . $row['count(*)'] . " records in database.\n";
	}
}

$query = "REPLACE INTO selfie_info (`key`, `typeOfObject`, `app`, `thumbnail`, `standard`, `user`, `GPS`, `locationName`, `caption`, `timestamp`) " . 
		"VALUES ('$key', '$typeOfObject', 'ipho', '$thumbnail_resolution', '$standard_resolution', '', GeomFromText( 'POINT($latitude $longitude)'), '$locationName', '$caption', '$datetime')";
$result = doQuery2($query);
checkResult($query, $result);

$r2 = 'http://www.saveaselfie.org/wp/wp-content/themes/storedImages/';
fusionTable($key, $typeOfObject, $r2.$thumbnail_resolution, $r2.$standard_resolution, $latitude, $longitude, $locationName, $caption, $datetime); // iPhone

if ($connection != '') {
	$query = "delete from selfie_info where (`key`='')";
	$result = doQuery2($query);
	checkResult($query, $result);
	countRows('After');
}

function errorUrl() {
	$urlfinal = "http://".$_SERVER['SERVER_NAME']."/index.php";
	$url = $_SERVER["REQUEST_URI"];
	$stringa = $url;
	$dacercare = "?";
	$dsdsa = "";
	$pos = strpos($stringa, $dacercare);
	if (strpos($stringa, $dacercare) == true) { 
		$pos = strpos($stringa, $dacercare);
		if ($pos!=10) {
			$dsdsa = substr($url,$pos,100);
			$dsdsa = "<script language=javascript>document.location.href=\"$urlfinal$dsdsa\"</script>";	
		} else { $dsdsa = ""; }
	
	}
	return $dsdsa;
}
// echo "errorURL: " . errorUrl() . ".<br>\n";

function fusionTable($key, $typeOfObject, $thumbnail_resolution, $standard_resolution, $latitude, $longitude, $locationName, $caption, $datetime) {
	$CLIENT_ID = 'xx.apps.googleusercontent.com'; // OK
	$FT_SCOPE = 'https://www.googleapis.com/auth/fusiontables'; // allows read and write
	$SERVICE_ACCOUNT_NAME = 'xx@developer.gserviceaccount.com'; // OK
	$KEY_FILE = 'xxf.p12'; // OK
	// Fusion Tables API has to be turned on in the Console for this to work!!!!
	// Use Client ID for a SERVICE ACCOUNT !!!
	//
	// Reference at https://developers.google.com/fusiontables/docs/v1/sql-reference
	//

	require_once 'google-api-php-client/autoload.php';
	require_once 'google-api-php-client/src/Google/Service/Fusiontables.php';
	/* Define all constants */
	// API Key	AIzaSyAHGFUApBhAkkM_DG2a8CqDSd1AqqhLscw
	$client = new Google_Client();
	$client->setApplicationName("Save a Selfie");
	$client->setClientId($CLIENT_ID);
	$client->setDeveloperKey("xx");
	$tableID = 'xx';
	// //add key
	$ky = file_get_contents($KEY_FILE);
	// echo "Key is $key<br>\n";
	$client->setAssertionCredentials(new Google_Auth_AssertionCredentials(
		$SERVICE_ACCOUNT_NAME,
		array($FT_SCOPE),
		$ky)
	);
	$service = new Google_Service_Fusiontables($client);
	
	$selectQuery = "select rowid from $tableID where key = '$key'";
	file_put_contents('FT.txt', $selectQuery);
	$result = $service->query->sql($selectQuery);
	$row = $result['rows'][0][0];
	if ($row == '') { // new entry
		$query = "INSERT INTO $tableID (key, typeOfObject, app, thumbnail, standard, latitude, longitude, locationName, caption, timestamp) " . 
				"VALUES ('$key', '$typeOfObject', 'ipho', '$thumbnail_resolution', '$standard_resolution', '$latitude', '$longitude', '$locationName', '$caption', '$datetime')";
		file_put_contents('FT.txt', $query);
		$result = $service->query->sql($query);
		checkResult($query, $result);
	} else { // old entry
		$query = "UPDATE $tableID SET key = '$key', typeOfObject = '$typeOfObject', app = 'ipho', thumbnail = '$thumbnail_resolution', " . 
				"standard = '$standard_resolution', latitude = '$latitude', longitude = '$longitude', locationName = '$locationName', caption = '$caption', timestamp = '$datetime'
				WHERE rowid = '$row'";
		file_put_contents('FT.txt', $query);
		$result = $service->query->sql($query);
		checkResult($query, $result);
	}
}

function doQuery2($sqlquery)
{ 
    global $count, $last_statement, $last_result, $connection;
    if ($connection == '') { echo "Can't do $sqlquery, database not connected!<br>\n"; return; }
	$result = mysqli_query($connection, $sqlquery) or die (mysqli_error($connection));
	return $result;
}

function checkResult($query, $result) {
// Check result
// This shows the actual query sent to MySQL, and the error. Useful for debugging.
	if (!$result) {
		$message  = 'Invalid query: ' . mysqli_error() . "<br>\n";
		$message .= 'Whole query: ' . $query;
		file_put_contents('FTFail.txt', $message);
		die($message);
	} // else echo "this worked: " . $query . "<br>\n";
}
// $query = "select * from wp_posts where ID < 100;";
// $result = doQuery2($query);
// checkResult($query, $result);
// while($row = mysqli_fetch_array($result, MYSQL_ASSOC)) {
// 	echo "<pre>"; print_r($row); echo "</pre>";
// }

// $token = $_POST['t'];

?>
