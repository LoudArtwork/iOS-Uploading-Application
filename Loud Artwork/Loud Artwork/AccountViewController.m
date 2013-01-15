//
//  AccountViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-11-30.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
    NSString *bbid;
    // ---------- Get Business ID ---------- //
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:surveys];
        NSString *surveyResults = [[NSString alloc]initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding];
        bbid = surveyResults;
        [fileHandle closeFile];
    }
    // ---------- Get Business ID ---------- //
    
    // ---------- Get Business Info ---------- //
    NSString *post = [NSString stringWithFormat:@"b_id=%@",bbid];
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
    
    self.bid.text = bbid;
    self.nam.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"nam"]];
    self.add.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"add"]];
    self.city.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"cit"]];
    self.pro.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"pro"]];
    self.cou.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"cou"]];
    self.pos.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"pos"]];
    self.ema.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"ema"]];
    self.pho.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"pho"]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { }

- (IBAction)saveButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        // ---------- Update Business in Database ---------- //
        NSString *post = [NSString stringWithFormat:@"bid=%@&nam=%@&add=%@&cit=%@&pro=%@&cou=%@&pos=%@&ema=%@&pho=%@",self.bid.text,self.nam.text,self.add.text,self.city.text,self.pro.text,self.cou.text,self.pos.text,self.ema.text,self.pho.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laEditBusiness.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    
    
        NSError *error;
        NSURLResponse *response;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *pass = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        if([pass isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Business Updated!"
                          message: @"You have successfuly changed information about your business!"\
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
            [alert show];
    
            [self performSegueWithIdentifier:@"AccountToAccount" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Error!"
                                  message: @"Your business infor was not updated!"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
            [self performSegueWithIdentifier:@"AccountToAccount" sender:self];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    // ---------- Update Business in Database ---------- //
}

- (IBAction)uploadAd:(id)sender {
    [self performSegueWithIdentifier:@"AccountToUpload" sender:self];
}

- (IBAction)logOut:(id)sender {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
    [[NSFileManager defaultManager]removeItemAtPath:surveys error:NULL];
    if(![[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
        NSLog(@"Business Signed Out!");
        [self performSegueWithIdentifier:@"AccountToSplash" sender:self];
    } else {
        NSLog(@"Business Not Signed Out!");
    }
}

- (IBAction)retractKeyBoard:(id)sender {
    [self resignFirstResponder];
}
@end
