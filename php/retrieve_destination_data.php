<?php
// add config file to connect to the database
include 'config.php';

// retrieve the device_user_id from the query parameter
$deviceUserId = $_GET['device_user_id'];

// query the tbl_destination table based on device_user_id
$result = $db->query("
    SELECT * FROM tbl_destination
    WHERE destination_cre = '".$deviceUserId."'
");

if ($result && mysqli_num_rows($result) > 0) {
    $destinationData = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $destinationData[] = $row;
    }
    echo json_encode($destinationData);
} else {
    echo json_encode(array("error" => "Destination data not found"));
}
?>