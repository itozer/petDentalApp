//
//  DoggieDentalInAppPurchase.m
//  DoggieDental
//
//  Created by Isaac Tozer on 9/28/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalInAppPurchase.h"

@implementation DoggieDentalInAppPurchase

+ (DoggieDentalInAppPurchase *) sharedStore {
    static dispatch_once_t once;
    static DoggieDentalInAppPurchase * sharedStore;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.petdentalapp.inappcheckup",
                                      nil];
        sharedStore = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedStore;
}

@end
