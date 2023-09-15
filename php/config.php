<?php
	$db = mysqli_connect("localhost","theUserName","password","databaseName");
	if (!$db) {
		echo "Database Connect Error ".mysqli_error($db);
	}
?>
