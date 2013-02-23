//
//  CurrentViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-23.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentViewController : UIViewController

- (IBAction)closeButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end
