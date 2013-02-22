//
//  UploadViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-22.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *adImage;
- (IBAction)uploadButton:(id)sender;
- (IBAction)closeButton:(id)sender;

@end
