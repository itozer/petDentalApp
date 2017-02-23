//
//  DoggieDentalCheckupList.m
//  DoggieDental
//
//  Created by Isaac Tozer on 4/20/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalCheckupList.h"
#import "DoggieDentalCheckup.h"
#import "DoggieDentalCheckupStore.h"
#import "DoggieDentalPetStore.h"
#import "DoggieDentalPetProfile.h"
#import "DoggieDentalPetUITableViewCell.h"
#import "DoggieDentalButton.h"
#import "DoggieDentalCheckupAnalysis.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalCheckupList ()

@end

@implementation DoggieDentalCheckupList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Checkup List"];
        
        button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button setColorGradient:1];
        [button setTitle:@"Back" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button.layer setCornerRadius:4.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button addTarget:self action:@selector(returnToMenu:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:button];
        [[self navigationItem] setLeftBarButtonItem:lbbi];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateResults:)
                                                     name:@"appDidUpdateResults"
                                                   object:nil];
        
        /*
        DoggieDentalButton *button2 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button2 setColorGradient:1];
        [button2 setTitle:@"Next" forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button2.layer setCornerRadius:4.0f];
        [button2.layer setMasksToBounds:YES];
        [button2.layer setBorderWidth:1.0f];
        [button2.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button2 addTarget:self action:@selector(checkupResults:) forControlEvents:UIControlEventTouchUpInside];
         */
        
        /*
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button2 setBackgroundColor:[UIColor clearColor]];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner setCenter:CGPointMake(button2.frame.size.width/2.0, button2.frame.size.height/2.0)];
        [spinner stopAnimating];
        [button2 addSubview:spinner];
        
        UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [[self navigationItem] setRightBarButtonItem:rbbi];
        */
    }
    return self;
}

- (void)returnToMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkupResults:(id)sender
{
    if ([[DoggieDentalPetStore sharedStore] checkupIsSelected]) {    //has the user created and selected a pet
        
        DoggieDentalCheckupAnalysis *newViewController = [[DoggieDentalCheckupAnalysis alloc] init];
        NSDictionary *checkupDictionary = [[NSDictionary alloc] initWithDictionary: [[DoggieDentalPetStore sharedStore] checkupPetInfo]];
        newViewController.pet = [checkupDictionary objectForKey:@"pet"];
        newViewController.checkup = [checkupDictionary objectForKey:@"checkup"];
                
        [self.navigationController pushViewController:newViewController animated:YES];
    } else {
        //pop a message warning user they need to select a checkup
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[self tableView] setBackgroundView:nil];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    //Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"DoggieDentalPetUITableViewCell" bundle:nil];
    
    //Register this NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"DoggieDentalPetUITableViewCell"];
    
    //receivedData = [[NSMutableData alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    checkupInfo = [[DoggieDentalPetStore sharedStore] checkupInfo];
    numCheckups = (int)[checkupInfo count];
    [[self tableView] reloadData];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [checkupInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DoggieDentalPetProfile *pet = [[DoggieDentalPetProfile alloc] init];
    // 0 = pet, 1 = is analyzed, 2 = checkup date, 3 = checkup index
    NSArray *info = [[NSArray alloc] initWithArray:[checkupInfo objectAtIndex:[indexPath row]]];
    //NSLog(@"array length: %lu", (unsigned long)[info count]);
    pet = [info objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[info objectAtIndex:2]];
    //NSLog(@"date: %@", [info objectAtIndex:2]);
    //NSLog(@"name: %@", [pet petName]);
    NSString *petNameString = [[NSString alloc] initWithFormat:@"%@ (%@)", [pet petName], dateString];
    NSString *status;
    if ([[info objectAtIndex:1] boolValue]) {
        status = @"Complete";
    } else {
        status = @"Pending";
    }
    
    DoggieDentalPetUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoggieDentalPetUITableViewCell"];
    
    [[cell petNameLabel] setText:petNameString];
    [[cell petDescriptionLabel] setText:status];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImage *petTypeThumb;
    if ([pet thumbnail]) {
        [[cell petTypeImage] setImage:[pet thumbnail]];
    } else {
        if ([pet petSpeciesIndex] == 0) {
            petTypeThumb = [UIImage imageNamed: @"default_dog.png"];
        } else {
            petTypeThumb = [UIImage imageNamed: @"default_cat.png"];
        }
        [[cell petTypeImage] setImage:petTypeThumb];
    }

    return cell;
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //I used to make user select a pet and then press the next button
    //program logic depends on 'current checkup' logic
    //info is an array that containts: pet, date analyzed, checkup index
    NSArray *info = [[NSArray alloc] initWithArray:[checkupInfo objectAtIndex:[indexPath row]]];
    DoggieDentalPetProfile *pet = [[DoggieDentalPetProfile alloc] init];
    pet = [info objectAtIndex:0];
    int index = [[info objectAtIndex:3] intValue];
    BOOL checkupAnalyzed = [[info objectAtIndex:1] boolValue];
    [[DoggieDentalPetStore sharedStore] selectCheckupPet:pet checkupIndex:index];
    
    
    DoggieDentalCheckupAnalysis *newViewController = [[DoggieDentalCheckupAnalysis alloc] init];
    newViewController.pet = pet;
    newViewController.checkup = [[[pet allCheckups] allItems] objectAtIndex:index];
    newViewController.checkupAnalyzed = checkupAnalyzed;
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void) updateResults: (id) sender {
    [[self tableView] reloadData];
}


/*
 this method might be calling more than one times according to incoming data size
 */
/*
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
    NSLog(@"data recieved");
}
*/

/*
 if there is an error occured, this method will be called by connection
 */
/*
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
    [receivedData setLength:0]; //reset
    [spinner stopAnimating];
}
*/

/*
 if data is successfully received, this method will be called by connection
 */

/*
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *e = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: receivedData options: NSJSONReadingMutableContainers error: &e];
    
    NSMutableString *userMessage = [[NSMutableString alloc] initWithString:@""];
    if (!jsonDictionary) {
        //NSLog(@"Error parsing JSON: %@", e);
        [userMessage setString:@"Blargh. Server error. Please try again later"];
    } else {
        //pass to petstore - let petstore update checkupinfo
        [[DoggieDentalPetStore sharedStore] updateCheckupResults:jsonDictionary];
        [[self tableView] reloadData];
    }
    [receivedData setLength:0]; //reset
    [spinner stopAnimating];
    
    checkupInfo = [[DoggieDentalPetStore sharedStore] checkupInfo];
    if ([checkupInfo count] > numCheckups) {
        numCheckups = [checkupInfo count];
        [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}
*/

@end
