//
//  ArtworkIAPHelper.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-18.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "ArtworkIAPHelper.h"

@implementation ArtworkIAPHelper

+ (ArtworkIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static ArtworkIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.loudartwork.LoudArtwork.iap.BronzeAccess",
                                      @"com.loudartwork.LoudArtwork.iap.SilverAccess",
                                      @"com.loudartwork.LoudArtwork.iap.GoldAccess",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
