//
//  PictureViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-12-09.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    BOOL newMedia;
}

- (IBAction)uploadButton:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)selectButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *adImage;

@end
