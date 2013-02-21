<?php
    require_once("class-IXR.php");
    $client = new IXR_Client('http://www.loudartwork.com/xmlrpc.php');

    $USER = 'Chippers2';
    $PASS = 'Tegness1';
    $bid = $_POST['bid'];
    $nam = $_POST['nam'];
     
    if (!$client->query('my.newPic',array('Chippers2','Tegness1',$bid,$nam))) {
        die( 'Error while creating a new picture' . $client->getErrorCode() ." : ". $client->getErrorMessage());
    }
    echo $client->getResponse();
?>