<?php
// add config file to connect to the database
include 'config.php';

// decode incoming data to json
$data = json_decode(file_get_contents('php://input'), true);
$rows = $data['value'];

// loop through each row
foreach ($rows as $row) {
    $item_type_id = $row['item_type_id'];
    $item_type_name = $row['item_type_name'];
    $item_type_editable = $row['item_type_editable'];
    $item_type_cre = $row['item_type_cre'];
    
    // check whether the online database already has the data
    $selectExits = $db->query("
        SELECT * FROM tbl_item_type
            WHERE
                item_type_id = '".$item_type_id."' AND
                item_type_cre = '".$item_type_cre."'
    ");
    $count = mysqli_num_rows($selectExits);
    if($count > 0){
        $result = $db->query("
            UPDATE tbl_item_type
            SET
                item_type_name = '".$item_type_name."'
            WHERE
                item_type_id = '".$item_type_id."' AND
                item_type_cre = '".$item_type_cre."'
        ");
        if ($result) {
            echo json_encode(array("message"=>"Item Type UPDATE Success"));
        } else{
        echo json_encode(array("message"=>"Item Type UPDATE failed ".mysqli_errno($db)));
        }
    } else {
        $result = $db->query("
            INSERT INTO tbl_item_type (
                item_type_id,
                item_type_name,
                item_type_editable,
                item_type_cre
            ) VALUES (
                '".$item_type_id."',
                '".$item_type_name."',
                '".$item_type_editable."',
                '".$item_type_cre."'
            ) ");
        if ($result) {
                echo json_encode(array("message"=>"Item Type INSERT Success"));
        } else{
                echo json_encode(array("message"=>"Item Type INSERT failed ".mysqli_errno($db)));
        }
    }
}