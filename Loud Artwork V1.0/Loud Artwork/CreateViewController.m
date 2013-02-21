//
//  CreateViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-18.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

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

- (IBAction)saveButton:(id)sender {
    NSLog(@"Create View Controller: User is attempting to create a new account");
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        if([self.pwd.text isEqualToString:self.ver.text]) {
            // ---------- Create Business in Database ---------- //
            NSString *post = [NSString stringWithFormat:@"nam=%@&add=%@&cit=%@&pro=%@&cou=%@&pos=%@&ema=%@&pho=%@&pwd=%@",self.nam.text,self.add.text,self.cit.text,self.pro.text,self.cou.text,self.pos.text,self.ema.text,self.pho.text,self.pwd.text];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laCreate.php"]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *bid = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            NSLog(@"Create View Controller: New user created with BID %@", bid);
            // ---------- Create Business in Database ---------- //
            
            // ---------- Save Business ID to file ---------- //
            NSString *resultLine = [NSString stringWithFormat:@"%@\n",bid];
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
                [[NSFileManager defaultManager]createFileAtPath:surveys contents:nil attributes:nil];
                NSLog(@"Create View Controller: The account.csv file has been created!");
            }
            
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:surveys];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[resultLine dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
            NSLog(@"Create View Controller: BID has been saved to the account.csv file!");
            // ---------- Save Business ID to file ---------- //
            
            // ---------- Send Email ---------- //
            post = [NSString stringWithFormat:@"ema=%@&bid=%@&pwd=%@", self.ema.text, bid, self.pwd.text];
            postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laBusinessEmail.php"]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            NSLog(@"Create View Controller: Email Status = %@", returnString);
            // ---------- Send Email ---------- //
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:@"Your business has successfully been created!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            NSLog(@"Create View Controller: New account created, user file created, email sent");
            [self performSegueWithIdentifier:@"CreateToMenu" sender:self];
        } else {
            NSLog(@"Create View Controller: did not pass password verification");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"The passwords do not match!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        NSLog(@"Create View Controller: User is not connected to the internet");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"CreateToInitial" sender:self];
    }

}

- (IBAction)retractKeyBoard:(id)sender {
    [self resignFirstResponder]; // hide keyboard when not in use
}
@end
