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

$query = 'SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO"';
$result = doQuery2($query);
checkResult($query, $result);

$query = 'SET time_zone = "+00:00"';
$result = doQuery2($query);
checkResult($query, $result);

$query = 'DROP TABLE `selfie_info`';
$result = doQuery2($query);
checkResult($query, $result);

$query = "
CREATE TABLE IF NOT EXISTS `selfie_info` (
  `key` varchar(40) NOT NULL DEFAULT '',
  `typeOfObject` int(11) NOT NULL DEFAULT '0',
  `app` varchar(4) NOT NULL,
  `thumbnail` tinytext NOT NULL,
  `standard` tinytext CHARACTER SET utf8 NOT NULL,
  `user` tinytext NOT NULL,
  `GPS` point NOT NULL,
  `locationName` tinytext NOT NULL,
  `caption` mediumtext NOT NULL,
  `timestamp` varchar(14) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `key` (`key`),
  KEY `timestamp` (`timestamp`),
  KEY `typeOfObject` (`typeOfObject`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8";
$result = doQuery2($query);
checkResult($query, $result);

$values = 
"('1208337_703231743090259_444708682', 2, 'inst', '1208337_703231743090259_444708682_s.jpg', '1208337_703231743090259_444708682_n.jpg', 'saveaselfie', '\0\0\0\0\0\0\0sŒI|³J@:xQ´¥\ZÀ', '', '#saveaselfie Ballymun sports centre in reception balbutcher lane', '20141007193443'),
('10723814_706488429426172_154813628', 3, 'inst', '10723814_706488429426172_154813628_s.jpg', '10723814_706488429426172_154813628_n.jpg', 'saveaselfie', '\0\0\0\0\0\0\0ÃÃTŽ«J@ñ,³›(üÀ', '', 'Located at reception ground floor national maternity hospital #saveaselfie', '20141007203427'),
('929242_785154024859430_1836683815', 1, 'inst', '929242_785154024859430_1836683815_s.jpg', '929242_785154024859430_1836683815_n.jpg', 'saveaselfie', '\0\0\0\0\0\0\0Õçj+ö±J@àJvl2À', '', '#saveaselfie located by the check outs in super value , finglas village', '20141010101352'),
('525598143401193472', 0, 'twit', 'B0tMrfYCcAADI7__thumb.jpg', 'B0tMrfYCcAADI7__medium.jpg', '', '\0\0\0\0\0\0\0k¹£¬J@sÀ', '', 'Located at the main entrance to Jervis Street shopping centre #saveaselfie', '20141024104217'),
('527890238958751744', 0, 'twit', 'B1NxXUrCMAA9-yd_thumb.jpg', 'B1NxXUrCMAA9-yd_medium.jpg', 'Save A Selfie (@saveaselfie)', '\0\0\0\0\0\0\0={ô§‰«J@}ÙrôñÀ', '', '@HannahDotYoung #saveaselfie located in Gordon house near reception!', '20141030183015'),
('527891561422798848', 0, 'twit', 'B1NykYRIAAAmXuG_thumb.jpg', 'B1NykYRIAAAmXuG_medium.jpg', '', '\0\0\0\0\0\0\0D\"er‡«J@ÞìæòÀ', '', '@bplump #saveaselfie Gordon house', '20141030183530'),
('549226107053289473', 0, 'twit', 'B58-MdRIQAInTvE_thumb.jpg', 'B58-MdRIQAInTvE_medium.jpg', 'Save A Selfie (@saveaselfie)', '\0\0\0\0\0\0\0ûÛñhÛ¯J@küÛÈéÀ', '', 'Life ring by the bridge in the botanic gardens dublin #saveaselfie', '20141228153122'),
('20150122113402', 0, 'ipho', 'ip20150122113402_s.jpg', 'ip20150122113402_m.jpg', '', '\0\0\0\0\0\0\0E·^Óƒ¢J@8½‹÷\"À', '', 'At Galway Museum', '20150122113422'),
('560081661174751232', 0, 'twit', 'B8XPSw3CAAIkms5_thumb.jpg', 'B8XPSw3CAAIkms5_medium.jpg', 'Save A Selfie (@saveaselfie)', '\0\0\0\0\0\0\0kDQ«J@]hS\ZÖ]À', '', '#saveaselfie aed located in reception of emergency care office', '20150127142728'),
('20150128171542', 0, 'ipho', 'ip20150128171542_s.jpg', 'ip20150128171542_m.jpg', '', '\0\0\0\0\0\0\0‹Åo\n+¥J@ÜN^ôÀ', '', 'At the side door between church and church hall, Taney church', '20150128171659'),
('562940772727947264', 0, 'twit', 'B8_3nu3IYAEpr7j_thumb.jpg', 'B8_3nu3IYAEpr7j_medium.jpg', 'Save A Selfie (@saveaselfie)', '\0\0\0\0\0\0\0<ñ¤žh«J@À±%³“0À', '', '#saveaselfie located outside the main doors of the A and E at St James''s hospital', '20150204114833'),
('563307462854737920', 0, 'twit', 'B9E02YSIIAACMpS_thumb.jpg', 'B9E02YSIIAACMpS_medium.jpg', 'Save A Selfie (@saveaselfie)', '\0\0\0\0\0\0\0™ÿ,í¬J@•¯6Œ£À', '', 'Ã¢â‚¬Å“@therevprev: @saveaselfie located in @DubFireBrigade workshops  #saveaselfie', '20150205120539'),
('564524968537763840', 0, 'twit', 'B9WYdqhIYAAn0F-_thumb.jpg', 'B9WYdqhIYAAn0F-_medium.jpg', 'Save A Selfie (@saveaselfie)', '\0\0\0\0\0\0\0 ”ƒ¸ö±J@ÑPŠóÃ6À', '', 'Located in the kitchen of finglas fire station #saveaselfie', '20150208204335'),
";

$values = explode("),\n", $values);
echo "There are " . count($values) . " rows<br>\n";
foreach ($values as $v) {
	if ($v == '') continue;
	$v = $v . ')';
	$query = "INSERT INTO `selfie_info` (`key`, `typeOfObject`, `app`, `thumbnail`, `standard`, `user`, `GPS`, `locationName`, `caption`, `timestamp`) VALUES $v";
	echo "query is $query<br>\n";
	$result = doQuery2($query);
	checkResult($query, $result);
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