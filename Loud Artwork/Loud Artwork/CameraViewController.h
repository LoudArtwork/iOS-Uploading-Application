//
//  CameraViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-11-27.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    BOOL newMedia;
}

- (IBAction)backButton:(id)sender;
- (IBAction)uploadButton:(id)sender;
- (IBAction)retractKeyBoard:(id)sender;
- (IBAction)cameraButton:(id)sender;
- (IBAction)movePhoneUp:(id)sender;
- (IBAction)movePhoneDown:(id)sender;
- (IBAction)movePadUp:(id)sender;
- (IBAction)movePadDown:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;
@property (weak, nonatomic) IBOutlet UITextField *nam;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *ema;
@property (weak, nonatomic) IBOutlet UIButton *buttonHide;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

@end
