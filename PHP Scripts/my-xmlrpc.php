 <?php
    /*
     Plugin Name: My xmlrpc
     Plugin URI: N/A
     Description: A set of Custom XMLRPC for communication with the Loud Artwork iOS app
     Version: 1.0
     Author: Thomas Nelson
     Author URI: N/A
     */
    
    add_filter('xmlrpc_methods', 'my_xmlrpc_methods');
    
    function my_xmlrpc_methods($methods)
    {
        $methods['my.newPost'] = 'new_post';
        $methods['my.newPic'] = 'new_pic';
        $methods['my.refresh'] = 'update_post';
        $methods['my.login'] = 'user_login';

        return $methods;
    }
    
    function user_login($args) {
        $username = $args[0];
        $password = $args[1];
        
        global $wp_xmlrpc_server;
        
        // Let's run a check to see if credentials are okay
        if ( !$user = $wp_xmlrpc_server->login($username, $password) ) {
            return $wp_xmlrpc_server->error;
        }
        return 'pass';
    }
    
    function new_post($args) {
        // Parse the arguments, assuming they're in the correct order
        $username = $args[0];
        $password = $args[1];
        $bid      = $args[2];
        $pic      = $args[3];
        $num      = $args[4];
        $age      = $args[5];
        $ad       = $args[6];
        $newage   = '';
        
        if($age <= 4 && $age >= 1) {
            $newage = 'Age 1-4';
        } elseif($age <= 8 && $age >= 5) {
            $newage = 'Age 5-8';
        } elseif($age <= 12 && $age >= 9) {
            $newage = 'Age 9-12';
        } elseif($age <= 17 && $age >= 13) {
            $newage = 'Age 13-17';
        } else {
            $newage = 'Age 18 and older';
        }
                 
        global $wp_xmlrpc_server;
        
        // Let's run a check to see if credentials are okay
        if ( !$user = $wp_xmlrpc_server->login($username, $password) ) {
            return $wp_xmlrpc_server->error;
        }
        
        $today = date("Y-m-d");
        
        $my_post = array(
                         'post_title' => $bid,
                         'post_status' => 'private',
                         'post_author' => 63
                         );
        
        // Insert the post into the database
        $post_id = 'fail';
        $post_id = wp_insert_post( $my_post );
        
        add_post_meta($post_id, '_edit_last', 63, true);
        add_post_meta($post_id, '_mf_write_panel_id', 1, true);
        add_post_meta($post_id, 'picture_number', $num, true);
        add_post_meta($post_id, 'age', $newage, true);
        add_post_meta($post_id, 'location', 'Other-Other', true);
        add_post_meta($post_id, 'upload_date', $today, true);
        add_post_meta($post_id, 'image_name', $pic, true);
        add_post_meta($post_id, 'advertisement', $ad, true);
        
        // Just output something ;)
        return $post_id;
    }
    
    function new_pic($args) {
        // Parse the arguments, assuming they're in the correct order
        $username = $args[0];
        $password = $args[1];
        $bid      = (int) $args[2];
        $filename = $args[3];
        
        global $wp_xmlrpc_server;
        
        // Let's run a check to see if credentials are okay
        if ( !$user = $wp_xmlrpc_server->login($username, $password) ) {
            return $wp_xmlrpc_server->error;
        }
        
        
        $wp_filetype = wp_check_filetype(basename($filename), null );
        $wp_upload_dir = wp_upload_dir();
        $attachment = array(
                            'guid' => $wp_upload_dir['baseurl'] . _wp_relative_upload_path( $filename ),
                            'post_mime_type' => $wp_filetype['type'],
                            'post_title' => preg_replace('/\.[^.]+$/', '', basename($filename)),
                            'post_content' => '',
                            'post_status' => 'inherit'
                            );
        $attach_id = wp_insert_attachment( $attachment, $filename);
        // you must first include the image.php file
        // for the function wp_generate_attachment_metadata() to work
        require_once(ABSPATH . 'wp-admin/includes/image.php');
        $attach_data = wp_generate_attachment_metadata( $attach_id, $filename );
        wp_update_attachment_metadata( $attach_id, $attach_data );
        return $attach_id;
    }
    
    function update_post($args) {
        // Parse the arguments, assuming they're in the correct order
        $username = $args[0];
        $password = $args[1];
        $bid      = $args[2];
        
        global $wp_xmlrpc_server;
        
        // Let's run a check to see if credentials are okay
        if ( !$user = $wp_xmlrpc_server->login($username, $password) ) {
            return $wp_xmlrpc_server->error;
        }
        
        $my_post = array(
                         'ID' => $bid,
                         'post_content' => ''
                         );
        
        wp_publish_post( $bid );
        
        $post_id = wp_update_post( $my_post );
        
        // Just output something ;)
        return $post_id;
    }
?>