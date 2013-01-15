//
//  MenuViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-11-27.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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

// ---------- Camera Menu Selection ---------- //
- (IBAction)cameraButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) { // check if the user is connected to the internet
        NSLog(@"Menu View Controller: User wants to go to the camera"); // write to log
        [self performSegueWithIdentifier:@"MenuToCamera" sender:self]; // go to camera screen
    } else {
        NSLog(@"Menu View Controller: User is not connected to the internet"); // write to log
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" // alert the user that they are not connected to the internet
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
// ---------- Camera Menu Selection ---------- //

// ---------- Account Menu Selection ---------- //
- (IBAction)accountButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) { // check if the user is connected to the internet
        NSLog(@"Menu View Controller: User wants to view their account information"); // write to log
        [self performSegueWithIdentifier:@"MenuToAccount" sender:self]; // go to account screen
    } else {
        NSLog(@"Menu View Controller: User is not connected to the internet"); // write to log
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" // alert user that they are not connected to the internet
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
// ---------- Account Menu Selection ---------- //

// ---------- Website Menu Selection ---------- //
- (IBAction)gotoWebsite:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) { // check if user is connected to the internet
        NSLog(@"Menu View Controller: User wants to view the website"); // write to log
        NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.loudartwork.com" ]; // go to website
        [[UIApplication sharedApplication] openURL:url]; // open web browser/Safari
    } else {
        NSLog(@"Menu View Controller: User is not connected to the internet"); // write to log
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" // alert user that they are not connected to the internet
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
// ---------- Website Menu Selection ---------- //
@end
