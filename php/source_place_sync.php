<?php
// add config file to connect to the database
include 'config.php';

// decode incoming data to json
$data = json_decode(file_get_contents('php://input'), true);
$rows = $data['value'];

// loop through each row
foreach ($rows as $row) {
    $source_place_id = $row['source_place_id'];
    $source_place_name = $row['source_place_name'];
    $source_place_editable = $row['source_place_editable'];
    $source_place_cre = $row['source_place_cre'];
    
    // check whether the online database already has the data
    $selectExits = $db->query("
        SELECT * FROM tbl_source_place
            WHERE
                source_place_id = '".$source_place_id."' AND
                source_place_cre = '".$source_place_cre."'
    ");
    $count = mysqli_num_rows($selectExits);
    if($count > 0){
        $result = $db->query("
            UPDATE tbl_source_place
            SET
                source_place_name = '".$source_place_name."'
            WHERE
                source_place_id = '".$source_place_id."' AND
                source_place_cre = '".$source_place_cre."'
        ");
        if ($result) {
            echo json_encode(array("message"=>"Source Place UPDATE Success"));
        } else{
        echo json_encode(array("message"=>"Source Place UPDATE failed ".mysqli_errno($db)));
        }
    } else {
        $result = $db->query("
            INSERT INTO tbl_source_place (
                source_place_id,
                source_place_name,
                source_place_editable,
                source_place_cre
            ) VALUES (
                '".$source_place_id."',
                '".$source_place_name."',
                '".$source_place_editable."',
                '".$source_place_cre."'
            ) ");
        if ($result) {
                echo json_encode(array("message"=>"Source Place INSERT Success"));
        } else{
                echo json_encode(array("message"=>"Source Place INSERT failed ".mysqli_errno($db)));
        }
    }
}