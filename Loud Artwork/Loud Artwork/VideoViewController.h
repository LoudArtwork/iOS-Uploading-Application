//
//  VideoViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-12-09.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *url;
- (IBAction)backButton:(id)sender;
- (IBAction)uploadButton:(id)sender;
- (IBAction)retractKeyBoard:(id)sender;
@end
