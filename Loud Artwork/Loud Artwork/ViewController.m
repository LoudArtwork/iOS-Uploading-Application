//
//  ViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-11-22.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
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

- (IBAction)tapGesture:(id)sender {
    NSLog(@"Splash View Controller: User tapped screen");
    // ---------- Check to see if business is already logged in ----------
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
    NSLog(@"Splash View Controller: Look for user file");
    
    if([[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
        NSLog(@"Splash View Controller: User file exists");
        [self performSegueWithIdentifier:@"SplashToMenu" sender:self]; // if yes go to menu
    } else {
        NSLog(@"Splash View Controller: User file does not exist");
        [self performSegueWithIdentifier:@"SplashToLogin" sender:self]; // if yes go to login screen
    }
    // ---------- Check to see if business is already logged in ----------
}
@end