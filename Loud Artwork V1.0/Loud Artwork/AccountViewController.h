//
//  AccountViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-22.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *bid;
@property (weak, nonatomic) IBOutlet UITextField *nam;
@property (weak, nonatomic) IBOutlet UITextField *add;
@property (weak, nonatomic) IBOutlet UITextField *cit;
@property (weak, nonatomic) IBOutlet UITextField *pro;
@property (weak, nonatomic) IBOutlet UITextField *cou;
@property (weak, nonatomic) IBOutlet UITextField *pos;
@property (weak, nonatomic) IBOutlet UITextField *pho;
@property (weak, nonatomic) IBOutlet UITextField *ema;
@property (weak, nonatomic) IBOutlet UITextField *act;

- (IBAction)saveButton:(id)sender;
- (IBAction)closeButton:(id)sender;
- (IBAction)retractKeyBoard:(id)sender;

@end
