//
//  DoggieDentalAppDelegate.h
//  DoggieDental
//
//  Created by Isaac Tozer on 9/22/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDJKeychainItemWrapper;

@interface DoggieDentalAppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDelegate>
{
    //UIActivityIndicatorView *spinner;
    NSMutableData *receivedData;
    KDJKeychainItemWrapper *keychain;
}

@property (strong, nonatomic) UIWindow *window;
@property UIImageView *splashView;

@end
