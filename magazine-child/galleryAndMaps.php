<div id="floatingBox"><img id="floatingImage" src=""><div id="floatingCaption"></div><div id="floatingMap"></div></div>
<script type='text/javascript' src='http://iculture.info/saveaselfie/wp-content/themes/magazine-child/float.js'></script>
<script>var images = new Array(), captions = new Array();</script>

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

// error_reporting(E_ALL);
// ini_set("display_errors", 1);

global $selfiesPlusMap; $selfiesPlusMap = $selfiesPlusMap ? true : false;
global $mapOnly;
$root = 'http://www.iculture.info/saveaselfie/wp-content/themes/storedImages/';

$query = "select * from selfie_info";
$query = "select `key`, `app`, `thumbnail`, `standard`, `user`, X(GPS), Y(GPS), `locationName`, `caption`, `timestamp` from selfie_info ORDER BY timestamp DESC";
$result = doQuery2($query);
checkResult($query, $result);
$count = 0; $imageList = ''; $markerList = '';
while ($row = mysqli_fetch_array($result, MYSQL_ASSOC)) {
	list($div, $marker) = useRowValues($row, $count);
	if ($div) {	$imageList .= "$div\n"; $markerList .= "$marker\n"; $count++; }
	if ($homePageMax) if ($count == $homePageMax) break;
// 	echo "count is $count<br>\n";
}

function useRowValues($row, $count) {
	global $mapOnly, $selfiesPlusMap, $root;
	$latitude = $row['X(GPS)'];
	if ($latitude) {
		$longitude = $row['Y(GPS)'];
		$caption = $row['caption']; $thumb = $root . $row['thumbnail']; $standard_resolution = $root. $row['standard'];
		$app = $row['app']; $user = $row['user']; $key = $row['key']; $timestamp = $row['timestamp'];
		$info1 = "<script>images[$count] = '$standard_resolution'; captions[$count] = '$caption';</script>\n";
		$info2 = "<script>defib[$count]={}; defib[$count]['caption']=\"$caption\"; defib[$count]['address']=\"\"; defib[$count]['lng']=\"$longitude\";" . 
				 " defib[$count]['lat']=\"$latitude\"; defib[$count].thumb = \"$thumb\"; defib[$count].standard_resolution = \"$standard_resolution\"; defib[$count]['type']=\"$app\";</script>\n";
		if ($mapOnly) return array($info1, $info2);
		if ($selfiesPlusMap)
			return array("<div class=\"thumbAndMap\"><div class=\"thumb\"  id=\"thumb$count\" style=\"background-image:url('$thumb');\">" .
							"</div>\n<div id=\"map$count\" class=\"map\"></div><div class=\"xclear\"></div></div>\n" . $info1,  $info2);
			else return array("<div class=\"squareThumb\"  id=\"$count\" style=\"background-image:url('$thumb');\">" .
							"</div>\n" . $info1, $info2);
	} else return array("", ""); 
}

echo "<script>var markerCount = $count; var defib = [];</script>\n";
if (!$mapOnly) echo "<div id=\"instagramHolder\"><div id=\"instagramImages\">$imageList</div><div style='clear:both'></div></div>\n$markerList";
else echo "$imageList\n$markerList";

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