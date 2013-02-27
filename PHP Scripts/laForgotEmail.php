<?php
    $con = mysql_connect("localhost","dienamicmisqlwp","yp5YR053!2g");
    $rtn = "fail";
    
    if (!$con)
    {
        die('Could not connect: ' . mysql_error());
    }
    
    mysql_select_db("dienamic2mis", $con);
    
    $sql = "SELECT email FROM la_business_info WHERE email='$_POST[ema]'";
    $result = mysql_query($sql,$con);
    $row = mysql_fetch_array($result);
    $rtn = $row['email'];
    
    if($_POST[ema] == $rtn) {
        $sql="UPDATE la_business_info SET password='$_POST[nam]', address='$_POST[add]', city='$_POST[cit]', province='$_POST[pro]', country='$_POST[cou]', postal='$_POST[pos]', email='$_POST[ema]', phone='$_POST[pho]' WHERE bid='$_POST[bid]'";
        
        if (!mysql_query($sql,$con))
        {
            die('Error: ' . mysql_error());
        }
    }
    
    mysql_close($con);
    
    //define the receiver of the email
    $to = $_POST[ema];
    //define the subject of the email
    $subject = 'Welcome To Loud Artwork';
    //define the message to be sent. Each line should be separated with \n
    $message = "Thank you for registering your with Loud Artwork\n\nYour registration information is below.\nYou may wish to retain a copy for your records\n\nBusiness ID: $_POST[bid]\nPassword: $_POST[pwd]\n\n\n\n\n----------------------------------\nThis is an automated message from Loud Artwork\nPlease do not reply to this address";
    //define the headers we want passed. Note that they are separated with \r\n
    $headers = "From: Loud Artwork\r\nReply-To: wordpress@loudartwork.com";
    //send the email
    $mail_sent = @mail( $to, $subject, $message, $headers );
    //if the message is sent successfully print "Mail sent". Otherwise print "Mail failed"
    echo $mail_sent ? "Mail sent" : "Mail failed";
?>

$sql="UPDATE la_business_info SET name='$_POST[nam]', address='$_POST[add]', city='$_POST[cit]', province='$_POST[pro]', country='$_POST[cou]', postal='$_POST[pos]', email='$_POST[ema]', phone='$_POST[pho]' WHERE bid='$_POST[bid]'";

if (!mysql_query($sql,$con))
{
    die('Error: ' . mysql_error());
}