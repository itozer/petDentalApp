//
//  DoggieDentalNearbyVets.h
//  DoggieDental
//
//  Created by Isaac Tozer on 10/27/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//#define kGOOGLE_API_KEY @"AIzaSyAKEIHFYLvFI-kipGi_Xp29Ix33yL1H08c"    //iOS key
#define kGOOGLE_API_KEY @"AIzaSyCrJHQMkdYhXeuk2NZJvbiL1pDWtflxEr4"      //browser key
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface DoggieDentalNearbyVets : NSObject <CLLocationManagerDelegate>

{
    CLLocationManager *locationManager;     //is this needed???
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) CLLocationCoordinate2D currentCoord;
@property (nonatomic) NSArray *places;

- (void)startCurrentLocation;

- (void)locationUpdate:(CLLocation *)location;

- (void)locationError:(NSError *)error;

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void)locationManager:(CLLocationManager *)manager
        didFinishDeferredUpdatesWithError:(NSError *)error;

@end
