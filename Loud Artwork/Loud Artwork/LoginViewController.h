//
//  LoginViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-11-24.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *bid;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
- (IBAction)movePadUp:(id)sender;
- (IBAction)movePadDown:(id)sender;
- (IBAction)movePhoneUp:(id)sender;
- (IBAction)movePhoneDown:(id)sender;
- (IBAction)retractKeyBoard:(id)sender;
- (IBAction)loginButton:(id)sender;

@end
