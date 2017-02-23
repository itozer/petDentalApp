//
//  DoggieDentalImageStore.m
//  DoggieDental
//
//  Created by Isaac Tozer on 9/23/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalImageStore.h"

@implementation DoggieDentalImageStore

//********** create singleton
+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (DoggieDentalImageStore *)sharedStore
{
    static DoggieDentalImageStore *sharedSore = nil;
    if (!sharedSore) {
        // create the singleton
        sharedSore = [[super allocWithZone:NULL] init];
    }
    return sharedSore;
}

- (id)init {
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}
//*********

- (void) clearCache: (NSNotification *) note
{
    NSLog(@"flushing %d images out of the cache", (int)[dictionary count]);
    [dictionary removeAllObjects];
}


- (void) setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    //saved to file immediately because they are too large to keep in memory for long
    NSString *imagePath = [self imagePathForKey:s];
    NSData *d = UIImageJPEGRepresentation(i, 0.7);
    [d writeToFile:imagePath atomically:YES];
    
}

- (UIImage *)imageForKey:(NSString *)s
{
    //return [dictionary objectForKey:s];
    
    //if possible get it from the dictionary
    UIImage *result = [dictionary objectForKey:s];
    
    if (!result) {
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        if (result) {
            [dictionary setObject:result forKey:s];
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:s]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s) {
        return;
    }
    [dictionary removeObjectForKey:s];
    
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (NSString *) imagePathForKey: (NSString *)key {
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
    
}


@end
