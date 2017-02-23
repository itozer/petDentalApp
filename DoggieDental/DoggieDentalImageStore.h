//
//  DoggieDentalImageStore.h
//  DoggieDental
//
//  Created by Isaac Tozer on 9/23/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoggieDentalImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+ (DoggieDentalImageStore *) sharedStore;

- (void) setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *) imageForKey:(NSString *)s;
- (void) deleteImageForKey:(NSString *)s;
- (NSString *) imagePathForKey: (NSString *)key;

@end
