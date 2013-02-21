<?php
    require_once("class-IXR.php");
    $client = new IXR_Client('http://www.loudartwork.com/xmlrpc.php');

    $USER = 'Chippers2';
    $PASS = 'Tegness1';

    
     
    if (!$client->query('my.login',array('Chippers2','Tegness1'))) {
        die( 'Error while creating a new picture' . $client->getErrorCode() ." : ". $client->getErrorMessage());
    }
    echo $client->getResponse();
?>