//
//  CameraViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-20.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    BOOL newMedia;
}

@property (weak, nonatomic) IBOutlet UITextField *nam;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *ema;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)retractKeyBoard:(id)sender;
- (IBAction)closeButton:(id)sender;
- (IBAction)uploadButton:(id)sender;

@end
