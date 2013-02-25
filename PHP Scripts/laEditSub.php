<?php
    $con = mysql_connect("localhost","dienamicmisqlwp","yp5YR053!2g");
    if (!$con)
    {
        die('Could not connect: ' . mysql_error());
    }
    
    mysql_select_db("dienamic2mis", $con);
    
    $sql="UPDATE la_business_info SET active='$_POST[act]' WHERE bid='$_POST[bid]'";
    
    if (!mysql_query($sql,$con))
    {
        die('Error: ' . mysql_error());
    }
    echo "1";
    
    mysql_close($con);
?>