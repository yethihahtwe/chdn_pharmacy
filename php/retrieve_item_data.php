<?php
// add config file to connect to the database
include 'config.php';

// retrieve the device_user_id from the query parameter
$deviceUserId = $_GET['device_user_id'];

// query the tbl_item table based on device_user_id
$result = $db->query("
    SELECT * FROM tbl_item
    WHERE item_cre = '".$deviceUserId."'
");

if ($result && mysqli_num_rows($result) > 0) {
    $itemData = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $itemData[] = $row;
    }
    echo json_encode($itemData);
} else {
    echo json_encode(array("error" => "Item data not found"));
}
?>