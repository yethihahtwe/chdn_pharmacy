<?php
// add config file to connect to the database
include 'config.php';

// retrieve the device_user_id from the query parameter
$deviceUserId = $_GET['device_user_id'];

// query the tbl_donor table based on device_user_id
$result = $db->query("
    SELECT * FROM tbl_donor
    WHERE donor_cre = '".$deviceUserId."'
");

if ($result && mysqli_num_rows($result) > 0) {
    $donorData = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $donorData[] = $row;
    }
    echo json_encode($donorData);
} else {
    echo json_encode(array("error" => "Donor data not found"));
}
?>