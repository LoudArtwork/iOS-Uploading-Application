//
//  LegalViewController.h
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-16.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webTerms;

- (IBAction)closeButton:(id)sender;

@end
