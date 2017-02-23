//
//  DoggieDentalNearbyVets.m
//  DoggieDental
//
//  Created by Isaac Tozer on 10/27/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalNearbyVets.h"


@implementation DoggieDentalNearbyVets

@synthesize locationManager, currentCoord, places, currentLocation;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self]; // send loc updates to myself
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //distance = 96560; //60 miles (meters)
    }
    return self;
}

- (void) dealloc
{
    NSLog(@"good bye nearby vets");
}

-(void)startCurrentLocation {
    [self.locationManager startUpdatingLocation];
    NSLog(@"start updating location");
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"Location: %@", [locations[[locations count] - 1] description]);
    [self locationUpdate:locations[[locations count] - 1]];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
    [self locationError:error];
}

- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
}

- (void)locationUpdate:(CLLocation *)location {
    
    currentLocation = location;
    currentCoord = location.coordinate;
    [locationManager stopUpdatingLocation];
    NSLog(@"stopped location updates");
    [self queryGooglePlaces:@"veterinary_care"];
    
}

- (void)locationError:(NSError *)error {
    
    
}

-(void) queryGooglePlaces: (NSString *) googleType {
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    //NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&rankby=distance&radius=%@&types=%@&sensor=true&key=%@", currentCoord.latitude, currentCoord.longitude, [NSString stringWithFormat:@"%i", distance], googleType, kGOOGLE_API_KEY];
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&rankby=distance&types=%@&sensor=true&key=%@", currentCoord.latitude, currentCoord.longitude, googleType, kGOOGLE_API_KEY];
    
    NSLog(@"%@", url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    /*
    NSLog(@"Google Data: %@", places);
    NSArray *status = [json objectForKey:@"status"];
    NSLog(@"Status Data: %@", status);
    NSArray *debug = [json objectForKey:@"debug_info"];
    NSLog(@"debug Data: %@", debug);
    */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationsUpdated" object:nil userInfo:nil];
    
}

@end
