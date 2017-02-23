//
//  DoggieDentalCheckupAnalysis.h
//  DoggieDental
//
//  Created by Isaac Tozer on 4/20/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoggieDentalPetProfile.h"
#import "DoggieDentalCheckup.h"

@interface DoggieDentalCheckupAnalysis : UIViewController
{
        
}

@property (nonatomic, strong) DoggieDentalPetProfile *pet;
@property (nonatomic, strong) DoggieDentalCheckup *checkup;
@property (nonatomic) BOOL checkupAnalyzed;

@end
