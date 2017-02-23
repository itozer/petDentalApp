//
//  DoggieDentalCheckupStore.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/24/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoggieDentalCheckup;

@interface DoggieDentalCheckupStore : NSObject <NSCoding>
{
    NSMutableArray *allItems;
}

//@property DoggieDentalCheckup *currentCheckup;

//+ (DoggieDentalCheckupStore *) sharedStore;

- (NSArray *) allItems;
//- (DoggieDentalCheckup *) createItem;
- (void) createItem;
- (DoggieDentalCheckup *) currentCheckup;
- (void) removeItem: (DoggieDentalCheckup *)p;
- (void) removeAllCheckupImages;
- (void) moveItemAtIndex: (int) from toIndex: (int) to;
- (void) selectItem: (DoggieDentalCheckup *)p;
- (DoggieDentalCheckup *) returnSelectedItem;

@end
