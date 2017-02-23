//
//  DoggieDentalPetProfile.m
//  DoggieDental
//
//  Created by Isaac Tozer on 9/23/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalPetProfile.h"
#import "DoggieDentalCheckupStore.h"

@implementation DoggieDentalPetProfile

@synthesize petSpeciesIndex, petSpecies, petName, petBreed, petGender, petGenderIndex, petAge, petAgeString, petWeight, petWeightString, petMedications, petDiseases, imageKeyProfile, dateCreated, selected, thumbnail, thumbnailData, allCheckups, petID, petKey;

- (id)init
{
    self = [super init];
    if (self) {
        dateCreated = [[NSDate alloc] init];
        selected = NO;
        allCheckups = [[DoggieDentalCheckupStore alloc] init];
        petMedications = @"";
        petDiseases = @"";
                
        //create a CFUUID object - it knows how to create unique identifier strings
        CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
        //generate  string from unique identifier
        CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
        //use unique id to set items imageKey
        NSString *key = (__bridge NSString *) newUniqueIDString;
        petKey = key;
        //release memory - ARC cannot get rid of these because they are core foundation objects
        CFRelease(newUniqueIDString);
        CFRelease(newUniqueID);
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        [self setPetKey: [aDecoder decodeObjectForKey:@"petKey"]];
        [self setPetID:[aDecoder decodeIntForKey:@"petID"]];
        [self setPetSpeciesIndex:[aDecoder decodeIntForKey:@"petSpeciesIndex"]];
        [self setPetSpecies:[aDecoder decodeObjectForKey:@"petSpecies"]];
        [self setPetName:[aDecoder decodeObjectForKey:@"petName"]];
        [self setPetBreed:[aDecoder decodeObjectForKey:@"petBreed"]];
        [self setPetGender:[aDecoder decodeObjectForKey:@"petGender"]];
        [self setPetGenderIndex:[aDecoder decodeIntForKey:@"petGenderIndex"]];
        [self setPetAgeString:[aDecoder decodeObjectForKey:@"petAgeString"]];
        [self setPetAge:[aDecoder decodeIntForKey:@"petAge"]];
        [self setPetWeightString:[aDecoder decodeObjectForKey:@"petWeightString"]];
        [self setPetWeight:[aDecoder decodeIntForKey:@"petWeight"]];
        [self setPetMedications:[aDecoder decodeObjectForKey:@"petMedications"]];
        [self setPetDiseases:[aDecoder decodeObjectForKey:@"petDiseases"]];
        [self setImageKeyProfile:[aDecoder decodeObjectForKey:@"imageKeyProfile"]];
        //thumbnail - gets recreated via thumbnailData
        [self setThumbnailData:[aDecoder decodeObjectForKey:@"thumbnailData"]];
        [self setSelected:[aDecoder decodeBoolForKey:@"selected"]];
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        [self setAllCheckups:[aDecoder decodeObjectForKey:@"allCheckups"]];
    }
    
    return self;
}

- (NSString *) description
{
    NSString *petDescription = [[NSString alloc] initWithFormat:@"%@: %@: %@", petSpecies, petName, petBreed];
                            
    return petDescription;
}

- (void) setPetGender:(NSString*) petGenderEntered
{
    
    if ([petGenderEntered isEqualToString:@"Male"]) {
        petGenderIndex = 0;
    } else {
        petGenderIndex = 1;
    }
    petGender = petGenderEntered;

}

- (void) setPetSpecies:(NSString *)petSpeciesEntered
{
    if ([petSpeciesEntered isEqualToString:@"Dog"]) {
        petSpeciesIndex = 0;
    } else {
        petSpeciesIndex = 1;
    }
    petSpecies = petSpeciesEntered;
}

- (void) setPetAgeString:(NSString *)petAgeStringEntered
{
    petAge = [petAgeStringEntered intValue];        //will return 0 if not an int value
    petAgeString = petAgeStringEntered;
    
}

- (void) setPetWeightString:(NSString *)petWeightStringEntered
{
    petWeight = [petWeightStringEntered intValue];        //will return 0 if not an int value
    petWeightString = petWeightStringEntered;
    
}

- (UIImage *)thumbnail
{
    if (!thumbnailData) {
        return nil;
    }
    if (!thumbnail) {
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}

- (void) setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) /2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    UIGraphicsEndImageContext();
}

- (NSString *) petKey {
    return petKey;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:petKey forKey:@"petKey"];
    [aCoder encodeInt:petID forKey:@"petID"];
    [aCoder encodeInt:petSpeciesIndex forKey:@"petSpeciesIndex"];
    [aCoder encodeObject:petSpecies forKey:@"petSpecies"];
    [aCoder encodeObject:petName forKey:@"petName"];
    [aCoder encodeObject:petBreed forKey:@"petBreed"];
    [aCoder encodeObject:petGender forKey:@"petGender"];
    [aCoder encodeInt:petGenderIndex forKey:@"petGenderIndex"];
    [aCoder encodeObject:petAgeString forKey:@"petAgeString"];
    [aCoder encodeInt:petAge forKey:@"petAge"];
    [aCoder encodeObject:petWeightString forKey:@"petWeightString"];
    [aCoder encodeInt:petWeight forKey:@"petWeight"];
    [aCoder encodeObject:petMedications forKey:@"petMedications"];
    [aCoder encodeObject:petDiseases forKey:@"petDiseases"];
    [aCoder encodeObject:imageKeyProfile forKey:@"imageKeyProfile"];
    //UIIMAGE thumbnail - gets recreated via thumbnailData
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    [aCoder encodeBool:selected forKey:@"selected"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:allCheckups forKey:@"allCheckups"];
}

@end
