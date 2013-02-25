//
//  VideoViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-24.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *videoCode;
- (IBAction)closeButton:(id)sender;
- (IBAction)uploadButton:(id)sender;
- (IBAction)retractKeyBoard:(id)sender;

@end
