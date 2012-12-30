//
//  AccountViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-11-30.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *bid;
@property (weak, nonatomic) IBOutlet UITextField *nam;
@property (weak, nonatomic) IBOutlet UITextField *add;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *pro;
@property (weak, nonatomic) IBOutlet UITextField *cou;
@property (weak, nonatomic) IBOutlet UITextField *pos;
@property (weak, nonatomic) IBOutlet UITextField *ema;
@property (weak, nonatomic) IBOutlet UITextField *pho;
- (IBAction)retractKeyBoard:(id)sender;
- (IBAction)saveButton:(id)sender;
- (IBAction)uploadAd:(id)sender;
- (IBAction)logOut:(id)sender;

@end
