//
//  LoginViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-11-24.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButton:(id)sender {
    NSLog(@"Login View Controller: User is attempting to login");
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        // ---------- Check Business in Database ---------- //
        NSString *post = [NSString stringWithFormat:@"bid=%@&pwd=%@",self.bid.text,self.pwd.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laLogin.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    
    
        NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
        NSString *bbid = [NSString stringWithFormat:@"%@", [json objectForKey:@"bid"]];
        NSLog(@"Login View Controller: Got login response from database: %@", bbid);
        // ---------- Check Business in Database ---------- //
    
        if([bbid isEqualToString:@"1"]) {
            // ---------- Save Business ID to file ---------- //
            NSString *resultLine = [NSString stringWithFormat:@"%@\n",self.bid.text];
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
                [[NSFileManager defaultManager]createFileAtPath:surveys contents:nil attributes:nil];
                NSLog(@"The account.csv file has been created!");
            }
            
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:surveys];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[resultLine dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
            NSLog(@"BID has been saved to the account.csv file!");
            // ---------- Save Business ID to file ---------- //
        
            NSLog(@"Login View Controller: login was successful, user file was created");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:@"Welcome to the Loud Artwork App"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"LoginToMenu" sender:self];
        } else if([bbid isEqualToString:@"2"]) {
            NSLog(@"Login View Controller: login was not successful");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:[NSString stringWithFormat:@"%@", [json objectForKey:@"2"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            NSLog(@"Login View Controller: unknown login error");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"An unknown error occured please contact support!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        NSLog(@"Login View Controller: User not connected to internet");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)retractKeyBoard:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)movePhoneUp:(id)sender {
    [self animatePhoneField:self.bid up:YES];
    [self animatePhoneField:self.pwd up:YES];
}

- (IBAction)movePhoneDown:(id)sender {
    [self animatePhoneField:self.bid up:NO];
    [self animatePhoneField:self.pwd up:NO];
}

- (void) animatePhoneField: (UITextField*) textField up: (BOOL) up {
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = 230-(460-moveUpValue-5);
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
        animatedDistance = 70;
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
        animatedDistance = 70;
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
