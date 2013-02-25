//
//  VideoViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-24.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

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

- (IBAction)closeButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        [self performSegueWithIdentifier:@"VideoToMenu" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"VideoToInitial" sender:self];
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
        
        // ---------- Add video to Database ---------- //
        NSString *post = [NSString stringWithFormat:@"bid=%@&gut=%@", bid, self.videoCode.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laAdVideo.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *login = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"login response: %@", login);
        // ---------- Add video to Database ---------- //
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Your new advertisement has been uploaded!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self performSegueWithIdentifier:@"VideoToMenu" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"VideoToInitial" sender:self];
    }
}

- (IBAction)retractKeyBoard:(id)sender {
    [self resignFirstResponder];
}
@end
