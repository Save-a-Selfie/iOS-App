<?php
define('DB_NAME', 'iculture_wpSAS');

/** MySQL database username */
define('DB_USER', 'iculture_wpSAS');

/** MySQL database password */
define('DB_PASSWORD', '1K]P)V86SP');

/** MySQL hostname */
define('DB_HOST', 'localhost');

error_reporting(E_ALL);
ini_set("display_errors", 1);

$connection = '';
$root = '/home/iculture/public_html/saveaselfie/wp-content/themes/storedImages/';
$images = ""; $markers = "";
$date = date('m/d/Y h:i:s a', time());
$datetime = new DateTime(date());
$datetime->setTimezone(new DateTimeZone('UTC'));
$datetime = $datetime->format('YmdHis') . rand(0, 9999);
echo "Date and time: $date ($datetime)<br><br>\n";

if (htmlspecialchars($_POST['k']) == 'y') { // clear directory and database table
}

$locationName = $_POST['location'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$key = $_POST['id'];
$image = $_POST['image'];
$thumbnail = $_POST['thumbnail'];
$type = 'ipho';
$caption = $_POST['caption'];
$caption = str_replace("'", "\'", $caption);
$locationName = mysqli_real_escape_string($connection, $locationName);

file_put_contents('iPhone.txt', "Results: $key, $locationName, $longitude, $latitude, $caption, $image, $thumbnail");
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
		echo "$beforeAfter: there are " . $row['count(*)'] . " records in database.<br>\n";
	}
}

if ($connection == '') {
	$connection = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD) or die ("unable to connect to database");
	$result = mysqli_query($connection, "use " . DB_NAME);
	countRows('Before');
}
$query = "REPLACE INTO selfie_info (`key`, `app`, `thumbnail`, `standard`, `user`, `GPS`, `locationName`, `caption`, `timestamp`) " . 
		"VALUES ('$key', 'ipho', '$thumbnail_resolution', '$standard_resolution', '', GeomFromText( 'POINT($latitude $longitude)'), '$locationName', '$caption', '$datetime')";
$result = doQuery2($query);
checkResult($query, $result);

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
