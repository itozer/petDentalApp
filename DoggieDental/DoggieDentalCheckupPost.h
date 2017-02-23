//
//  DoggieDentalCheckupPost.h
//  DoggieDental
//
//  Created by Isaac Tozer on 10/13/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoggieDentalPetProfile;

@interface DoggieDentalCheckupPost : NSObject <NSURLConnectionDelegate> {
    
    NSMutableData *receivedData;
    DoggieDentalPetProfile *pet;  // look at pets currentCheckup property for active checkup

}

@property (nonatomic) BOOL silent;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property NSURLConnection* connection;

+ (DoggieDentalCheckupPost *) sharedStore;
- (void)postCheckup;

@end
