<?php
    $con = mysql_connect("localhost","dienamicmisqlwp","yp5YR053!2g");
    if (!$con)
    {
        die('Could not connect: ' . mysql_error());
    }
    
    mysql_select_db("dienamic2mis", $con);
    
    $sql="INSERT INTO la_business_info (name, address, city, province, country, postal, email, phone, password, active)
    VALUES
    ('$_POST[nam]','$_POST[add]','$_POST[cit]','$_POST[pro]','$_POST[cou]','$_POST[pos]','$_POST[ema]','$_POST[pho]',SHA1('$_POST[pwd]'), '1')";
    
    if (!mysql_query($sql,$con))
    {
        die('Error: ' . mysql_error());
    }
    
    $sql = "SELECT bid FROM la_business_info WHERE name='$_POST[nam]' AND postal='$_POST[pos]' AND password=SHA1('$_POST[pwd]')";
    $result = mysql_query($sql,$con);
    $row = mysql_fetch_array($result);
    echo $row['bid'];
    
    mysql_close($con);
    ?>