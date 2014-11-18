<?php
define('DB_NAME', 'iculture_wpSAS');

/** MySQL database username */
define('DB_USER', 'iculture_wpSAS');

/** MySQL database password */
define('DB_PASSWORD', '1K]P)V86SP');

/** MySQL hostname */
define('DB_HOST', 'localhost');
$connection = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD) or die ("unable to connect to database");
$result = mysqli_query($connection, "use " . DB_NAME);


$root = 'http://www.iculture.info/saveaselfie/wp-content/themes/storedImages/';

$query = "select `key`, `typeOfObject`, `app`, `thumbnail`, `standard`, `user`, X(GPS), Y(GPS), `locationName`, `caption`, `timestamp` from selfie_info ORDER BY timestamp DESC";
$result = doQuery2($query);
checkResult($query, $result);

echo '"key", "typeOfObject", "app", "thumbnail", "standard", "user", "latitude", "longitude", "locationName", "caption", "timestamp"' . "\n";

$count = 0; $imageList = ''; $markerList = '';
while ($row = mysqli_fetch_array($result, MYSQL_ASSOC)) {
	useRowValues($row, $count);
}

function quo($x, $comma) {
	echo '"' . $x . '"' . $comma;
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
		quo($key, ',');
		quo($typeOfObject, ',');
		quo($app, ',');
		quo($thumb, ',');
		quo($standard_resolution, ',');
		quo($user, ',');
		quo($latitude, ',');
		quo($longitude, ',');
		quo($caption, ',');
		quo($timestamp, "\n");
	}
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