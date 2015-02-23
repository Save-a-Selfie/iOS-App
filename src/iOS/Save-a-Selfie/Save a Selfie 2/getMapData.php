<?php
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

$connection = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD) or die ("unable to connect to database");
$result = mysqli_query($connection, "use " . DB_NAME);

// error_reporting(E_ALL);
// ini_set("display_errors", 1);

global $selfiesPlusMap; $selfiesPlusMap = $selfiesPlusMap ? true : false;
global $mapOnly;
$root = 'http://www.saveaselfie.org/wp/wp-content/themes/storedImages/';

$query = "select * from selfie_info";
$query = "select `key`, `typeOfObject`, `app`, `thumbnail`, `standard`, `user`, X(GPS), Y(GPS), `locationName`, `caption`, `timestamp` from selfie_info ORDER BY timestamp DESC";
$result = doQuery2($query);
checkResult($query, $result);
$count = 0; $imageList = ''; $markerList = '';
while ($row = mysqli_fetch_array($result, MYSQL_ASSOC)) {
	list($div, $marker) = useRowValues($row, $count);
	if ($div) {	$imageList .= "$div\n"; $markerList .= "$marker\n"; $count++; }
	if ($homePageMax) if ($count > $homePageMax) break;
// 	echo "count is $count<br>\n";
}

function useRowValues($row, $count) {
	global $mapOnly, $selfiesPlusMap, $root;
	$latitude = $row['X(GPS)'];
	if ($latitude) {
		$typeOfObject = $row['typeOfObject'];
		$longitude = $row['Y(GPS)'];
		$caption = $row['caption']; $caption = str_replace("'", "\'", $caption); $caption = str_replace('"', '\"', $caption);
		$thumb = $root . $row['thumbnail']; $standard_resolution = $root. $row['standard'];
		$app = $row['app']; $user = $row['user']; $key = $row['key']; $timestamp = $row['timestamp'];
		echo "$standard_resolution\t$caption\t$typeOfObject\t$latitude\t$longitude\t$thumb\t$app\n";
	} else return array("", ""); 
}

function doQuery2($sqlquery)
{ 
    global $connection;
	$result = mysqli_query($connection, $sqlquery) or die (mysqli_error($connection));
	return $result;
}

function checkResult($query, $result) {
// Check result
// This shows the actual query sent to MySQL, and the error. Useful for debugging.
	if (!$result) {
		$message  = 'Invalid query: ' . mysqli_error() . "<br>\n";
		$message .= 'Whole query: ' . $query;
		die($message);
	} // else echo "this worked: " . $query . "<br>\n";
}
?>