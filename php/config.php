<?php
	$db = mysqli_connect("localhost","ehssgorg_chdn_pharmacy","L8wnYuphePbjWUV","ehssgorg_chdn_pharmacy");
	if (!$db) {
		echo "Database Connect Error ".mysqli_error($db);
	} else {
	    echo "Database connection established";
	}
?>