//
//  DoggieDentalPetProfile.h
//  DoggieDental
//
//  Created by Isaac Tozer on 9/23/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoggieDentalCheckupStore;

@interface DoggieDentalPetProfile : NSObject <NSCoding>
{
   NSString *petKey;   //unique identifier for pet
}

@property (nonatomic) int petID;       //ID of pet in DB
@property (nonatomic) int petSpeciesIndex;       //0=dog, 1=cat
@property (nonatomic, copy) NSString *petSpecies;
@property (nonatomic, copy) NSString *petName;
@property (nonatomic, copy) NSString *petBreed;
@property (nonatomic, copy) NSString *petGender;
@property (nonatomic) int petGenderIndex;       //0=m, 1=f, 2=not yet selected
@property (nonatomic, copy) NSString *petAgeString;  //used for UITextField placeholder
@property (nonatomic) int petAge;
@property (nonatomic, copy) NSString *petWeightString;  //used for UITextField placeholder
@property (nonatomic) int petWeight;
//@property (nonatomic, copy) NSString *petSpayNeuter;
@property (nonatomic, copy) NSString *petMedications;
@property (nonatomic, copy) NSString *petDiseases;
@property (nonatomic, copy) NSString *imageKeyProfile;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;
@property (nonatomic) BOOL selected;
@property (nonatomic, readonly, strong) NSDate * dateCreated;
@property (nonatomic, copy) NSString *petKey;

@property DoggieDentalCheckupStore *allCheckups;

- (void) setThumbnailDataFromImage: (UIImage *)image;

//- (NSString *) petKey;

@end
