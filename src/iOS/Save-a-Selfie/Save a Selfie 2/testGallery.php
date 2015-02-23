<div id="floatingBox"><img id="floatingImage" src=""><div id="floatingCaption"></div><div id="floatingMap"></div></div>
<script type='text/javascript' src='http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/float.js'></script>
<script>
	var imageHash = {}, captionHash = {};
</script>
<?php
 
$client_id = "xx"; //your client-id here
 
$tag = "ddefib"; //your tag here
 
$cachefile = "instagram_cache/$tag.cache";
if (file_exists($cachefile) && time()-filemtime($cachefile)<3600) {
$contents = file_get_contents($cachefile);
} else {
$contents = file_get_contents("https://api.instagram.com/v1/tags/$tag/media/recent?client_id=$client_id");
// file_put_contents($cachefile, $contents);
}

$json = json_decode($contents, true);

$i = 0;
$images = ""; $markers = "";
foreach ($json["data"] as $value) {
// 	if ($i == 0) { echo "<pre>"; print_r($value); echo "</pre>\n"; }
	list($div, $marker) = echoimage($value, $i);
	if ($div) {	$images[$i] = "$div\n"; $markers[$i] = "$marker\n"; $i++; }
// 	if ($limitTo16) if ($i == 16) break;
}
$i--;

function echoimage($value, $i) {

	global $dates;
	global $selfiesPlusMap;
	global $mapOnly;

//   echo "instagram: <pre>"; print_r($value); echo "</pre>\n";
 
  $thumb = $value["images"]["thumbnail"]["url"];
  $standard_resolution = $value["images"]["standard_resolution"]["url"];
  $link = $value["link"];
  $time = date("d/m/y", $value["created_time"]);
  $nick = $value["user"]["username"];
  $avatar = $value["user"]["profile_picture"];
  $latitude = $value['location']['latitude'];
  $longitude = $value['location']['longitude'];
  $locationName = $value['location']['name'];
  $caption = $value['caption']['text']; $caption = str_replace("'", "\'", $caption);
//   echo "instagram date: " . $value['created_time'] . ", " . date('YmdHis', $value['created_time']) . "<br>\n";
  $datetime = date('YmdHis', $value['created_time']);
  $dates[$i] = $datetime;
  
  if ($latitude) {
	$info1 = "<script>imageHash[\"#!x!=!\"] = '$standard_resolution'; captionHash[\"#!x!=!\"] = '$caption';</script>\n";
	$info2 = "<script>defib[!x!=!]={}; defib[!x!=!]['caption']=\"$caption\"; defib[!x!=!]['address']=\"\"; defib[!x!=!]['lng']=\"$longitude\"; defib[!x!=!]['lat']=\"$latitude\"; defib[!x!=!].thumb = \"$thumb\"; defib[!x!=!].standard_resolution = \"$standard_resolution\"; defib[!x!=!]['type']=\"instagram\";</script>\n";
  	if ($mapOnly) return array($info1, $info2);
  	if ($selfiesPlusMap)
		return array("<div class=\"thumbAndMap\"><div class=\"thumb\"  id=\"!x!=!\" style=\"background-image:url('$thumb');\">" .
						"</div>\n<div id=\"map!x!=!\" class=\"map\"></div><div class=\"xclear\"></div></div>\n" . $info1,  $info2);
		else return array("<div class=\"squareThumb\"  id=\"!x!=!\" style=\"background-image:url('$thumb');\">" .
						"</div>\n" . $info1, $info2);
  	} else return array("", ""); 
}

// now Twitter!

// using @urapp4it and Fire Brigade app in Twitter developer

require get_stylesheet_directory() . '/Twitter-php/RestApi.php';

$consumerKey = 'xx';
$consumerSecret = 'xx';
$accessToken = 'xx';
$accessTokenSecret = 'xx';

$twitter = new \TwitterPhp\RestApi($consumerKey,$consumerSecret,$accessToken,$accessTokenSecret);
$connection = $twitter->connectAsApplication();
// $tweets = $connection->get('search/tweets', array('q'=>'from:urapp4it filter:images','include_entities'=>1));
$tweets = $connection->get('search/tweets', array('q'=>'#ddefib filter:images','include_entities'=>1, 'count'=>100));

$ip = $_SERVER['REMOTE_ADDR'];
// echo "<pre>"; print_r($tweets['statuses']); echo "</pre>\n";

// $images .= "
// </div>
// <div id=\"twitterImages\"><h1>Using Twitter<br>with #ddefib</h1>
// ";
$first = true;
foreach ($tweets['statuses'] as $tweet) {

	$caption = $tweet['text']; $caption = preg_replace('/ http:.*$/', '', $caption); $caption = str_replace("'", "\'", $caption);

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
			
	$datetime = new DateTime($tweet['created_at']);
	$datetime->setTimezone(new DateTimeZone('UTC'));
	$datetime = $datetime->format('YmdHis');
// 	echo "timestamp: $datetime<br>\n";

	$image = $tweet['entities']['media'][0]['media_url'] . ':thumb';
// 	echo "<img src=\"$image\"><br>\n";
	$coords = $tweet['geo']['coordinates'];
	$latitude = $coords[0];
	$longitude = $coords[1];
	$uploadedBy = $tweet['user']['name'] . ' (@' . $tweet['user']['screen_name'] . ')';
// 	if ($latitude != '') {
// 		$i++;
// // 		echo "Coords for $i are $latitude, $longitude<br>\n";
// 	  	$images .= 	"<div class=\"twThumb\" id=\"twThumb$i\"" .
// 	  				"style=\"background-image:url('$image:small'); background-size:cover; background-repeat:no-repeat;\">" .
// 	  				"</div>\n<div id=\"map$i\" class=\"twitterMap\"></div><div class=\"clear\"></div>\n" .
// 	  				"<script>imageHash[\"#twThumb$i\"] = '$image'; captionHash[\"#twThumb$i\"] = '$caption';</script>\n";
// 	  	$markers .= "defib[$i]={}; defib[$i]['caption']=\"$caption\"; defib[$i]['address']=\"\"; defib[$i]['lng']=\"$longitude\"; defib[$i]['lat']=\"$latitude\"; defib[$i]['type']=\"twitter\";\n";

  if ($latitude) {
	$dates[$i] = $datetime;
	$info1 = "<script>imageHash[\"#!x!=!\"] = '$image'; captionHash[\"#!x!=!\"] = '$caption';</script>\n";
	$info2 = "<script>defib[!x!=!]={}; defib[!x!=!]['caption']=\"$caption\"; defib[!x!=!]['address']=\"\"; defib[!x!=!]['lng']=\"$longitude\"; defib[!x!=!]['lat']=\"$latitude\"; defib[!x!=!].thumb = \"$image\"; defib[!x!=!].standard_resolution = \"$image\"; defib[!x!=!]['type']=\"twitter\";</script>\n";
  	if ($mapOnly) {
  		$images[$i] ="$info1\n"; $markers[$i] = "$info2\n";
  	} else {
		if ($selfiesPlusMap) {
				$images[$i] = "<div class=\"thumbAndMap\"><div class=\"thumb\"  id=\"!x!=!\" style=\"background-image:url('$image');\">" .
							"</div>\n<div id=\"map!x!=!\" class=\"map\"></div><div class=\"xclear\"></div></div>\n" . $info1;
				$markers[$i] = $info2;
			} else {
				$images[$i]  = "<div class=\"squareThumb\"  id=\"!x!=!\" style=\"background-image:url('$image');\"></div>\n" . $info1;
				$markers[$i]  = $info2;
			}
		}
	
		if ($first) {
// 			$first = false;
//	 		echo "<pre>"; print_r($tweet); echo "</pre>\n";

			$url = 'xx';
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

	} // else echo "Not using! ($latitude)<br>\n";
}

// echo "count is $i<br>\n";
arsort($dates);
$imageList = ''; $markerList = ''; $count = 0;
foreach ($dates as $key => $val) {
//     echo "$key = $val (" . $images[$key] . ")<br>\n";
    $img = str_replace('!x!=!', 'thumb' . $count, $images[$key]);
	$imageList .= $img;
	$mk = str_replace('!x!=!', $count,$markers[$key]);
	$markerList .= $mk;
	$count++; if ($count == 24) break;
}

echo "<script>var markerCount = $count; var defib = [];</script>\n";
if (!$mapOnly) echo "<div id=\"instagramImages\">$imageList</div><div style='clear:both'></div>\n$markerList";
else echo "$imageList\n$markerList";

// <script>
// $markers
// 
// for (var i = 0; i <= $i; i++) oneMap(i, ''); 
// var markerCount = $i;
// 
// </script>
// ";
?>