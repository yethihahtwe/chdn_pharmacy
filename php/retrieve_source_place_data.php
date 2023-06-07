<?php
// add config file to connect to the database
include 'config.php';

// retrieve the device_user_id from the query parameter
$deviceUserId = $_GET['device_user_id'];

// query the tbl_source_place table based on device_user_id
$result = $db->query("
    SELECT * FROM tbl_source_place
    WHERE source_place_cre = '".$deviceUserId."'
");

if ($result && mysqli_num_rows($result) > 0) {
    $sourcePlaceData = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $sourcePlaceData[] = $row;
    }
    echo json_encode($sourcePlaceData);
} else {
    echo json_encode(array("error" => "Source Place data not found"));
}
?>