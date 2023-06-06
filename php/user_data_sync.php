<?php
// add config file to connect to the database
include 'config.php';

// decode incoming data to json
$data = json_decode(file_get_contents('php://input'), true);
$userData = $data['userData'];

// process user data
$deviceUserId = $userData['device_user_id'];
$deviceUserName = $userData['device_user_name'];
$deviceUserTownship = $userData['device_user_township'];
$deviceUserVillage = $userData['device_user_village'];
$deviceUserWarehouse = $userData['device_user_warehouse'];

// Check if the user already exists in tbl_device_user
$selectExits = $db->query("
    SELECT * FROM tbl_device_user
    WHERE device_user_id = '".$deviceUserId."'
");
$count = mysqli_num_rows($selectExits);
if ($count > 0) {
    $result = $db->query("
    UPDATE tbl_device_user
    SET
        device_user_name = '".$deviceUserName."',
        device_user_township = '".$deviceUserTownship."',
        device_user_village = '".$deviceUserVillage."',
        device_user_warehouse = '".$deviceUserWarehouse."'
    WHERE
        device_user_id = '".$deviceUserId."'
    ");
    if ($result) {
        echo json_encode(array("message" => "User data updated successfully"));
    } else {
        echo json_encode(array("message" => "User data update failed"));
    }
} else {
    // insert user if not exists
    $result = $db->query("
        INSERT INTO tbl_device_user (
            device_user_id,
            device_user_name,
            device_user_township,
            device_user_village,
            device_user_warehouse
        ) VALUES (
            '".$deviceUserId."',
            '".$deviceUserName."',
            '".$deviceUserTownship."',
            '".$deviceUserVillage."',
            '".$deviceUserWarehouse."'
        )
    ");
    if ($result) {
        echo json_encode(array("message" => "User data inserted successfully"));
    } else {
        echo json_encode(array("message" => "User data insert failed"));
    }
}