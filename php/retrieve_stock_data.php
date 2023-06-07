<?php
// add config file to connect to the database
include 'config.php';

// retrieve the device_user_id from the query parameter
$deviceUserId = $_GET['device_user_id'];

// query the tbl_stock table based on device_user_id
$result = $db->query("
    SELECT * FROM tbl_stock
    WHERE stock_cre = '".$deviceUserId."'
");

if ($result && mysqli_num_rows($result) > 0) {
    $stockData = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $stockData[] = $row;
    }
    echo json_encode($stockData);
} else {
    echo json_encode(array("error" => "Stock data not found"));
}
?>