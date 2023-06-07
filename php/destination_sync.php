<?php
// add config file to connect to the database
include 'config.php';

// decode incoming data to json
$data = json_decode(file_get_contents('php://input'), true);
$rows = $data['value'];

// loop through each row
foreach ($rows as $row) {
    $destination_id = $row['destination_id'];
    $destination_name = $row['destination_name'];
    $destination_editable = $row['destination_editable'];
    $destination_cre = $row['destination_cre'];
    
    // check whether the online database already has the data
    $selectExits = $db->query("
        SELECT * FROM tbl_destination
            WHERE
                destination_id = '".$destination_id."' AND
                destination_cre = '".$destination_cre."'
    ");
    $count = mysqli_num_rows($selectExits);
    if($count > 0){
        $result = $db->query("
            UPDATE tbl_destination
            SET
                destination_name = '".$destination_name."'
            WHERE
                destination_id = '".$destination_id."' AND
                destination_cre = '".$destinationr_cre."'
        ");
        if ($result) {
            echo json_encode(array("message"=>"Destination UPDATE Success"));
        } else{
        echo json_encode(array("message"=>"Destination UPDATE failed ".mysqli_errno($db)));
        }
    } else {
        $result = $db->query("
            INSERT INTO tbl_destination (
                destination_id,
                destination_name,
                destination_editable,
                destination_cre
            ) VALUES (
                '".$destination_id."',
                '".$destination_name."',
                '".$destination_editable."',
                '".$destination_cre."'
            ) ");
        if ($result) {
                echo json_encode(array("message"=>"Destination INSERT Success"));
        } else{
                echo json_encode(array("message"=>"Destination INSERT failed ".mysqli_errno($db)));
        }
    }
}