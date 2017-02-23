//
//  DoggieDentalPaymentInfo.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/10/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoggieDentalPetProfile;

@interface DoggieDentalPaymentInfo : UIViewController {
    
    UIView *spinnerView;
    UIActivityIndicatorView *spinner;
    NSMutableData *receivedData;
    BOOL optionalPicture;
    NSArray *_products;
    int numberOfTries;
}

@property (nonatomic, strong) DoggieDentalPetProfile *pet;

@end
