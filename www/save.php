<?php

/*$level = 42;
$pseudo = '';
switch (rand(0, 2)) {
	case 0:
		$pseudo .= 'JOE_';
		break;
	case 1:
		$pseudo .= 'BILLY_';
		break;
	case 2:
		$pseudo .= 'JESSY_';
		break;
}
switch (rand(0, 2)) {
	case 0:
		$pseudo .= 'DALTON_';
		break;
	case 1:
		$pseudo .= 'THE_KID_';
		break;
	case 2:
		$pseudo .= 'JAMES_';
		break;
}
$pseudo .= rand(0, 99);
$score = rand(0, 999999);
$time = rand(0, 999999);*/

$level = $_POST['level'];
$pseudo = $_POST['pseudo'];
$score = $_POST['score'];
$time = $_POST['time'];

require_once "db.php";

$stmt = $mysqli->prepare("INSERT INTO leaderboard (level, pseudo, score, time) VALUES (?, ?, ?, ?)");
$stmt->bind_param("isii", $level, $pseudo, $score, $time);
$stmt->execute();
$stmt->close();
$mysqli->close();

echo 'r=ok';

?>