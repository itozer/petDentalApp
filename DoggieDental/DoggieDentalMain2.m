//
//  DoggieDentalMain2.m
//  DoggieDental
//
//  Created by Isaac Tozer on 5/18/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalMain2.h"
#import "DoggieDentalMainTableViewCell.h"
#import "DoggieDentalPetStore.h"
#import "DoggieDentalPetList.h"
#import "DoggieDentalCheckupList.h"
#import "DoggieDentalButton.h"
#import "DoggieDentalAccount.h"
#import "DoggieDentalLoggedIn.h"
#import "KDJKeychainItemWrapper.h"
#import "DoggieDentalInfo.h"
#import <QuartzCore/QuartzCore.h>
//#import "DoggieDentalNearbyVetsList.h"

@interface DoggieDentalMain2 ()

@end

@implementation DoggieDentalMain2


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self setMainActionList:[NSMutableArray arrayWithObjects:@"Start New Checkup", @"Your Checkups", @"About", @"Nearby Vets", nil]];
        [self setMainActionList:[NSMutableArray arrayWithObjects:@"Start New Checkup", @"Your Checkups", @"Info", nil]];
        [self setMainInfoList:[NSMutableArray arrayWithObjects:@"How It Works", @"How to Take a Good Photo", nil]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateResults:)
                                                     name:@"appDidUpdateResults"
                                                   object:nil];
        //UINavigationItem *n = [self navigationItem];
        //[n setTitle:@"Pet Dental"];
        
        DoggieDentalButton *button2 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 30.0)];
        [button2 setColorGradient:1];
        [button2 setTitle:@"Account" forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button2.layer setCornerRadius:4.0f];
        [button2.layer setMasksToBounds:YES];
        [button2.layer setBorderWidth:1.0f];
        [button2.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button2 addTarget:self action:@selector(account:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [[self navigationItem] setRightBarButtonItem:rbbi];
        
    }
    return self;
}

- (void)account: (id)sender
{
    //check to see if the user is logged in already. if not, log them in.
    NSString *user = [[NSString alloc] init];
    NSString *pass = [[NSString alloc] init];
    KDJKeychainItemWrapper *keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
    user = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    pass = [keychain objectForKey:(__bridge id)(kSecValueData)];
    BOOL loggedIN = [[keychain objectForKey:(__bridge id)(kSecAttrDescription)] boolValue];
    
    if (loggedIN && ([user length] > 0) && ([pass length] > 0)) {
        DoggieDentalLoggedIn *newViewController = [[DoggieDentalLoggedIn alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
        
    } else {
        DoggieDentalAccount *newViewController = [[DoggieDentalAccount alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[[self menuTableView] setBackgroundView:nil];
    //[[self menuTableView] setBackgroundColor:[UIColor clearColor]];
    [[self menuTableView] setContentInset:UIEdgeInsetsMake(-65, 0, 0, 0)];  //IM NOT SURE WHAT IS CAUSING THE GREY SPACE ON TOP
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    //[[self view] setBackgroundColor:[UIColor colorWithRed:131/255.0 green:170/255.0 blue:22/255.0 alpha:1.0]];
    
    //Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"DoggieDentalMainTableViewCell" bundle:nil];
    
    //Register this NIB which contains the cell
    [[self menuTableView] registerNib:nib forCellReuseIdentifier:@"DoggieDentalMainTableViewCell"];
    
	_scrollView.clipsToBounds = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
	
    
	CGFloat contentOffset = 0.0f;
	NSArray *imageFilenames = [NSArray arrayWithObjects:@"1.png",
							   @"2.png",
							   @"3.png",
							   @"4.png",
							   @"5.png",
							   nil];
    
	for (NSString *singleImageFilename in imageFilenames) {
		CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f, _scrollView.frame.size.width, _scrollView.frame.size.height);
        
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
		imageView.image = [UIImage imageNamed:singleImageFilename];
		imageView.contentMode = UIViewContentModeCenter;
		[_scrollView addSubview:imageView];
        
		contentOffset += imageView.frame.size.width;
		_scrollView.contentSize = CGSizeMake(contentOffset, _scrollView.frame.size.height);
	}
    
    [[self menuTableView] reloadData];
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self menuTableView] reloadData];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int i = 0;
    switch (section) {
        case 0:
            i = (int)[_mainActionList count];
            break;
        case 1:
            i = (int)[_mainInfoList count];
            break;
        default:
            break;
    }
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if (!cell) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
     }
     
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     */
    
    DoggieDentalMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoggieDentalMainTableViewCell"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *menuItem;
    switch ([indexPath section]) {
        case 0:
            menuItem = [_mainActionList objectAtIndex:[indexPath row]];
            break;
        case 1:
            menuItem = [_mainInfoList objectAtIndex:[indexPath row]];
            break;
        default:
            menuItem = @"Error";
            break;
    }
    
    int numResults = -1;
    [[cell sectionLabel] setText:menuItem];
    if ([menuItem isEqualToString:@"Your Checkups"]) {
        numResults = [[DoggieDentalPetStore sharedStore] totalCheckupsSubmitted];
        if (numResults > 0) {
            [[cell redCircleImage] setImage:[UIImage imageNamed: @"red_circle.png"]];
            NSString *checkupResults = [[NSString alloc] initWithFormat:@"%d", numResults];
            [[cell numberLabel] setText:checkupResults];
            [[cell redCircleImage] setHidden: NO];
            [[cell numberLabel] setHidden:NO];
            [[cell sectionLabel] setFrame:CGRectMake(45, 2, 180, 40)];
        } else {
            [[cell redCircleImage] setHidden: YES];
            [[cell numberLabel] setHidden:YES];
            [[cell sectionLabel] setFrame:CGRectMake(14, 2, 180, 40)];
        }
    } else {
        [[cell redCircleImage] setHidden: YES];
        [[cell numberLabel] setHidden:YES];
        [[cell sectionLabel] setFrame:CGRectMake(14, 2, 240, 40)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    switch ([indexPath section]) {
        case 0:
            //start new checkup. push PetList.
            if ([indexPath row] == 0) {
                DoggieDentalPetList *newViewController = [[DoggieDentalPetList alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:newViewController animated:YES];
                
                //Checkup Results
            } else if ([indexPath row] == 1) {
                DoggieDentalCheckupList *newViewController = [[DoggieDentalCheckupList alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:newViewController animated:YES];
                //About
            } else if ([indexPath row] == 2) {
                DoggieDentalInfo *newViewController = [[DoggieDentalInfo alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:newViewController animated:YES];
            }
            //nearby vets
            /*
            } else if ([indexPath row] == 3) {
                DoggieDentalNearbyVetsList *newViewController = [[DoggieDentalNearbyVetsList alloc] init];
                [self.navigationController pushViewController:newViewController animated:YES];
            }
            */
            
            break;
    
        case 1:
            /*
            //How it works
            if ([indexPath row] == 0) {
                DoggieDentalHowItWorks *newViewController = [[DoggieDentalHowItWorks alloc] init];
                [self.navigationController pushViewController:newViewController animated:YES];
                
                //how to take a good photo
            } else if ([indexPath row] == 1) {
                DoggieDentalHowToTakeAGoodPhoto *newViewController = [[DoggieDentalHowToTakeAGoodPhoto alloc] init];
                [self.navigationController pushViewController:newViewController animated:YES];
            }
            */
            break;
    }
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //not working in iOS7 ??
    return 1.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menuTableView.frame.size.width, 1.0)];
    return  header;
}

- (void) updateResults: (id) sender {
    [_menuTableView reloadData];
}


@end
