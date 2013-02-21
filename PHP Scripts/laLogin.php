<?php
//
//  laLogin.php
//  http://www.loudartwork.com/wp-includes/laLogin.php
//
//  Created by Thomas Nelson on 2012-09-04.
//  Copyright (c) 2012 Thomas Nelson. All rights reserved.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

   // Helper method to get a string description for an HTTP status code
   function getStatusCodeMessage($status) {
      $codes = Array(
         200 => 'OK',
         201 => 'FAIL',
      );
      return (isset($codes[$status])) ? $codes[$status] : '';
   }
    
   // Helper method to send a HTTP response code/message
   function sendResponse($status = 200, $body = '', $content_type = 'text/html') {
      $status_header = 'HTTP/1.1 ' . $status . ' ' . getStatusCodeMessage($status);
      header($status_header);
      header('Content-type: ' . $content_type);
      echo $body;
   }
    
   class RedeemAPI {
      private $db;
        
      // Constructor - open DB connection
      function __construct() {
         $this->db = new mysqli('localhost', 'dienamicmisqlwp', 'yp5YR053!2g', 'dienamic2mis');
         $this->db->autocommit(FALSE);
      }
        
      // Destructor - close DB connection
      function __destruct() {
         $this->db->close();
      }
        
      // Main method to redeem a code
      function redeem() {
    
         // Check for required parameters
         if (isset($_POST["ema"])&&isset($_POST["pwd"])) {
             
            // Put parameters into local variables
            $ema = $_POST["ema"];
            $pwd = $_POST["pwd"];
            $bid = "fail";
                
            // Look up code in database
            $user_id = 0;
            $stmt = $this->db->prepare('SELECT bid FROM la_business_info WHERE email=? AND password=SHA1(?)');
            $stmt->bind_param("ss", $ema, $pwd);
            $stmt->execute();
            $stmt->bind_result($bid);
            
            while ($stmt->fetch()) {
               break;
            }
            
            $stmt->close();
             
             
            $result = array("bid" => $bid);
            sendResponse(200, json_encode($result));
             
            return true;
         }
        
         sendResponse(400, 'Invalid request');
         return false;
      }
   }
    
   // This is the first thing that gets called when this page is loaded
   // Creates a new instance of the RedeemAPI class and calls the redeem method
   $api = new RedeemAPI;
   $api->redeem();
    
?>