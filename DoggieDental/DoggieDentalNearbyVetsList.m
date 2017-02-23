//
//  DoggieDentalNearbyVetsList.m
//  DoggieDental
//
//  Created by Isaac Tozer on 10/27/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalNearbyVetsList.h"
#import "DoggieDentalNearbyVets.h"

@interface DoggieDentalNearbyVetsList ()

@end

@implementation DoggieDentalNearbyVetsList

@synthesize nearbyVets;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        nearbyVets = [[DoggieDentalNearbyVets alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //this is the notification sent from CheckupPost that posts checkup data to web server
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLocationList:)
                                                 name:@"locationsUpdated"
                                               object:nil];
    
    [nearbyVets startCurrentLocation];
        
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)updateLocationList:(NSNotification *)notification {
    
    [[self tableView] reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[nearbyVets places] count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //Retrieve the NSDictionary object in each index of the array.
    NSDictionary *place = [[nearbyVets places] objectAtIndex:[indexPath row]];
    // 3 - There is a specific NSDictionary object that gives us the location info.
    //NSDictionary *geo = [place objectForKey:@"geometry"];
    // Get the lat and long for the location.
    //NSDictionary *loc = [geo objectForKey:@"location"];
    // Get google rating
    //NSDictionary *rating = [place objectForKey:@"rating"];
    // 4 - Get your name and address info for adding to a pin.
    NSString *name=[place objectForKey:@"name"];
    NSString *vicinity=[place objectForKey:@"vicinity"];
    // Create a special variable to hold this coordinate info.
    //CLLocationCoordinate2D placeCoord;
    // Set the lat and long.
    //placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
    //placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
    // 5 - Create a new annotation.
    //MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
    //[mapView addAnnotation:placeObject];
    
    //CLLocation *nearbyPlance = [[CLLocation alloc] initWithLatitude:placeCoord.latitude longitude:placeCoord.longitude];
    //CLLocationDistance meters = [[nearbyVets currentLocation] distanceFromLocation:nearbyPlance];
    //NSString *description = [NSString stringWithFormat:@"%@ (%f miles)", vicinity, (meters / 1609.34)];
    //[cell.detailTextLabel setText:description];
    
    [[cell textLabel] setText:name];
    [cell.detailTextLabel setText:vicinity];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
