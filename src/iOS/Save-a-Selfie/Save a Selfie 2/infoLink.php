<?php
$buttonID = $_GET['button'];
$link[0] = 'http://www.orderofmaltaireland.org/';
$link[1] = 'http://saveaselfie.org/';
$link[2] = 'http://irishfireservices.ie/dublin-fire-brigade';
$link[3] = 'http://codeforireland.com/';

echo "<meta http-equiv='refresh' content='0;URL=\"$link[$buttonID]\"'>";
// echo '<span style="font-size:6em;">Loads ' . $link[$buttonID] . ' website</span>';
?>