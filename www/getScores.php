<?php

$lvl = $_GET['lvl'];

require_once "db.php";

// Prepare and execute statement
$stmt = mysqli_prepare($db, "SELECT pseudo, score FROM scores WHERE level=? ORDER BY score LIMIT 10");
mysqli_stmt_bind_param($stmt, 's', $lvl);
mysqli_stmt_execute($stmt);

mysqli_stmt_bind_result($stmt, $r_pseudo, $r_score);
$init = false;
while (mysqli_stmt_fetch($stmt)) {
	if (!$init) {
		echo '
			<tr>
				<th align="left">PSEUDO</th>
				<th align="right">SCORE</th>
			</tr>
		';
		$init = true;
	}
	echo '
		<tr>
			<td align="left">'.$r_pseudo.'</td>
			<td align="right">'.$r_score.'</td>
		</tr>
	';
}

mysqli_stmt_close($stmt);

function getName ($l) {
	switch ($l) {
		case "LBeluga":		return "Bebop Beluga";
		case "LBoat":		return "Rainbow Tanker";
		case "LClam":		return "Drunken Clam";
		case "LEel":		return "Golden Eel";
		case "LJellyfish":	return "Jealous Jellyfish";
		case "LOtter":		return "One-eyed Otter";
		case "LRusty":		return "Rusty Tuna Can";
		case "LSeagull":	return "Seven Seagull";
		case "LShark":		return "Neurasthenic Shark";
		case "LSpliff":		return "Sea Weed Spliff";
		case "LSquid":		return "Kinky Squid";
		case "LWalrus":		return "Toothless Walrus";
		default:			return "--";
	}
}

?>