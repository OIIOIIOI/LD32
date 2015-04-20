<?php

$level = $_POST['level'];
$pseudo = $_POST['pseudo'];
$score = $_POST['score'];

require_once "db.php";

$stmt = mysqli_prepare($db, "INSERT INTO LD30 (level, pseudo, score) VALUES (?, ?, ?)");
mysqli_stmt_bind_param($stmt, 'ssd', $level, $pseudo, $score);
mysqli_stmt_execute($stmt);
mysqli_stmt_close($stmt);
mysqli_close($db);

?>