<?php
// add config file to connect to the database
include 'config.php';

// retrieve the device_user_id from the query parameter
$deviceUserId = $_GET['device_user_id'];

// query the tbl_package_form table based on device_user_id
$result = $db->query("
    SELECT * FROM tbl_package_form
    WHERE package_form_cre = '".$deviceUserId."'
");

if ($result && mysqli_num_rows($result) > 0) {
    $packageFormData = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $packageFormData[] = $row;
    }
    echo json_encode($packageFormData);
} else {
    echo json_encode(array("error" => "Package Form data not found"));
}
?>