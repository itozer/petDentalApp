//
//  DoggieDentalInfo.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/23/14.
//  Copyright (c) 2014 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalInfo.h"
#import "DoggieDentalButton.h"
#import "DoggieDentalAbout.h"
#import "DoggieDentalDisclaimer.h"
#import "DoggieDentalTermsOfService.h"

@implementation DoggieDentalInfo

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Info"];
        
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
        
    }
    return self;
}

- (void)returnToMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] setBackgroundView:nil];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    //Load the NIB file
    //UINib *nib = [UINib nibWithNibName:@"DoggieDentalPetUITableViewCell" bundle:nil];
    
    //Register this NIB which contains the cell
    //[[self tableView] registerNib:nib forCellReuseIdentifier:@"DoggieDentalPetUITableViewCell"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self tableView] reloadData];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int i = 0;
    switch (section) {
        case 0:
            i = 1;
            break;
        case 1:
            i = 2;
            break;
        default:
            break;
    }
    return i;
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
    
    switch ([indexPath section]) {
        case 0:
            switch([indexPath row]) {
            case 0:
                [[cell textLabel] setText:@"About"];
                break;
            }
            break;
        case 1:
            switch([indexPath row]) {
                case 0:
                    [[cell textLabel] setText:@"Disclaimer"];
                    break;
                case 1:
                    [[cell textLabel] setText:@"Terms of Service"];
                    break;
            }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch ([indexPath section]) {
        case 0:
            if ([indexPath row] == 0) {
                DoggieDentalAbout *newViewController = [[DoggieDentalAbout alloc] init];
                [self.navigationController pushViewController:newViewController animated:YES];
            }
            break;
        case 1:
            if ([indexPath row] == 0) {
                DoggieDentalDisclaimer *newViewController = [[DoggieDentalDisclaimer alloc] init];
                [self.navigationController pushViewController:newViewController animated:YES];
            } else if ([indexPath row] == 1) {
                DoggieDentalTermsOfService *newViewController = [[DoggieDentalTermsOfService alloc] init];
                [self.navigationController pushViewController:newViewController animated:YES];
            }
            break;
    }
}


@end
