//
//  MenuViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-20.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController

- (IBAction)cameraButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *accountName;

@end
