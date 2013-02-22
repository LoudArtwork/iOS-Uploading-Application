//
//  LoginViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-18.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    if (row == 0) {
        NSLog(@"Login View Controller: User wants to create an account");
        [self performSegueWithIdentifier:@"LoginToCreate" sender:self];
    }
}

- (IBAction)signIn:(id)sender {
    [self.activityIndicator startAnimating];
    [self performSelector: @selector(signinMethod)
           withObject: nil
           afterDelay: 0];
    return;
}

- (void) signinMethod {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        // ---------- Check Business in Database ---------- //
        NSString *post = [NSString stringWithFormat:@"ema=%@&pwd=%@",self.ema.text,self.pwd.text];
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
        NSString *bid = [NSString stringWithFormat:@"%@", [json objectForKey:@"bid"]];
        NSLog(@"Login View Controller: Got user BID %@", bid);
        // ---------- Check Business in Database ---------- //
        
        if([bid isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"Your password or username are incorrect!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            // ---------- Save Business ID to file ---------- //
            NSString *resultLine = [NSString stringWithFormat:@"%@\n",bid];
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
                [[NSFileManager defaultManager]createFileAtPath:surveys contents:nil attributes:nil];
                NSLog(@"Login View Controller: The account.csv file has been created!");
            }
            
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:surveys];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[resultLine dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
            NSLog(@"Login View Controller: BID has been saved to the account.csv file!");
            // ---------- Save Business ID to file ---------- //
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:@"Welcome to the Loud Artwork App"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier:@"LoginToMenu" sender:self];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"LoginToInitial" sender:self];
    }
}

- (IBAction)forgotID:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        NSLog(@"Login View Controller: User forgot their password");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password"
                                                    message:@"To recieve your lost password enter your email for verification."
                                                   delegate:self
                                          cancelButtonTitle:@"Continue"
                                          otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeDefault;
        alertTextField.placeholder = @"Email";
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"LoginToInitial" sender:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Login View Controller: %@",[[alertView textFieldAtIndex:0] text]);
    
    // ---------- Send Email ---------- //
    NSString *post = [NSString stringWithFormat:@"ema=%@",self.ema.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laForgot.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
    NSString *rtn = [NSString stringWithFormat:@"%@", [json objectForKey:@"rtn"]];
    // ---------- Send Email ---------- //
    
    if([rtn isEqualToString:@"1"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                    message:@"Your password has been emailed!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure!"
                                                        message:@"You have provided and invalid email!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];    }
}

- (IBAction)retractKeyBoard:(id)sender {
    [self resignFirstResponder]; // hide keyboard when not in use
}

- (IBAction)closeButton:(id)sender {
    [self performSegueWithIdentifier:@"LoginToInitial" sender:self];
}

@end
