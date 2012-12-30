//
//  PictureViewController.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2012-12-09.
//  Copyright (c) 2012 Loud Artwork. All rights reserved.
//

#import "PictureViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface PictureViewController ()

@end

@implementation PictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)uploadButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        NSString *bid;
        // ---------- Get Business ID ---------- //
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *surveys = [docPath stringByAppendingPathComponent:@"account.csv"];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:surveys]) {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:surveys];
            NSString *surveyResults = [[NSString alloc]initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding];
            bid = surveyResults;
            [fileHandle closeFile];
        }
        NSLog(@"got business id: %@", bid);
        // ---------- Get Business ID ---------- //
        
        // ---------- Upload Picture ---------- //
        NSData *imageData = UIImageJPEGRepresentation(self.adImage.image, 90);
        NSString *urlString = @"http://www.loudartwork.com/ads/upload2.php";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *picture = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"uploaded picture: %@", picture);
        // ---------- Upload Picture ---------- //
        
        // ---------- Login ---------- //
        NSString *post = [NSString stringWithFormat:@"bid=%@&gut=%@", bid, picture];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.loudartwork.com/wp-includes/laAdPicture.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSError *error;
        NSURLResponse *response;
        returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *login = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"login response: %@", login);
        // ---------- Login ---------- //
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Your new advertisement has been uploaded!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.adImage.image = NULL;
        [self performSegueWithIdentifier:@"PictureToMenu" sender:self];
    } else {
        NSLog(@"Menu View Controller: User is not connected to the internet");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

- (IBAction)backButton:(id)sender {
    if([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] != NULL) {
        [self performSegueWithIdentifier:@"PictureToAccount" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"You are not connected to the internet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)selectButton:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = NO;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.adImage.image = image;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    }
    
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}
@end
