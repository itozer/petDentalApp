//
//  DoggieDentalCheckup.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/23/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoggieDentalCheckup : NSObject <NSCoding>

@property (nonatomic) int transactionStatus;     //0=not in transaction, 1=itunes transaction in progress, 2=pet dental post in progress
@property (nonatomic, copy) NSString *transactionIdentifier;    //returned by iTunes
@property (nonatomic) BOOL submitted;   //used to identify current checkup. if yes checkup has been paid for and posted successfully.
@property (nonatomic, strong) NSDate *dateSubmitted;
@property (nonatomic) BOOL selected;
@property (nonatomic) int checkupType;  //0=original, 1=follow up
@property (nonatomic) int checkupID;  //the database ID
@property (nonatomic, copy) NSString *imageKeyFront;
@property (nonatomic, copy) NSString *imageKeyLeft;
@property (nonatomic, copy) NSString *imageKeyRight;
@property (nonatomic, copy) NSString *imageKeyOptional;
//@property (nonatomic, readonly, strong) NSDate * dateCreated;
@property (nonatomic, strong) NSDate * dateCreated;

@property (nonatomic) BOOL checkupAnalyzed;
@property (nonatomic, strong) NSDate *dateAnalyzed;
@property (nonatomic, copy) NSString *checkupResults;
@property (nonatomic, copy) NSString *checkupRecommendation;



@end
