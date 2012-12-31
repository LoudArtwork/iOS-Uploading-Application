<?php 
 Echo "<html>";
 Echo "<title>View Ad</title>";
 
 if(empty($_GET)) 
    echo "No GET variables"; 
 else 
	echo $_GET["ad"];

 Echo "</html>";
?>