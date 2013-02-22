//
//  ViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-09.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

- (IBAction)signIn:(id)sender {
    [self.activityIndicator startAnimating];
    [self performSelector: @selector(checkMethod)
           withObject: nil
           afterDelay: 0];
    return;
}

- (void) checkMethod {
    NSLog(@"Initial View Controller: User has started the app");
    // ---------- Check to see if business is already logged in ----------
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
    NSLog(@"Splash View Controller: Look for user file");
    
    if([[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
        NSLog(@"Initial View Controller: User file exists");
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            [self performSegueWithIdentifier:@"InitialToMenu" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        NSLog(@"Initial View Controller: User file does not exist");
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            [self performSegueWithIdentifier:@"InitialToLogin" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    // ---------- Check to see if business is already logged in ----------
}
@end
