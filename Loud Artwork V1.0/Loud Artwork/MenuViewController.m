//
//  MenuViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-20.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController () {
    NSString *_act;
}

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // ---------- Get Business ID ---------- //
    
    // ---------- Get Business Info ---------- //
    NSString *post = [NSString stringWithFormat:@"b_id=%@",bid];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laGetBusiness.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
    // ---------- Get Business Info ---------- //
    
    self.accountName.title = [NSString stringWithFormat:@"%@", [json objectForKey:@"nam"]];
    _act = [NSString stringWithFormat:@"%@", [json objectForKey:@"act"]];
    NSLog(@"Menu View Controller: Business name added to main menu");
}

- (void)viewDidAppear {
    if([_act isEqualToString:@"expired"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"Your subscription has expired, you do not have a valid subscription at this time!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"MenuToSub" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if (section == 0 && row == 0) {
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            NSLog(@"Menu View Controller: User selected account info");
            [self performSegueWithIdentifier:@"MenuToAccount" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
        }
    } else if (section == 0 && row == 1) {
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            NSLog(@"Menu View Controller: User selected help docs");
            [self performSegueWithIdentifier:@"MenuToHelp" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
        }
    } else if (section == 0 && row == 2) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
        [[NSFileManager defaultManager]removeItemAtPath:surveys error:NULL];
        if(![[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
            NSLog(@"Menu View Controller: User selected log out of account");
            [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
        } else {
            NSLog(@"Menu View Controller: Business Not Signed Out!");
        }
    } else if (section == 0 && row == 3) {
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            NSLog(@"Menu View Controller: User selected subscription");
            [self performSegueWithIdentifier:@"MenuToSub" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
        }
    } else if (section == 1 && row == 0) {
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            NSLog(@"Menu View Controller: User selected upload ad");
            if([_act isEqualToString:@"bronze"]) {
                [self performSegueWithIdentifier:@"MenuToBronze" sender:self];
            } else if ([_act isEqualToString:@"silver"] || [_act isEqualToString:@"gold"]){
                [self performSegueWithIdentifier:@"MenuToSilver" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:@"You do not have a valid subscription at this time!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [self performSegueWithIdentifier:@"MenuToSub" sender:self];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
        }
    } else if (section == 1 && row == 1) {
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            NSLog(@"Menu View Controller: User selected view current ad");
            if([_act isEqualToString:@"bronze"] || [_act isEqualToString:@"silver"] || [_act isEqualToString:@"gold"]) {
                [self performSegueWithIdentifier:@"MenuToAd" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:@"You do not have a valid subscription at this time!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [self performSegueWithIdentifier:@"MenuToSub" sender:self];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
        }
    } else if (section == 2 && row == 0) {
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            NSLog(@"Menu View Controller: User selected terms of use");
            [self performSegueWithIdentifier:@"MenuToTerms" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
        }
    } else if (section == 2 && row == 1) {
        if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
            NSLog(@"Menu View Controller: User selected copyright info");
            [self performSegueWithIdentifier:@"MenuToCopy" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You are not connected to the internet!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
        }
    }
}

- (IBAction)cameraButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        NSLog(@"Menu View Controller: User selected camera");
        if([_act isEqualToString:@"bronze"] || [_act isEqualToString:@"silver"] || [_act isEqualToString:@"gold"]) {
            [self performSegueWithIdentifier:@"MenuToCamera" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"You do not have a valid subscription at this time!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"MenuToSub" sender:self];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"MenuToInitial" sender:self];
    }
}
@end
