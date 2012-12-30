//
//  VideoViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-12-09.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        [self performSegueWithIdentifier:@"VideoToAccount" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)uploadButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
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
        NSString *post = [NSString stringWithFormat:@"bid=%@&gut=%@", bid, self.url.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laAdVideo.php"]];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Your new advertisement has been uploaded!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self performSegueWithIdentifier:@"VideoToMenu" sender:self];
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

- (IBAction)retractKeyBoard:(id)sender {
    [self resignFirstResponder];
}
@end
