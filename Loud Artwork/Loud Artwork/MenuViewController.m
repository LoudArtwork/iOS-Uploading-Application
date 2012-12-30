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

- (IBAction)cameraButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        NSLog(@"Menu View Controller: User wants to go to the camera");
        [self performSegueWithIdentifier:@"MenuToCamera" sender:self];
    } else {
        NSLog(@"Menu View Controller: User is not connected to the internet");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)accountButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        NSLog(@"Menu View Controller: User wants to view their account information");
        [self performSegueWithIdentifier:@"MenuToAccount" sender:self];
    } else {
        NSLog(@"Menu View Controller: User is not connected to the internet");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)gotoWebsite:(id)sender {
    NSLog(@"Menu View Controller: User wants to view the website");
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.loudartwork.com" ];
    [[UIApplication sharedApplication] openURL:url];
}
@end
