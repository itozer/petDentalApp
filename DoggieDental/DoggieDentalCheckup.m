//
//  DoggieDentalCheckup.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/23/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalCheckup.h"

@implementation DoggieDentalCheckup

@synthesize submitted, dateSubmitted, transactionStatus, transactionIdentifier, selected, checkupType, checkupID, imageKeyFront, imageKeyLeft, imageKeyRight, imageKeyOptional, dateCreated, checkupAnalyzed, dateAnalyzed, checkupResults, checkupRecommendation;

- (id)init
{
    self = [super init];
    if (self) {
        dateCreated = [[NSDate alloc] init];
        dateSubmitted = [[NSDate alloc] init];
        dateAnalyzed = [[NSDate alloc] init];
        submitted = NO;
        selected = NO;
        checkupType = 0;
        checkupAnalyzed = NO;
        checkupID = -1;
        transactionStatus = 0;
        //FOR TESTING
        /*
        imageKeyFront = @"";
        imageKeyLeft = @"";
        imageKeyRight = @"";
        imageKeyOptional = @"";
         */
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setSubmitted:[aDecoder decodeBoolForKey:@"submitted"]];
        dateSubmitted = [aDecoder decodeObjectForKey:@"dateSubmitted"];
        [self setTransactionStatus:[aDecoder decodeIntForKey:@"transactionStatus"]];
        [self setTransactionIdentifier:[aDecoder decodeObjectForKey:@"transactionIdentifier"]];
        [self setSelected:[aDecoder decodeBoolForKey:@"selected"]];
        [self setCheckupType:[aDecoder decodeIntForKey:@"checkupType"]];
        [self setCheckupID:[aDecoder decodeIntForKey:@"checkupID"]];
        [self setImageKeyFront:[aDecoder decodeObjectForKey:@"imageKeyFront"]];
        [self setImageKeyLeft:[aDecoder decodeObjectForKey:@"imageKeyLeft"]];
        [self setImageKeyRight:[aDecoder decodeObjectForKey:@"imageKeyRight"]];
        [self setImageKeyOptional:[aDecoder decodeObjectForKey:@"imageKeyOptional"]];
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        
        [self setCheckupAnalyzed:[aDecoder decodeBoolForKey:@"checkupAnalyzed"]];
        dateAnalyzed = [aDecoder decodeObjectForKey:@"dateAnalyzed"];
        [self setCheckupResults:[aDecoder decodeObjectForKey:@"checkupResults"]];
        [self setCheckupRecommendation:[aDecoder decodeObjectForKey:@"checkupRecommendation"]];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:submitted forKey:@"submitted"];
    [aCoder encodeObject:dateSubmitted forKey:@"dateSubmitted"];
    [aCoder encodeInt:transactionStatus forKey:@"transactionStatus"];
    [aCoder encodeObject:transactionIdentifier forKey:@"transactionIdentifier"];
    [aCoder encodeBool:selected forKey:@"selected"];
    [aCoder encodeInt:checkupType forKey:@"checkupType"];
    [aCoder encodeInt:checkupID forKey:@"checkupID"];
    [aCoder encodeObject:imageKeyFront forKey:@"imageKeyFront"];
    [aCoder encodeObject:imageKeyLeft forKey:@"imageKeyLeft"];
    [aCoder encodeObject:imageKeyRight forKey:@"imageKeyRight"];
    [aCoder encodeObject:imageKeyOptional forKey:@"imageKeyOptional"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeBool:checkupAnalyzed forKey:@"checkupAnalyzed"];
    [aCoder encodeObject:dateAnalyzed forKey:@"dateAnalyzed"];
    [aCoder encodeObject:checkupResults forKey:@"checkupResults"];
    [aCoder encodeObject:checkupRecommendation forKey:@"checkupRecommendation"];
}

@end
