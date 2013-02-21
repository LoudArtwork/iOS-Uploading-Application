<?php
    $con = mysql_connect("localhost","dienamicmisqlwp","yp5YR053!2g");
    if (!$con)
    {
        die('Could not connect: ' . mysql_error());
    }
    
    mysql_select_db("dienamic2mis", $con);
    
    $sql="INSERT INTO la_picture_info (picture_name, bid, first_name, age_group, email)
    VALUES
    ('$_POST[nam]','$_POST[bid]','$_POST[fna]','$_POST[age]','$_POST[ema]')";
    
    if (!mysql_query($sql,$con))
    {
        die('Error: ' . mysql_error());
    }
    
    $last_row_id = mysql_insert_id();
    echo $last_row_id;
    
    mysql_close($con);
    ?>