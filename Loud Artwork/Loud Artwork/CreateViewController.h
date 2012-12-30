//
//  CreateViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-12-05.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *nam;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *ver;
@property (weak, nonatomic) IBOutlet UITextField *ema;
@property (weak, nonatomic) IBOutlet UITextField *pho;
@property (weak, nonatomic) IBOutlet UITextField *add;
@property (weak, nonatomic) IBOutlet UITextField *cit;
@property (weak, nonatomic) IBOutlet UITextField *pro;
@property (weak, nonatomic) IBOutlet UITextField *cou;
@property (weak, nonatomic) IBOutlet UITextField *pos;
- (IBAction)saveButton:(id)sender;
- (IBAction)retractKeyBoard:(id)sender;

@end
