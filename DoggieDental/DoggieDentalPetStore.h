//
//  DoggieDentalPetStore.h
//  DoggieDental
//
//  Created by Isaac Tozer on 9/23/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoggieDentalPetProfile;

@interface DoggieDentalPetStore : NSObject
{
    NSMutableArray *allItems;
}

@property DoggieDentalPetProfile *selectedPet;

+ (DoggieDentalPetStore *) sharedStore;

- (NSArray *) allItems;
- (DoggieDentalPetProfile *) createItem;
- (void) removeItem: (DoggieDentalPetProfile *)p;
- (void) moveItemAtIndex: (int) from toIndex: (int) to;
- (void) selectItem: (DoggieDentalPetProfile *)p;
- (BOOL) itemSelected;
- (DoggieDentalPetProfile *) returnSelectedItem;
- (int) totalCheckups;
- (int) totalCheckupsSubmitted;
- (int) totalCheckupResults;
- (NSArray *) checkupInfo;
- (BOOL) checkupIsSelected;
- (void) selectCheckupPet: (DoggieDentalPetProfile *)pet checkupIndex: (int) i;
- (BOOL) checkupSelectedPet: (DoggieDentalPetProfile *)pet checkupIndex: (int) i;
- (NSDictionary *) checkupPetInfo ;
- (void) updateCheckupResults: (NSDictionary *) checkupResults;
//- (NSArray *) paidCheckupReview;
- (NSString *) itemArchivePath;
- (BOOL) saveChanges;
- (BOOL) cancelTransaction;
- (BOOL) transactionInProgress;
- (BOOL) petTransactionNeedsPost;
- (DoggieDentalPetProfile *) petTransactionToPost;
- (void) checkupPaymentComplete: (NSString *) transactionIdentifier;

@end
