//
//  ArtworkIAPHelper.m
//  Loud Artwork
//
//  Created by Thomas Nelson on 2013-02-18.
//  Copyright (c) 2013 Loud Artwork. All rights reserved.
//

#import "ArtworkIAPHelper.h"

@implementation AccessIAPHelper

+ (AccessIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static AccessIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.loudartwork.LoudArtwork.BronzeAccess",
                                      @"com.loudartwork.LoudArtwork.SilverAccess",
                                      @"com.loudartwork.LoudArtwork.GoldAccess",
                                      @"com.loudartwork.LoudArtwork.PlatinumAccess",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
