<?php
    require_once("class-IXR.php");
    $client = new IXR_Client('http://www.loudartwork.com/xmlrpc.php');

    $USER = 'Chippers2';
    $PASS = 'Tegness1';
    $today = date("Y-m-d");
    $bid = $_POST[bid];
    $pic_name = $_POST[picnam];
    $age = $_POST[age];
    $num = 555;

    
     
    if (!$client->query('my.newPic',array('Chippers2','Tegness1',$bid,$pic_name))) {
        die( 'Error while creating a new picture' . $client->getErrorCode() ." : ". $client->getErrorMessage());
    }
    $PID =  $client->getResponse();
    //if($PID) {
      //  echo 'New picture added with ID: ' .$PID .'<br>';
    //}
    
    if (!$client->query('my.newPost',array('Chippers2','Tegness1',$bid,$PID,$num,$age))) {
        die( 'Error while creating a new post' . $client->getErrorCode() ." : ". $client->getErrorMessage());
    }
    $ID =  $client->getResponse();
    
    echo $PID.$ID;
    
    //if($ID) {
      //  echo 'New post added with ID: ' .$ID .'<br>';
    //}
    
    /*if (!$client->query('my.refresh',array('Chippers2','Tegness1',$ID))) {
        die( 'Error while updating a post' . $client->getErrorCode() ." : ". $client->getErrorMessage());
    }
    $ID =  $client->getResponse();
    
    if($ID) {
        echo 'Post updated with ID: ' .$ID;
    }*/
?>