<?php
define('DB_NAME', 'xxx');

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

$connection = '';
$root = '/httpcocs/wp/wp-content/themes/storedImages/';
$images = ""; $markers = "";
$date = date('m/d/Y h:i:s a', time());
echo "Date and time: $date<br><br>\n";

if (htmlspecialchars($_GET['k']) == 'y') { // clear directory and database table
	echo "Clearing directory and database table<br>\n";
	array_map('unlink', glob($root . "*"));
	$connection = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD) or die ("unable to connect to database");
	$result = mysqli_query($connection, "use " . DB_NAME);
	countRows('Before');
	$query = "TRUNCATE `selfie_info`";
// 	echo "query is $query<br>\n";
	$result = doQuery2($query);
	checkResult($query, $result);
	countRows('After');
}

function countRows($beforeAfter) {
	global $connection; if ($connection == '') return;
	$query = "select count(*) from selfie_info"; $result = doQuery2($query); checkResult($query, $result);
	while ($row = mysqli_fetch_array($result, MYSQL_ASSOC)) {
		echo "$beforeAfter: there are " . $row['count(*)'] . " records in database.<br>\n";
	}
}

error_reporting(E_ALL);
// ini_set("display_errors", 1);

function instagram($tag) {
	$client_id = "0264b9f6f1a9486aae10a2e5151caa15"; //your client-id here
	$contents = file_get_contents("https://api.instagram.com/v1/tags/$tag/media/recent?client_id=$client_id");
	$json = json_decode($contents, true);
	foreach ($json["data"] as $value) {
		getInstagramData($value);
	}
}

instagram('ddefib'); instagram('saveaselfie');

function getInstagramData($value) {

	global $dates;
	global $selfiesPlusMap;
	global $mapOnly;
	global $connection;
	global $root;

//   if ($i == 0) { echo "instagram: <pre>"; print_r($value); echo "</pre>\n"; } else return;
 
  $latitude = $value['location']['latitude'];
  if ($latitude) {
	$thumb = $value["images"]["thumbnail"]["url"];
	$parts = explode('/', $thumb); // echo "instagram: <pre>"; print_r($parts); echo "</pre>\n";
	$localThumb = $parts[count($parts) - 1];
// 	$caption = mysqli_real_escape_string($connection, $value['caption']['text']);
	$caption = str_replace("'", "\'", $value['caption']['text']);
  	if (file_exists($root . $localThumb)) { echo "Instagram: $root$localThumb exists!<br>\n"; } else {
	//   echo "instagram date: " . $value['created_time'] . ", " . date('YmdHis', $value['created_time']) . "<br>\n";
	$datetime = date('YmdHis', $value['created_time']);
	$longitude = $value['location']['longitude'];
	$locationName = mysqli_real_escape_string($connection, $value['location']['name']); 
	$key = str_replace('_s.jpg', '', $parts[count($parts) - 1]);
	//   echo "key: $key<br>\n";
	$standard_resolution = $value["images"]["standard_resolution"]["url"];
	$link = $value["link"];
	$time = date("d/m/y", $value["created_time"]);
	$nick = $value["user"]["username"];
	$avatar = $value["user"]["profile_picture"];
  	$imageString = file_get_contents($thumb); $save = file_put_contents($root . $localThumb, $imageString);
	echo "$save bytes saved to $localThumb<br>\n";
	$localNormal = str_replace('_s.jpg', '_n.jpg', $localThumb);
	$imageString = file_get_contents($standard_resolution); $save = file_put_contents($root . $localNormal, $imageString);
	echo "$save bytes saved to $localNormal<br>\n";
	if ($connection == '') {
		$connection = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD) or die ("unable to connect to database");
		$result = mysqli_query($connection, "use " . DB_NAME);
		countRows('Before');
	}
	$query = "REPLACE INTO selfie_info (`key`, `app`, `thumbnail`, `standard`, `user`, `GPS`, `locationName`, `caption`, `timestamp`) " . 
			"VALUES ('$key', 'inst', '$localThumb', '$localNormal', '$nick', GeomFromText( 'POINT($latitude $longitude)'), '$locationName', '$caption', '$datetime')";
// 	echo "query is $query<br>\n";
	$result = doQuery2($query);
	checkResult($query, $result);
  	}  
  } else { echo "Not using! - no latitude (" . $value['caption']['text'] . ")<br>\n"; } // echo "<pre>"; print_r($value); echo "</pre>\n"; }
}

// while($row = mysqli_fetch_array($result, MYSQL_ASSOC)) {
// 	if ($row['post_title'] == 'Auto Draft') continue;
// }

// now Twitter!
// using @urapp4it and Fire Brigade app in Twitter developer

include '/httpdocs/wp/wp-content/themes/magazine-child/Twitter-php/RestApi.php';
// echo E_WARNING;


// created using urapp4it Twitter account
$consumerKey = 'xx';
$consumerSecret = 'xx';
$accessToken = 'xx';
$accessTokenSecret = 'xx';

$twitter = new \TwitterPhp\RestApi($consumerKey,$consumerSecret,$accessToken,$accessTokenSecret);
$twitterConnection = $twitter->connectAsApplication();
// $tweets = $connection->get('search/tweets', array('q'=>'from:urapp4it filter:images','include_entities'=>1));
$tweets1 = $twitterConnection->get('search/tweets', array('q'=>'#ddefib filter:images','include_entities'=>1, 'count'=>100));
$tweets2 = $twitterConnection->get('search/tweets', array('q'=>'#saveaselfie filter:images','include_entities'=>1, 'count'=>100));
$tweets = array_merge($tweets1, $tweets2);
$ip = $_SERVER['REMOTE_ADDR'];
// echo "tweets2: <pre>"; print_r($tweets2); echo "</pre>\n";

// $images .= "
// </div>
// <div id=\"twitterImages\"><h1>Using Twitter<br>with #ddefib</h1>
// ";
$first = true;
foreach ($tweets['statuses'] as $tweet) {

// 	if ($first) {
// 	if ($first) {
echo "twitter: <pre>"; print_r($tweet); echo "</pre>\n"; // break; }

  $key = $tweet['id']; // echo "Key: $key<br>\n";
  $coords = $tweet['geo']['coordinates'];
  $latitude = $coords[0];
  $caption = $tweet['text']; $caption = preg_replace('/ http:.*$/', '', $caption);
  $caption = str_replace("'", "\'", $caption);
//   echo "<br>Caption is $caption------\n";
//   $caption = mysqli_real_escape_string($connection, $caption);
  if ($latitude) {

			// https://dev.twitter.com/overview/api/entities-in-twitter-objects:
			// We support different sizes: thumb, small, medium and large. The
			// media_url
			// defaults to medium but you can retrieve the media in different sizes by appending a colon + the size key (for example:
			// http://pbs.twimg.com/media/A7EiDWcCYAAZT1D.jpg:thumb
			// )
			
			// format for date / time:
			// [created_at] => Mon Sep 29 20:13:00 +0000 2014
			// e.g., $datetime = $tweet['created_at'];
			//
			// http://stackoverflow.com/questions/6823537/best-way-to-change-twitter-api-datetimes-to-a-timestamp:
			// $datetime = new DateTime("Mon Jul 25 05:51:34 +0000 2011");
			// $datetime->setTimezone(new DateTimeZone('Europe/Zurich'));
			// echo $datetime->format('U');

	$image = $tweet['entities']['media'][0]['media_url'];
	$parts = explode('/', $image); // echo "instagram: <pre>"; print_r($parts); echo "</pre>\n";
   	$localThumb = $parts[count($parts) - 1];
   	$localThumb = str_replace('.jpg', '_thumb.jpg', $localThumb);
  	if (file_exists("$root$localThumb")) { echo "Twitter: $root$localThumb exists!<br>\n"; } else {
		$datetime = new DateTime($tweet['created_at']);
		$datetime->setTimezone(new DateTimeZone('UTC'));
		$datetime = $datetime->format('YmdHis');
		$longitude = $coords[1];
// 		echo "<br>uploadedBy: " . $tweet['user']['name'] . ' (' . $tweet['user']['screen_name'] . ')';
// 		$uploadedBy = mysqli_real_escape_string($connection, $tweet['user']['name'] . ' (@' . $tweet['user']['screen_name'] . ')');
		$uploadedBy = $tweet['user']['name'] . ' (@' . $tweet['user']['screen_name'] . ')';
		echo "<br>uploadedBy: $uploadedBy\n";
	// 	echo "timestamp: $datetime<br>\n";
		$thumb = $image . ':thumb';
		$standard_resolution = $image . ':medium';
	// 	echo "<img src=\"$image\"><br>\n";
	  	$imageString = file_get_contents($thumb); $save = file_put_contents($root . $localThumb, $imageString);
		echo "$save bytes saved to $localThumb<br>\n";
		$localNormal = str_replace('_thumb.jpg', '_medium.jpg', $localThumb);
	  	$imageString = file_get_contents($standard_resolution); $save = file_put_contents($root . $localNormal, $imageString);
		echo "$save bytes saved to $localNormal<br>\n";
		if ($connection == '') {
			$connection = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD) or die ("unable to connect to database");
			$result = mysqli_query($connection, "use " . DB_NAME);
			countRows('Before');
		}
		$query = "REPLACE INTO selfie_info (`key`, `typeOfObject`, `app`, `thumbnail`, `standard`, `user`, `GPS`, `locationName`, `caption`, `timestamp`)" . 
				 " VALUES ('$key', 0, 'twit', '$localThumb', '$localNormal', '$uploadedBy', GeomFromText( 'POINT($latitude $longitude)'), '', '$caption', '$datetime')";
// 		echo "query is $query<br>\n";
		$result = doQuery2($query);
		checkResult($query, $result);

		if ($first) {
			// now send info to http://gunfire.becquerel.org/entries/create/
			// from http://stackoverflow.com/questions/5647461/how-do-i-send-a-post-request-with-php
			$url = 'http://gunfire.becquerel.org/entries/create/';
			$encoded_image = base64_encode(file_get_contents($image));
			$encoded_thumb = base64_encode(file_get_contents($image . ':thumb'));  // ':small' also an option for image
			$data = array('comment' => $caption, 'latitude' => $latitude, 'longitude' => $longitude,
					'thumbnail' => $encoded_thumb, 'image' => $encoded_image,
					'uploadedby' => $uploadedBy);
			// use key 'http' even if you send the request to https://...
			$options = array(
				'http' => array(
					'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
					'method'  => 'POST',
					'content' => http_build_query($data),
				),
			);
// 			$context  = stream_context_create($options);
// 			$result = file_get_contents($url, false, $context);
		}
// 		var_dump($result);

		$i++;
	}

	} else echo "Not using! – no latitude ($caption)<br>\n";

}

if ($connection != '') {
	$query = "delete from selfie_info where (`key`='')";
	// 	echo "query is $query<br>\n";
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

// $token = $_GET['t'];


?>
