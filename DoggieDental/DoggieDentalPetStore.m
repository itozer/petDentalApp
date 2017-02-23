//
//  DoggieDentalPetStore.m
//  DoggieDental
//
//  Created by Isaac Tozer on 9/23/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalPetStore.h"
#import "DoggieDentalPetProfile.h"
#import "DoggieDentalCheckup.h"
#import "DoggieDentalCheckupStore.h"
#import "DoggieDentalImageStore.h"

@implementation DoggieDentalPetStore


//*************** create singleton
+ (id)allocWithZone: (NSZone *)zone
{
    return [self sharedStore];
}

+ (DoggieDentalPetStore *) sharedStore
{
    static DoggieDentalPetStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

-(id) init
{
    self = [super init];
    if (self) {
        //allItems = [[NSMutableArray alloc] init];
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!allItems) {
            allItems = [[NSMutableArray alloc] init];
        }
        
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
        DoggieDentalPetProfile *p = [allItems objectAtIndex:from];
        [allItems removeObjectAtIndex:from];
        [allItems insertObject:p atIndex:to];
    }
}

- (DoggieDentalPetProfile *)createItem
{
    DoggieDentalPetProfile *pet = [[DoggieDentalPetProfile alloc] init];
    [allItems addObject:pet];
    return pet;
}


- (void) removeItem: (DoggieDentalPetProfile *)p
{
    //if i allow deletion. will need to delete profile pic, and ALL checkup pics #todo
    NSString *key = [p imageKeyProfile];
    [[DoggieDentalImageStore sharedStore] deleteImageForKey:key];
    [[p allCheckups] removeAllCheckupImages];
    
    
    [allItems removeObjectIdenticalTo:p];
}

- (void) selectItem:(DoggieDentalPetProfile *)p {
    for (DoggieDentalPetProfile *pet in allItems) {
        if ([p isEqual:pet]) {
            [pet setSelected:YES];
        } else {
            [pet setSelected:NO];
        }
    }
}

- (BOOL) itemSelected
{
    for (DoggieDentalPetProfile *pet in allItems) {
        if ([pet selected]) {
            return YES;
        }
    }
    return NO;
}

- (DoggieDentalPetProfile *) returnSelectedItem {
    for (DoggieDentalPetProfile *pet in allItems) {
        if ([pet selected]) {
            return pet;
        }
    }
    return nil;     //im not sure if this is the best thing to do....
}

- (int) totalCheckups {
    int i = 0;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup __unused in pet.allCheckups.allItems) {
            i++;
        }
    }
    
    return i;
}

-(BOOL) checkupIsSelected {
    BOOL selected = NO;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            if (checkup.selected) selected = YES;
        }
    }
    return selected;
}

- (BOOL) checkupSelectedPet: (DoggieDentalPetProfile *)pet checkupIndex: (int) i
{
    NSArray *checkups = [[NSArray alloc] initWithArray: pet.allCheckups.allItems];
    DoggieDentalCheckup *checkup = checkups[i];
    return checkup.selected;
}

// selects the current checkup
- (void) selectCheckupPet: (DoggieDentalPetProfile *)pet checkupIndex: (int) i
{
    for (DoggieDentalPetProfile *p in allItems) {
        for (DoggieDentalCheckup *checkup in p.allCheckups.allItems) {
            checkup.selected = NO;
        }
    }
    NSArray *checkups = [[NSArray alloc] initWithArray: pet.allCheckups.allItems];
    DoggieDentalCheckup *checkup = checkups[i];
    [checkup setSelected:YES];
}

//returns a dictionary with a pet and a checkup if the checkup is a current checkup
-(NSDictionary *) checkupPetInfo {
    DoggieDentalPetProfile *pet;
    DoggieDentalCheckup *checkup;
    for (DoggieDentalPetProfile *p in allItems) {
        for (DoggieDentalCheckup *c in p.allCheckups.allItems) {
            if (c.selected) {
                pet = p;
                checkup = c;
            }
        }
    }
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:pet, @"pet", checkup, @"checkup", nil];
    return dictionary;
}


//returns total number of checkups with results
- (int) totalCheckupResults
{
    int i = 0;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            if (checkup.checkupAnalyzed) {
                i++;
            }
        }
    }
    
    return i;
}

//returns total number of checkups that have been submitted
- (int) totalCheckupsSubmitted
{
    int i = 0;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            if (checkup.submitted) {
                i++;
            }
        }
    }
    
    return i;
}

//returns an array of pets that have checkup results
//pet, if analyzed, date analyzed, checkup index
- (NSArray *) checkupInfo {
    int checkupIndex;
    NSArray *tempArray;
    NSMutableArray *pets = [[NSMutableArray alloc] init];
    for (DoggieDentalPetProfile *pet in allItems) {
        checkupIndex = 0;
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            if (checkup.submitted) {
                //NSLog(@"analyzed: %hhd, dateSubmited %@, checkupIndex %d", checkup.checkupAnalyzed, checkup.dateSubmitted, checkupIndex );
                tempArray = [[NSArray alloc] initWithObjects:pet, [NSNumber numberWithBool:checkup.checkupAnalyzed], checkup.dateSubmitted, [[NSNumber alloc] initWithInt:checkupIndex], nil];
                //NSLog(@"array length: %lu", (unsigned long)[tempArray count]);
                [pets addObject: tempArray];
            }
            checkupIndex ++;
        }
    }
    //tempArray = [[NSArray alloc] initWithArray:pets];
    return pets;
}

//when server returns checkup results, update pet checkup info
//[analysis#][analysis, id, petID, recommendation]
- (void) updateCheckupResults: (NSDictionary *) checkupResults
{
    int checkupID = 0;
    int petID = 0;
    int numResults = 0;
    BOOL foundPet = NO;
    BOOL foundCheckup = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[formatter setDateFormat:@"yyyy-MM-dd"];
    
    for(id key in checkupResults) {
        //NSLog(@"key=%@ value=%@", key, [checkupResults objectForKey:key]);
        //gets results for single checkup
        NSDictionary *checkupDictionary = [[NSDictionary alloc] initWithDictionary:[checkupResults objectForKey:key]];
        checkupID = [[checkupDictionary objectForKey:@"checkupID"] intValue];
        petID = [[checkupDictionary objectForKey:@"petID"] intValue];
        foundPet = NO;
        for (DoggieDentalPetProfile *pet in allItems) {
            //NSLog(@"%d", [pet petID]);
            if ([pet petID] == petID) {
                foundPet = YES;
                foundCheckup = NO;
                for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
                    if ([checkup checkupID] == checkupID) {
                        [checkup setCheckupResults:[checkupDictionary objectForKey:@"analysis"]];
                        //NSLog(@"results: %@", [checkup checkupResults]);
                        [checkup setCheckupRecommendation:[checkupDictionary objectForKey:@"recommendation"]];
                        [checkup setCheckupAnalyzed:YES];
                        [checkup setDateAnalyzed:[formatter dateFromString:[checkupDictionary objectForKey:@"resultsDate"]]];
                        numResults++;
                        foundCheckup = YES;
                        break;
                    }
                }
                if (!foundCheckup) {
                    //this is a checkup for a pet that was re-created after the user deleted it
                    //need to re-create the checkup
                    [[pet allCheckups] createItem];
                    DoggieDentalCheckup *checkup = [[pet allCheckups] currentCheckup];
                    [checkup setCheckupID: [[checkupDictionary objectForKey:@"checkupID"] intValue]];
                    [checkup setCheckupResults:[checkupDictionary objectForKey:@"analysis"]];
                    [checkup setCheckupRecommendation:[checkupDictionary objectForKey:@"recommendation"]];
                    NSDate *date = [formatter dateFromString:[checkupDictionary objectForKey:@"submittedDate"]];
                    [checkup setDateCreated:date];
                    [checkup setDateSubmitted:date];
                    [checkup setDateAnalyzed:[formatter dateFromString:[checkupDictionary objectForKey:@"resultsDate"]]];
                    [checkup setCheckupAnalyzed:YES];
                    [checkup setSubmitted:YES];
                    [checkup setSelected:NO];
                    [checkup setCheckupType:0];
                    [checkup setTransactionStatus:0];
                }
                break;
            }
        }
        if (!foundPet) {
            //user has deleted the pet, or app, and this checkups pet does not exist. create it.
            
            //create the pet
            DoggieDentalPetProfile *pet = [self createItem];
            [pet setPetID:[[checkupDictionary objectForKey:@"petID"] intValue]];
            [pet setPetKey:[checkupDictionary objectForKey:@"petKey"]];
            [pet setPetSpecies:[checkupDictionary objectForKey:@"species"]];
            [pet setPetName:[checkupDictionary objectForKey:@"name"]];
            //NSLog(@"pet name: %@, petnameDictionary: %@", [pet petName], [checkupDictionary objectForKey:@"name"]);
            [pet setPetBreed:[checkupDictionary objectForKey:@"breed"]];
            [pet setPetAgeString:[checkupDictionary objectForKey:@"age"]];
            [pet setPetWeightString:[checkupDictionary objectForKey:@"weight"]];
            [pet setPetGender:[checkupDictionary objectForKey:@"gender"]];
            [pet setPetMedications:[checkupDictionary objectForKey:@"medications"]];
            [pet setPetDiseases:[checkupDictionary objectForKey:@"diseases"]];
            
            //create the checkup
            [[pet allCheckups] createItem];
            DoggieDentalCheckup *checkup = [[pet allCheckups] currentCheckup];
            [checkup setCheckupID: [[checkupDictionary objectForKey:@"checkupID"] intValue]];
            [checkup setCheckupResults:[checkupDictionary objectForKey:@"analysis"]];
            [checkup setCheckupRecommendation:[checkupDictionary objectForKey:@"recommendation"]];
            NSDate *date = [formatter dateFromString:[checkupDictionary objectForKey:@"submittedDate"]];
            //NSLog(@"date=%@ ", [checkupDictionary objectForKey:@"submittedDate"]);
            [checkup setDateSubmitted:date];
            [checkup setDateCreated:date];
            [checkup setDateAnalyzed:[formatter dateFromString:[checkupDictionary objectForKey:@"resultsDate"]]];
            [checkup setCheckupAnalyzed:YES];
            [checkup setSubmitted:YES];
            [checkup setSelected:NO];
            [checkup setCheckupType:0];
            [checkup setTransactionStatus:0];
        }
    }
    //NSLog(@"numResults: %d", numResults);
}


//Is there a checkup in transaction?
- (BOOL) transactionInProgress {
    BOOL found = NO;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            if (checkup.transactionStatus > 0) {
                found = YES;
                break;
            }
        }
        if (found) {
            break;
        }
    }
    
    return found;
}

//Cancel in progress transaction
- (BOOL) cancelTransaction {
    BOOL found = NO;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            if (checkup.transactionStatus == 1) {
                checkup.transactionStatus = 0;
                found = YES;
                break;
            }
        }
        if (found) {
            break;
        }
    }
    
    return found;
}

//Is there a checkup transaction that has been paid for, but needs to be posted to Pet Dental Servers.
- (BOOL) petTransactionNeedsPost {
    BOOL found = NO;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            //NSLog(@"transaction status: %d", checkup.transactionStatus);
            if (checkup.transactionStatus == 2) {
                found = YES;
                break;
            }
        }
        if (found) {
            break;
        }
    }
    
    return found;
}

//Is there a checkup transaction that has been paid for, but needs to be posted to Pet Dental Servers.
- (DoggieDentalPetProfile *) petTransactionToPost {
    BOOL found = NO;
    DoggieDentalPetProfile *transactionPet;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            if (checkup.transactionStatus == 2) {
                transactionPet = pet;
                found = YES;
                break;
            }
        }
        if (found) {
            break;
        }
    }
    
    return transactionPet;
}

//looks for a transationStatus == 1 (itunes in progress), and sets to 2(checkup post in progress)
- (void) checkupPaymentComplete: (NSString *) transactionIdentifier {
    BOOL found = NO;
    for (DoggieDentalPetProfile *pet in allItems) {
        for (DoggieDentalCheckup *checkup in pet.allCheckups.allItems) {
            if (checkup.transactionStatus == 1) {
                checkup.transactionStatus = 2;
                checkup.transactionIdentifier = transactionIdentifier;
                found = YES;
                break;
            }
        }
        if (found) {
            break;
        }
    }
}

- (NSString *) itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"item.archive"];
}

- (BOOL) saveChanges {
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}

@end
