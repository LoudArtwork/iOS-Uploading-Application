<?php
    require_once("class-IXR.php");
    $client = new IXR_Client('http://www.loudartwork.com/xmlrpc.php');

    $USER = 'Chippers2';
    $PASS = 'Tegness1';
    $bid = $_POST['bid'];
    $nam = $_POST['nam'];
    $age = $_POST['age'];
    $ad  = $_POST['add'];
    $pa = $_POST['pass'];
     
    if (!$client->query('my.newPost',array('Chippers2','Tegness1',$bid,$nam,$pa,$age,$ad))) {
        die( 'Error while creating a new picture' . $client->getErrorCode() ." : ". $client->getErrorMessage());
    }
    echo $client->getResponse();
?>