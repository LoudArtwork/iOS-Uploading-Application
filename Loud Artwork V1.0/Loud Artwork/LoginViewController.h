//
//  LoginViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-18.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *ema;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

- (IBAction)signIn:(id)sender;
- (IBAction)forgotID:(id)sender;
- (IBAction)retractKeyBoard:(id)sender;
- (IBAction)closeButton:(id)sender;

@end
