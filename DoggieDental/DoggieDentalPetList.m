//
//  DoggieDentalPetList.m
//  DoggieDental
//
//  Created by Isaac Tozer on 9/23/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalPetList.h"
#import "DoggieDentalPetProfile.h"
#import "DoggieDentalPetStore.h"
#import "DoggieDentalCheckup.h"
#import "DoggieDentalCheckupStore.h"
#import "DoggieDentalAddPetController2.h"
#import "DoggieDentalDentalPhotosController.h"
#import "DoggieDentalButton.h"
#import "DoggieDentalPetUITableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalPetList ()

@end

@implementation DoggieDentalPetList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"1. Select Pet"];
        
        //right next button
        //UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(takeDentalPhotos:)];
        //[[self navigationItem] setRightBarButtonItem:rbbi];
                
        //left back button
        //UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(returnToMenu:)];
        //[lbbi setTintColor:[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f]];
        //[lbbi setTintColor:[UIColor colorWithRed:0.337 green:0.455 blue:0.0118 alpha:1.0]];
        //UIImage *buttonImage = [[UIImage imageNamed:@"uibarbuttonbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        //[lbbi setBackgroundImage:buttonImage forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
        
        //[[self navigationItem] setLeftBarButtonItem:lbbi];
        
        
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
        
        
        button2 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button2 setColorGradient:2];
        [button2 setTitle:@"+" forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
        [button2.layer setCornerRadius:4.0f];
        [button2.layer setMasksToBounds:YES];
        [button2.layer setBorderWidth:1.0f];
        [button2.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button2 addTarget:self action:@selector(createNewPet:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [[self navigationItem] setRightBarButtonItem:rbbi];
        
 
    }
    return self;
}

- (void)returnToMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)takeDentalPhotos:(id)sender
{
    if ([[DoggieDentalPetStore sharedStore] itemSelected]) {    //has the user created and selected a pet
                
        DoggieDentalDentalPhotosController *newViewController = [[DoggieDentalDentalPhotosController alloc] init];
        
        DoggieDentalPetProfile *pet = [[DoggieDentalPetStore sharedStore] returnSelectedItem];
        
        [[pet allCheckups] createItem];     //creates a new checkup only if a current checkup is not in progress
        
        [newViewController setPet:pet];
        
        [self.navigationController pushViewController:newViewController animated:YES];
    } else {
        //pop a message warning user they need to select a dog
    }
}

- (void) doneEditing:(id)sender
{
    [self setEditing:NO animated:YES];
}

- (void) editPet:(id)sender
{

    //create a new pet item and add it to the store
    DoggieDentalAddPetController2 *petViewController = [[DoggieDentalAddPetController2 alloc] initWithStyle:UITableViewStyleGrouped];
    DoggieDentalPetProfile *pet = [[DoggieDentalPetStore sharedStore] returnSelectedItem];
    [petViewController setPet:pet];
    [petViewController setEditPet:YES];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:petViewController];
    
    //[self.navigationController pushViewController:petViewController animated:YES];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] setBackgroundView:nil];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
        
    //Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"DoggieDentalPetUITableViewCell" bundle:nil];
    
    //Register this NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"DoggieDentalPetUITableViewCell"];
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
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DoggieDentalPetStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...

    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    DoggieDentalPetProfile *pet = [[DoggieDentalPetProfile alloc] init];
    pet = [[[DoggieDentalPetStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[pet description]];
    if ([pet selected]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    */
        
    DoggieDentalPetProfile *pet = [[DoggieDentalPetProfile alloc] init];
    pet = [[[DoggieDentalPetStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    DoggieDentalPetUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoggieDentalPetUITableViewCell"];
    
    [[cell petNameLabel] setText:[pet petName]];
    [[cell petDescriptionLabel] setText:[NSString stringWithFormat:@"The %@ %@", [pet petGender], [pet petBreed]]];
    [[cell petDescriptionLabel] setTextColor:[UIColor darkGrayColor]];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    DoggieDentalPetProfile *pet = [[[DoggieDentalPetStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[DoggieDentalPetStore sharedStore] selectItem:pet];
    //[tableView reloadData];
    
    DoggieDentalDentalPhotosController *newViewController = [[DoggieDentalDentalPhotosController alloc] init];
    pet = [[DoggieDentalPetStore sharedStore] returnSelectedItem];
    [[pet allCheckups] createItem];     //creates a new checkup only if a current checkup is not in progress
    [newViewController setPet:pet];
    
    [self.navigationController pushViewController:newViewController animated:YES];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 //return 80.0;
 return 10.0;
}
*/

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
*/

    /*
    CGFloat buttonWidth = 160;
    CGFloat buttonHeight = 50;
    DoggieDentalButton *newButton = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.tableView.bounds.size.width / 2) - ( buttonWidth / 2), 20.0, buttonWidth, buttonHeight)];
    [newButton setColorGradient:0];
    [newButton setTitle:@"Add New Pet" forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(createNewPet:) forControlEvents:UIControlEventTouchUpInside];
    newButton.layer.cornerRadius = 10;
    newButton.clipsToBounds = YES;
    
     
    UIView *myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 80)];
    */
    
    
    
    /*
    UIButton *flatButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 6, myHeaderView.frame.size.width - 12, myHeaderView.frame.size.height - 12)];
    //flatButton.backgroundColor = [UIColor colorWithRed: (133/255.0) green: (180/255.0) blue: (4/255.0) alpha:1.0]; //GREEN
    //flatButton.backgroundColor = [UIColor colorWithRed: (219/255.0) green: (66/255.0) blue: (39/255.0) alpha:1.0]; //RED
    flatButton.backgroundColor = [UIColor grayColor];
    //flatButton.backgroundColor = [UIColor lightTextColor];
    [flatButton setTitle:@"Add Pet" forState:UIControlStateNormal];
    [flatButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [flatButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [flatButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [flatButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    flatButton.layer.cornerRadius = 4;
    flatButton.layer.borderWidth = 2;
    [flatButton.layer setBorderColor:[[UIColor blueColor] CGColor]];
    flatButton.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithRed:112/255.0 green:153/25.0 blue:0.0 alpha:1.0]);
    [flatButton addTarget:self action:@selector(createNewPet:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    /*
    [myHeaderView setBackgroundColor:[UIColor clearColor]];
    
    //add newButton to footer view
    [myHeaderView addSubview:newButton];
     */
    
    /*
    UIView *myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    myHeaderView.backgroundColor = [UIColor grayColor];
    */
    /*
    return myHeaderView;

}
*/


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
     // Return NO if you do not want the specified item to be editable.
     //return YES;
    return 3;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DoggieDentalPetProfile *pet = [[[DoggieDentalPetStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[DoggieDentalPetStore sharedStore] selectItem:pet];
    
    //change buttons at top
    button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
    [button setColorGradient:0];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
    [button addTarget:self action:@selector(doneEditing:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:button];
    [[self navigationItem] setLeftBarButtonItem:lbbi];
    
  
    button2 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
    [button2 setColorGradient:0];
    [button2 setTitle:@"Edit" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [button2.layer setCornerRadius:4.0f];
    [button2.layer setMasksToBounds:YES];
    [button2.layer setBorderWidth:1.0f];
    [button2.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
    [button2 addTarget:self action:@selector(editPet:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:button2];
    [[self navigationItem] setRightBarButtonItem:rbbi];
   
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self endPetEditing];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Always call super's implementation...
    [super setEditing:editing animated:animated];
    
    // You need to insert/remove an new row
    if (!editing) {
        [self endPetEditing];
    }
}

- (void) endPetEditing {

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
    
    /*
    button2 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
    [button2 setColorGradient:1];
    [button2 setTitle:@"Next" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [button2.layer setCornerRadius:4.0f];
    [button2.layer setMasksToBounds:YES];
    [button2.layer setBorderWidth:1.0f];
    [button2.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
    [button2 addTarget:self action:@selector(takeDentalPhotos:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:button2];
    [[self navigationItem] setRightBarButtonItem:rbbi];
     */
    
    [[self navigationItem] setRightBarButtonItem:nil];
 
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DoggieDentalPetStore *ps = [DoggieDentalPetStore sharedStore];
        NSArray *items = [ps allItems];
        DoggieDentalPetProfile *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)createNewPet:(id)sender
{
    //create a new pet item and add it to the store
    DoggieDentalPetProfile *newPet = [[DoggieDentalPetStore sharedStore] createItem];
    
    DoggieDentalAddPetController2 *petViewController = [[DoggieDentalAddPetController2 alloc] initWithStyle:UITableViewStyleGrouped];
    
    [petViewController setPet:newPet];
    [petViewController setEditPet:NO];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:petViewController];
    
    //[self.navigationController pushViewController:petViewController animated:YES];
    [self presentViewController:navigationController animated:YES completion:nil];
}

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



@end
