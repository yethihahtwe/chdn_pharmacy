<?php
// add config file to connect to the database
include 'config.php';

// decode incoming data to json
$data = json_decode(file_get_contents('php://input'), true);
$rows = $data['value'];

// loop through each row
foreach ($rows as $row) {
    $stock_id = $row['stock_id'];
    $stock_date = $row['stock_date'];
    $stock_type = $row['stock_type'];
    $stock_item_id = $row['stock_item_id'];
    $stock_package_form_id = $row['stock_package_form_id'];
    $stock_exp_date = $row['stock_exp_date'];
    $stock_batch = $row['stock_batch'];
    $stock_amount = $row['stock_amount'];
    $stock_source_place_id = $row['stock_source_place_id'];
    $stock_donor_id = $row['stock_donor_id'];
    $stock_remark = $row['stock_remark'];
    $stock_to = $row['stock_to'];
    $stock_cre = $row['stock_cre'];
    
    // check whether the online database already has the data
    $selectExits = $db->query("
        SELECT * FROM tbl_stock
            WHERE
                stock_id = '".$stock_id."' AND
                stock_cre = '".$stock_cre."'
    ");
    $count = mysqli_num_rows($selectExits);
    if($count > 0){
        $result = $db->query("
            UPDATE tbl_stock
            SET
                stock_date = '".$stock_date."',
                stock_type = '".$stock_type."',
                stock_item_id= '".$stock_item_id."',
                stock_package_form_id= '".$stock_package_form_id."',
                stock_exp_date= '".$stock_exp_date."',
                stock_batch= '".$stock_batch."',
                stock_amount= '".$stock_amount."',
                stock_source_place_id= '".$stock_source_place_id."',
                stock_donor_id= '".$stock_donor_id."',
                stock_remark= '".$stock_remark."',
                stock_to= '".$stock_to."'
            WHERE
                stock_id = '".$stock_id."' AND
                stock_cre = '".$stock_cre."'
        ");
        if ($result) {
            echo json_encode(array("message"=>"UPDATE Success"));
        } else{
        echo json_encode(array("message"=>"UPDATE failed ".mysqli_errno($db)));
        }
    } else {
        $result = $db->query("
            INSERT INTO tbl_stock (
                stock_id,
                stock_date,
                stock_type,
                stock_item_id,
                stock_package_form_id,
                stock_exp_date,
                stock_batch,
                stock_amount,
                stock_source_place_id,
                stock_donor_id,
                stock_remark,
                stock_to,
                stock_cre
            ) VALUES (
                '".$stock_id."',
                '".$stock_date."',
                '".$stock_type."',
                '".$stock_item_id."',
                '".$stock_package_form_id."',
                '".$stock_exp_date."',
                '".$stock_batch."',
                '".$stock_amount."',
                '".$stock_source_place_id."',
                '".$stock_donor_id."',
                '".$stock_remark."',
                '".$stock_to."',
                '".$stock_cre."'
            ) ");
        if ($result) {
                echo json_encode(array("message"=>"INSERT Success"));
        } else{
                echo json_encode(array("message"=>"INSERT failed ".mysqli_errno($db)));
        }
    }
}