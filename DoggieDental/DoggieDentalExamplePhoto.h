//
//  DoggieDentalExamplePhoto.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/23/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoggieDentalExamplePhoto : UIViewController <UINavigationControllerDelegate>
{
    __weak IBOutlet UIImageView *sampleImage;

}

@property (nonatomic) int petSpeciesIndex;       //0=dog, 1=cat
@property (nonatomic) int photoView;        //0=front, 1=left, 2=right, 3=optional

@end
