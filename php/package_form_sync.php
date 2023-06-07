<?php
// add config file to connect to the database
include 'config.php';

// decode incoming data to json
$data = json_decode(file_get_contents('php://input'), true);
$rows = $data['value'];

// loop through each row
foreach ($rows as $row) {
    $package_form_id = $row['package_form_id'];
    $package_form_name = $row['package_form_name'];
    $package_form_editable = $row['package_form_editable'];
    $package_form_cre = $row['package_form_cre'];
    
    // check whether the online database already has the data
    $selectExits = $db->query("
        SELECT * FROM tbl_package_form
            WHERE
                package_form_id = '".$package_form_id."' AND
                package_form_cre = '".$package_form_cre."'
    ");
    $count = mysqli_num_rows($selectExits);
    if($count > 0){
        $result = $db->query("
            UPDATE tbl_package_form
            SET
                package_form_name = '".$package_form_name."'
            WHERE
                package_form_id = '".$package_form_id."' AND
                package_form_cre = '".$package_form_cre."'
        ");
        if ($result) {
            echo json_encode(array("message"=>"Package Form UPDATE Success"));
        } else{
        echo json_encode(array("message"=>"Package Form UPDATE failed ".mysqli_errno($db)));
        }
    } else {
        $result = $db->query("
            INSERT INTO tbl_package_form (
                package_form_id,
                package_form_name,
                package_form_editable,
                package_form_cre
            ) VALUES (
                '".$package_form_id."',
                '".$package_form_name."',
                '".$package_form_editable."',
                '".$package_form_cre."'
            ) ");
        if ($result) {
                echo json_encode(array("message"=>"Package Form INSERT Success"));
        } else{
                echo json_encode(array("message"=>"Package Form INSERT failed ".mysqli_errno($db)));
        }
    }
}