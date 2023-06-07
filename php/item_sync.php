<?php
// add config file to connect to the database
include 'config.php';

// decode incoming data to json
$data = json_decode(file_get_contents('php://input'), true);
$rows = $data['value'];

// loop through each row
foreach ($rows as $row) {
    $item_id = $row['item_id'];
    $item_name = $row['item_name'];
    $item_type = $row['item_type'];
    $item_editable = $row['item_editable'];
    $item_cre = $row['item_cre'];
    
    // check whether the online database already has the data
    $selectExits = $db->query("
        SELECT * FROM tbl_item
            WHERE
                item_id = '".$item_id."' AND
                item_cre = '".$item_cre."'
    ");
    $count = mysqli_num_rows($selectExits);
    if($count > 0){
        $result = $db->query("
            UPDATE tbl_item
            SET
                item_name = '".$item_name."',
                item_type = '".$item_type."'
            WHERE
                item_id = '".$item_id."' AND
                item_cre = '".$item_cre."'
        ");
        if ($result) {
            echo json_encode(array("message"=>"Item UPDATE Success"));
        } else{
        echo json_encode(array("message"=>"Item UPDATE failed ".mysqli_errno($db)));
        }
    } else {
        $result = $db->query("
            INSERT INTO tbl_item (
                item_id,
                item_name,
                item_type,
                item_editable,
                item_cre
            ) VALUES (
                '".$item_id."',
                '".$item_name."',
                '".$item_type."',
                '".$item_editable."',
                '".$item_cre."'
            ) ");
        if ($result) {
                echo json_encode(array("message"=>"Item INSERT Success"));
        } else{
                echo json_encode(array("message"=>"Item INSERT failed ".mysqli_errno($db)));
        }
    }
}