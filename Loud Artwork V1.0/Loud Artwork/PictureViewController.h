//
//  PictureViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-23.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> {
    BOOL newMedia;
}

- (IBAction)uploadButton:(id)sender;
- (IBAction)closeButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIPopoverController *imagePopover;

@end
