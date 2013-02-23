//
//  CopyrightViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-18.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CopyrightViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webCopy;

- (IBAction)closeButton:(id)sender;

@end
