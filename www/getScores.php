<?php

$lvl = 11;
if (isset($_POST['lvl']))	$lvl = $_POST['lvl'];

require_once "db.php";

$scorePseudo = "Unknown";
$scoreValue = -1;
$timePseudo = "Unknown";
$timeValue = -1;

$stmt = $mysqli->prepare("SELECT pseudo, score FROM leaderboard WHERE level=? ORDER BY score DESC LIMIT 1");
$stmt->bind_param("i", $lvl);
$stmt->execute();
$stmt->bind_result($scorePseudo, $scoreValue);
$stmt->fetch();
$stmt->close();

$stmt = $mysqli->prepare("SELECT pseudo, time FROM leaderboard WHERE level=? ORDER BY time ASC LIMIT 1");
$stmt->bind_param("i", $lvl);
$stmt->execute();
$stmt->bind_result($timePseudo, $timeValue);
$stmt->fetch();
$stmt->close();

$mysqli->close();

echo 'sp='.$scorePseudo.'&sv='.$scoreValue.'&tp='.$timePseudo.'&tv='.$timeValue;

?>