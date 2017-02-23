//
//  DoggieDentalCheckupStore.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/24/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalCheckupStore.h"
#import "DoggieDentalCheckup.h"
#import "DoggieDentalImageStore.h"

@implementation DoggieDentalCheckupStore

/*
*************** create singleton
+ (id)allocWithZone: (NSZone *)zone
{
    return [self sharedStore];
}

+ (DoggieDentalCheckupStore *) sharedStore
{
    static DoggieDentalCheckupStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}
 */
 
-(id) init
{
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        allItems = [aDecoder decodeObjectForKey:@"allItems"];
    }
    return self;
}

- (NSArray *) allItems
{
    return allItems;
}
//*****************


-(void) moveItemAtIndex: (int) from toIndex: (int) to
{
    if (from == to) {
        return;
    } else {
        DoggieDentalCheckup *p = [allItems objectAtIndex:from];
        [allItems removeObjectAtIndex:from];
        [allItems insertObject:p atIndex:to];
    }
}

- (void)createItem
{
    //check to see if there are any in progress checkups. if not, create a new one
    BOOL existing = NO;
    for (DoggieDentalCheckup *checkupItem in allItems) {
        if (![checkupItem submitted]) { //if there is already one in progress
            //checkup = checkupItem;
            existing = YES;
            break;
        }
    }
    if (!existing) {
        DoggieDentalCheckup *checkup = [[DoggieDentalCheckup alloc] init];
        [allItems addObject:checkup];
    }
    //return checkup;
}

- (DoggieDentalCheckup *) currentCheckup {
    for (DoggieDentalCheckup *checkup in allItems) {
        if (![checkup submitted]) {
            return checkup;
        }
    }
    return nil;     //im not sure if this is the best thing to do....
}


- (void) removeItem: (DoggieDentalCheckup *)c
{
    NSString *key = [c imageKeyFront];
    if (key) [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
    key = [c imageKeyLeft];
    if (key) [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
    key = [c imageKeyRight];
    if (key) [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
    key = [c imageKeyOptional];
    if (key) [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
    
    [allItems removeObjectIdenticalTo:c];
}

- (void) removeAllCheckupImages
{
    for (DoggieDentalCheckup *c in allItems) {
        NSString *key = [c imageKeyFront];
        if (key) [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
        key = [c imageKeyLeft];
        if (key) [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
        key = [c imageKeyRight];
        if (key) [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
        key = [c imageKeyOptional];
        if (key) [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
    }
}

- (void) selectItem:(DoggieDentalCheckup *)p {
    for (DoggieDentalCheckup *pet in allItems) {
        if ([p isEqual:pet]) {
            [pet setSelected:YES];
        } else {
            [pet setSelected:NO];
        }
    }
}

- (DoggieDentalCheckup *) returnSelectedItem {
    for (DoggieDentalCheckup *pet in allItems) {
        if ([pet selected]) {
            return pet;
        }
    }
    return nil;     //im not sure if this is the best thing to do....
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:allItems forKey:@"allItems"];
    
}


@end
