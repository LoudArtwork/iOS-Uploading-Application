<?php
    $con = mysql_connect("localhost","dienamicmisqlwp","yp5YR053!2g");
    if (!$con)
    {
        die('Could not connect: ' . mysql_error());
    }
    
    mysql_select_db("dienamic2mis", $con);
    
    $sql="UPDATE la_business_info SET name='$_POST[nam]', address='$_POST[add]', city='$_POST[cit]', province='$_POST[pro]', country='$_POST[cou]', postal='$_POST[pos]', email='$_POST[ema]', phone='$_POST[pho]' WHERE bid='$_POST[bid]'";
    
    if (!mysql_query($sql,$con))
    {
        die('Error: ' . mysql_error());
    }
    echo "1";
    
    mysql_close($con);
?>