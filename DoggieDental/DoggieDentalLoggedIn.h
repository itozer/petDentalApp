//
//  DoggieDentalLoggedIn.h
//  DoggieDental
//
//  Created by Isaac Tozer on 7/18/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDJKeychainItemWrapper;

@interface DoggieDentalLoggedIn : UIViewController
{
    KDJKeychainItemWrapper *keychain;
}

@property (weak, nonatomic) IBOutlet UILabel *accountEmail;

@end
