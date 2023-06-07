<?php
// add config file to connect to the database
include 'config.php';

// decode incoming data to json
$data = json_decode(file_get_contents('php://input'), true);
$rows = $data['value'];

// loop through each row
foreach ($rows as $row) {
    $donor_id = $row['donor_id'];
    $donor_name = $row['donor_name'];
    $donor_editable = $row['donor_editable'];
    $donor_cre = $row['donor_cre'];
    
    // check whether the online database already has the data
    $selectExits = $db->query("
        SELECT * FROM tbl_donor
            WHERE
                donor_id = '".$donor_id."' AND
                donor_cre = '".$donor_cre."'
    ");
    $count = mysqli_num_rows($selectExits);
    if($count > 0){
        $result = $db->query("
            UPDATE tbl_donor
            SET
                donor_name = '".$donor_name."'
            WHERE
                donor_id = '".$donor_id."' AND
                donor_cre = '".$donor_cre."'
        ");
        if ($result) {
            echo json_encode(array("message"=>"Donor UPDATE Success"));
        } else{
        echo json_encode(array("message"=>"Donor UPDATE failed ".mysqli_errno($db)));
        }
    } else {
        $result = $db->query("
            INSERT INTO tbl_donor (
                donor_id,
                donor_name,
                donor_editable,
                donor_cre
            ) VALUES (
                '".$donor_id."',
                '".$donor_name."',
                '".$donor_editable."',
                '".$donor_cre."'
            ) ");
        if ($result) {
                echo json_encode(array("message"=>"Donor INSERT Success"));
        } else{
                echo json_encode(array("message"=>"Donor INSERT failed ".mysqli_errno($db)));
        }
    }
}