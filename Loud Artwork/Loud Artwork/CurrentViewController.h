//
//  CurrentViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-12-31.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
- (IBAction)backButton:(id)sender;

@end
