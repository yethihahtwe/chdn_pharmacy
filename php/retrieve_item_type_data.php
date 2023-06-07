<?php
// add config file to connect to the database
include 'config.php';

// retrieve the device_user_id from the query parameter
$deviceUserId = $_GET['device_user_id'];

// query the tbl_item_type table based on device_user_id
$result = $db->query("
    SELECT * FROM tbl_item_type
    WHERE item_type_cre = '".$deviceUserId."'
");

if ($result && mysqli_num_rows($result) > 0) {
    $itemTypeData = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $itemTypeData[] = $row;
    }
    echo json_encode($itemTypeData);
} else {
    echo json_encode(array("error" => "Item Type data not found"));
}
?>