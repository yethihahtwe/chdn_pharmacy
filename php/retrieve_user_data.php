<?php
// add config file to connect to the database
include 'config.php';

// retrieve the device_user_id from the query parameter
$deviceUserId = $_GET['device_user_id'];

// query the tbl_device_user table based on device_user_id
$result = $db->query("
    SELECT * FROM tbl_device_user
    WHERE device_user_id = '".$deviceUserId."'
");

if ($result && mysqli_num_rows($result) > 0) {
    $userData = mysqli_fetch_assoc($result);
    echo json_encode($userData);
} else {
    echo json_encode(array("error" => "User data not found"));
}
?>