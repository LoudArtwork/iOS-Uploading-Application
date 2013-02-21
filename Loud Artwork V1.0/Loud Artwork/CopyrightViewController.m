//
//  CopyrightViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-18.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "CopyrightViewController.h"

@interface CopyrightViewController ()

@end

@implementation CopyrightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    NSString *ad = [NSString stringWithFormat:@"http://www.loudartwork.com/wp-content/uploads/2012/11/Copyright1.pdf"];
    NSLog(@"%@", ad);
    NSURL *webAd = [NSURL URLWithString:[ad stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *adURL = [NSURLRequest requestWithURL:webAd];
    [self.webCopy loadRequest:adURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        [self performSegueWithIdentifier:@"CopyToMenu" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"CopyToInitial" sender:self];
    }
}
@end
