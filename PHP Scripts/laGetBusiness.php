<?php
//
//  index.php
//  http://www.loudartwork.com/csub/index.php
//
//  Created by Thomas Nelson on 2012-09-04.
//  Copyright (c) 2012 Thomas Nelson. All rights reserved.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

   // Helper method to get a string description for an HTTP status code
   function getStatusCodeMessage($status) {
      // these could be stored in a .ini file and loaded
      // via parse_ini_file()... however, this will suffice
      // for an example
      $codes = Array(
         200 => 'OK',
         201 => 'Created',
         400 => 'Error'
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
         if (isset($_POST["b_id"])) {
             
            // Put parameters into local variables
            $b_id = $_POST["b_id"];
            $bid = "fail";
            $nam = "fail";
            $add = "fail";
            $cit = "fail";
            $pro = "fail";
            $cou = "fail";
            $pos = "fail";
            $ema = "fail";
            $pho = "fail";
                
            // Look up code in database
            $user_id = 0;
            $stmt = $this->db->prepare('SELECT bid, name, address, city, province, country, postal, email, phone FROM la_business_info WHERE bid=?');
            $stmt->bind_param("s", $b_id);
            $stmt->execute();
            $stmt->bind_result($bid, $nam, $add, $cit, $pro, $cou, $pos, $ema, $pho);
            
            while ($stmt->fetch()) {
               break;
            }
            
            $stmt->close();
             
            // Return unlock code, encoded with JSON
            $result = array("bid" => $bid, "nam" => $nam, "add" => $add, "cit" => $cit, "pro" => $pro, "cou" => $cou, "pos" => $pos, "ema" => $ema, "pho" => $pho, "exp" => $exp,);
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