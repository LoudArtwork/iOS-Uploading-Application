//
//  CameraViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-11-27.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        [self performSegueWithIdentifier:@"CameraToMenu" sender:self];
    }
}

- (IBAction)cameraButton:(id)sender {
    self.buttonHide.hidden = TRUE;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = YES;
    } else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = NO;
    }
}

- (IBAction)uploadButton:(id)sender {
    [self.actInd startAnimating];  //Or whatever UI Change you need to make
    [self performSelector: @selector(uploadMethod)
               withObject: nil
               afterDelay: 0];
    return;}

- (void) uploadMethod {
    NSString *bid;
    // ---------- Get Business ID ---------- //
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:surveys];
        NSString *surveyResults = [[NSString alloc]initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding];
        bid = surveyResults;
        [fileHandle closeFile];
    }
    NSLog(@"got business id: %@", bid);
    // ---------- Get Business ID ---------- //
    
    // ---------- Login ---------- //
     NSString *post = [NSString stringWithFormat:@"bid=%@", bid];
     NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
     NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
     
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/wpLogin.php"]];
     [request setHTTPMethod:@"POST"];
     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:postData];
     
     
     NSError *error;
     NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *login = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
     NSLog(@"login response: %@", login);
     // ---------- Login ---------- //
    
    // ---------- Upload Picture ---------- //
    NSData *imageData = UIImageJPEGRepresentation(self.cameraImage.image, 90);
	NSString *urlString = @"http://www.loudartwork.com/wp-content/uploads/upload.php";
	
	request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
	
	returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *picture = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"uploaded picture: %@", picture);
    // ---------- Upload Picture ---------- //
    
    // ---------- Create Attachment ---------- //
    post = [NSString stringWithFormat:@"bid=%@&nam=%@", bid, picture];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/wpAttach.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *attach = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"created attachment: %@", attach);
    // ---------- Create Attachment ---------- //
    
    // ---------- Get Advertisement ---------- //
    post = [NSString stringWithFormat:@"bid=%@", bid];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laGetAd.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
    NSString *advert = [NSString stringWithFormat:@"%@", [json objectForKey:@"con"]];
    NSLog(@"Camera View Controller: Got advert from database: %@", advert);
    // ---------- Get Advertisement ---------- //
    
    // ---------- Add Info To Database ---------- //
    post = [NSString stringWithFormat:@"nam=%@&bid=%@&fna=%@&age=%@&ema=%@",picture,bid,self.nam.text,self.age.text,self.ema.text];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laPicInfo.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *pass = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"add pic info: %@", pass);
    // ---------- Add Info To Database ---------- //
    
    // ---------- Create Post ---------- //
    post = [NSString stringWithFormat:@"bid=%@&nam=%@&age=%@&add=%@&pass=%@", bid, attach,self.age.text,advert,pass];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/wpPost.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *posty = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"created post: %@", posty);
    // ---------- Create Post ---------- //

    // ---------- Send Email ---------- //
    post = [NSString stringWithFormat:@"nam=%@&ema=%@&pos=%@", self.nam.text, self.ema.text, posty];
    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laSendEmail.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    pass = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"did email send: %@", pass);
    // ---------- Send Email ---------- //
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Photo Uploaded!"
                          message: @"Image successfully saved!"\
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    self.cameraImage.image = NULL;
    [self performSegueWithIdentifier:@"CameraToMenu" sender:self];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.cameraImage.image = image;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    }
    
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)retractKeyBoard:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)movePhoneUp:(id)sender {
    [self animatePhoneField:self.nam up:YES];
    [self animatePhoneField:self.age up:YES];
    [self animatePhoneField:self.ema up:YES];
}

- (IBAction)movePhoneDown:(id)sender {
    [self animatePhoneField:self.nam up:NO];
    [self animatePhoneField:self.age up:NO];
    [self animatePhoneField:self.ema up:NO];
}

- (void) animatePhoneField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = 72;
        if(animatedDistance>0) {
            const int movementDistance = animatedDistance;
            const float movementDuration = 0.3f;
            int movement = (up ? -movementDistance : movementDistance);
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
            [UIView commitAnimations];
        }
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        animatedDistance = 54;
        if(animatedDistance>0) {
            const int movementDistance = animatedDistance;
            const float movementDuration = 0.3f;
            int movement = (up ? -movementDistance : movementDistance);
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            self.view.frame = CGRectOffset(self.view.frame, movement, 0);
            [UIView commitAnimations];
        }
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        animatedDistance = 54;
        if(animatedDistance>0) {
            const int movementDistance = animatedDistance;
            const float movementDuration = 0.3f;
            int movement = (up ? movementDistance : -movementDistance);
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            self.view.frame = CGRectOffset(self.view.frame, movement, 0);
            [UIView commitAnimations];
        }
    }
    
}

- (IBAction)movePadUp:(id)sender { // move screen up when keyboard is in use
    [self animatePadField:self.nam up:YES];
    [self animatePadField:self.age up:YES];
    [self animatePadField:self.ema up:YES];
}

- (IBAction)movePadDown:(id)sender { // move screen down when keyboard is not in use
    [self animatePadField:self.nam up:NO];
    [self animatePadField:self.age up:NO];
    [self animatePadField:self.ema up:NO];
}

- (void) animatePadField: (UITextField*) textField up: (BOOL) up {
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = 50;
        if(animatedDistance>0) {
            const int movementDistance = animatedDistance;
            const float movementDuration = 0.3f;
            int movement = (up ? -movementDistance : movementDistance);
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
            [UIView commitAnimations];
        }
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        animatedDistance = 90;
        if(animatedDistance>0) {
            const int movementDistance = animatedDistance;
            const float movementDuration = 0.3f;
            int movement = (up ? -movementDistance : movementDistance);
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            self.view.frame = CGRectOffset(self.view.frame, movement, 0);
            [UIView commitAnimations];
        }
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        animatedDistance = 90;
        if(animatedDistance>0) {
            const int movementDistance = animatedDistance;
            const float movementDuration = 0.3f;
            int movement = (up ? movementDistance : -movementDistance);
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: movementDuration];
            self.view.frame = CGRectOffset(self.view.frame, movement, 0);
            [UIView commitAnimations];
        }
    }
    
}



@end
