<?php
    $start = '<iframe width="420" height="315" src="http://';
    $end   = '" frameborder="0" allowfullscreen></iframe>';
    $guts  = $_POST['gut'];
    
    $ad = $start.$guts.$end;
    
    $con = mysql_connect("localhost","dienamicmisqlwp","yp5YR053!2g");
    if (!$con)
    {
        die('Could not connect: ' . mysql_error());
    }
    
    mysql_select_db("dienamic2mis", $con);
    
    $sql="INSERT INTO la_ad_table (bid, con) VALUES ('$_POST[bid]','" . $ad . "') on duplicate key update con = '" . $ad . "'";
    
    if (!mysql_query($sql,$con))
    {
        die('Error: ' . mysql_error());
    }
    
    echo "please work";
    
    mysql_close($con);
    ?>