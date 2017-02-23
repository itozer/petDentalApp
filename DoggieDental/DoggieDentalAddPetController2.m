//
//  DoggieDentalAddPetController2.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/3/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalAddPetController2.h"
#import "DoggieDentalPetStore.h"
#import "DoggieDentalPetProfile.h"
#import "DoggieDentalImageStore.h"
#import "DoggieDentalButton.h"
#import <QuartzCore/QuartzCore.h>
#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 3

@interface DoggieDentalAddPetController2 ()

@end

@implementation DoggieDentalAddPetController2

@synthesize pet, petSpeciesList, petGenderList, petSpayNeuterList, petFieldList, petUIPickerIndex, myHeaderView, editPet;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Pet Info"];
        
        DoggieDentalButton *button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button setColorGradient:1];
        [button setTitle:@"Cancel" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button.layer setCornerRadius:4.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:button];
        [[self navigationItem] setLeftBarButtonItem:lbbi];
        
        DoggieDentalButton *button2 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button2 setColorGradient:1];
        [button2 setTitle:@"Save" forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button2.layer setCornerRadius:4.0f];
        [button2.layer setMasksToBounds:YES];
        [button2.layer setBorderWidth:1.0f];
        [button2.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button2 addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [[self navigationItem] setRightBarButtonItem:rbbi];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] setBackgroundView:nil];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
}

- (void)viewDidUnload
{
    petAgeField = nil;
    petBirthdateField = nil;
    petBreedField = nil;
    petDiseasesField = nil;
    petGenderField = nil;
    petGenderList = nil;
    petMedicationsField = nil;
    petNameField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
    
    //if this is the first pet added and none are yet selected. select this pet.
    if (![[DoggieDentalPetStore sharedStore] itemSelected]) {
        [pet setSelected:YES];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (editPet) {
        
        [petSpeciesField setText:[pet petSpecies]];
        [petNameField setText:[pet petName]];
        [petBreedField setText:[pet petBreed]];
        [petGenderField setText:[pet petGender]];
        [petAgeField setText:[pet petAgeString]];
        [petWeightField setText:[pet petWeightString]];
        [petMedicationsField setText:[pet petMedications]];
        [petDiseasesField setText:[pet petDiseases]];
                
    } else {
        
        /*
        //JUST FOR TESTING-----------------------------------------------------
        
        [petSpeciesField setText:@"Dog"];
        [pet setPetSpecies: @"Dog"];
        //Pet Name
        [petNameField setText:@"Bruno"];
        [pet setPetName:@"Bruno"];
        //Pet Breed
        [petBreedField setText:@"Bull dog"];
        [pet setPetBreed:@"Bull dog"];
        //Pet Gender
        [petGenderField setText:@"Male"];
        [pet setPetGender:@"Male"];
        //Pet Age
        [petAgeField setText:@"11"];
        [pet setPetAgeString:@"11"];
        //Pet Weight
        [petWeightField setText:@"45"];
        [pet setPetWeightString:@"45"];
        //Pet Medications
        [petMedicationsField setText:@"Meds"];
        [pet setPetMedications: @"Meds"];
        //Pet Diseases
        [petDiseasesField setText:@"Diseases"];
        [pet setPetDiseases: @"Diseases"];
        //JUST FOR TESTING-----------------------------------------------------
        */
    }
    
    NSString *imageKey = [pet imageKeyProfile];
    if (imageKey) {
        //get image for image key from image store
        UIImage *imageToDisplay = [[DoggieDentalImageStore sharedStore] imageForKey:imageKey];
        
        //use that image to put on the screen in imageView
        [petProfileImageButton setImage:imageToDisplay forState:UIControlStateNormal];
    }
    
}

- (void) hideKeyboard {
    [self.view endEditing:NO];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    // Configure the cell...
    
    // Make cell unselectable
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UITextField* tf = nil;
    int rightPad = 20;
	switch ( indexPath.row ) {
		case 0: {
            //UIPicker
            //cell.textLabel.text = @"Pet Type:";
            [self setPetSpeciesList:[NSMutableArray arrayWithObjects:@"Dog", @"Cat", nil]];
            tf = petSpeciesField = [self makeTextField:[pet petSpecies] placeholder:@"Species"];
            [cell.contentView addSubview:petSpeciesField];
            petUIPickerIndex = 0;
            tf.frame = CGRectMake(rightPad, 12, 64, 30);

            [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit]; //keyboard dismiss
            tf.tag = 0;
            tf.delegate = self ;
            
            UIPickerView *pv = [[UIPickerView alloc] init];
            [pv setDataSource: self];
            [pv setDelegate: self];
            [pv setUserInteractionEnabled:YES];
            [pv setShowsSelectionIndicator:YES];
            [pv selectRow:0 inComponent:0 animated:YES];
            [tf setInputView: pv];
            
            //draw dividing line
            UIView* vertLineView = [[UIView alloc] initWithFrame:CGRectMake(tf.frame.size.width + (rightPad *2), 0, 1, cell.bounds.size.height)];
            vertLineView.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 1.0];
            [cell.contentView addSubview:vertLineView];
            
            //cell.textLabel.text = @"Name:";
			tf = petNameField = [self makeTextField:[pet petName] placeholder:@"Name"];
            [cell.contentView addSubview:petNameField];
            tf.frame = CGRectMake(vertLineView.frame.origin.x + vertLineView.frame.size.width + rightPad, 12, cell.bounds.size.width - (vertLineView.frame.origin.x + vertLineView.frame.size.width + (rightPad *2)), 30);
            
            [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit]; //keyboard dismiss
            [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            tf.tag = 1;
            tf.delegate = self ;
            
			break ;
		}
		case 1: {
            //cell.textLabel.text = @"Breed:";
			tf = petBreedField = [self makeTextField:[pet petBreed] placeholder:@"Breed"];
			[cell.contentView addSubview:petBreedField];
            tf.frame = CGRectMake(rightPad, 12, cell.bounds.size.width - rightPad, 30);
			
            [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit]; //keyboard dismiss
            [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            tf.tag = 2;
            tf.delegate = self ;
            
            break ;
		}
            
		case 2: {
            // might want to use a UIPicker here...
            //cell.textLabel.text = @"Age:";
			tf = petAgeField = [self makeTextField:[pet petAgeString] placeholder:@"Age"];
			petAgeField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:petAgeField];
            tf.frame = CGRectMake(rightPad, 12, (cell.frame.size.width / 3) - (3 * rightPad), 30);
			
            [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit]; //keyboard dismiss
            tf.tag = 3;
            tf.delegate = self ;
            
            //draw dividing line
            UIView* vertLineView = [[UIView alloc] initWithFrame:CGRectMake(tf.frame.size.width + (rightPad *2), 0, 1, cell.bounds.size.height)];
            vertLineView.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 1.0];
            [cell.contentView addSubview:vertLineView];
            
            // might want to use a UIPicker here...
            //cell.textLabel.text = @"Weight:";
			tf = petWeightField = [self makeTextField:[pet petWeightString] placeholder:@"Weight"];
			petWeightField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:petWeightField];
            tf.frame = CGRectMake(vertLineView.frame.origin.x + vertLineView.frame.size.width + rightPad, 12, (cell.frame.size.width / 3) - (2 * rightPad), 30);
            
            [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit]; //keyboard dismiss
            [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            tf.tag = 4;
            tf.delegate = self ;
            
            //draw 2nd dividing line
            vertLineView = [[UIView alloc] initWithFrame:CGRectMake(tf.frame.size.width + tf.frame.origin.x + rightPad, 0, 1, cell.bounds.size.height)];
            vertLineView.backgroundColor = [UIColor colorWithWhite: 0.8 alpha: 1.0];
            [cell.contentView addSubview:vertLineView];
            
            //UIPicker
            //cell.textLabel.text = @"Gender:";
            [self setPetGenderList:[NSMutableArray arrayWithObjects:@"Male", @"Female", nil]];
			tf = petGenderField = [self makeTextField:[pet petGender] placeholder:@"Gender"];
			[cell.contentView addSubview:petGenderField];
            petUIPickerIndex = 1;
            tf.frame = CGRectMake(vertLineView.frame.origin.x + vertLineView.frame.size.width + rightPad, 12, cell.bounds.size.width - (vertLineView.frame.origin.x + vertLineView.frame.size.width + rightPad), 30);
			
            [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit]; //keyboard dismiss
            [tf setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
            tf.tag = 5;
            tf.delegate = self ;
            
            UIPickerView *pv = [[UIPickerView alloc] init];
            [pv setDataSource: self];
            [pv setDelegate: self];
            [pv setUserInteractionEnabled:YES];
            [pv setShowsSelectionIndicator:YES];
            [pv selectRow:0 inComponent:0 animated:YES];
            [tf setInputView: pv];
			
            break ;
		}
		case 3: {
            //cell.textLabel.text = @"Medications:";
			tf = petMedicationsField = [self makeTextField:[pet petMedications] placeholder:@"Medications"];
			[cell.contentView addSubview:petMedicationsField];
            tf.frame = CGRectMake(20, 12, 270, 30);
            
            [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit]; //keyboard dismiss
            [tf setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
            //tf.tag = iTag++;
            tf.delegate = self ;
            
            break ;
		}
		case 4: {
            //cell.textLabel.text = @"Diseases:";
			tf = petDiseasesField = [self makeTextField:[pet petDiseases] placeholder:@"Diseases"];
			[cell.contentView addSubview:petDiseasesField];
            tf.frame = CGRectMake(20, 12, 270, 30);
            
            [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit]; //keyboard dismiss
            [tf setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
            //tf.tag = iTag++;
            tf.delegate = self ;
            
            break ;
		}
	}

    /* removing this for now. i dont see why its relavent
    //UIPicker
    //cell.textLabel.text = @"Spay/Neuter:";
    [self setPetSpayNeuterList:[NSMutableArray arrayWithObjects:@"N/A", @"Spay", @"Neuter", nil]];
    tf = petSpayNeuterField = [self makeTextField:[pet petSpayNeuter] placeholder:@"Spay/Neuter"];
    [cell.contentView addSubview:petSpayNeuterField];
    petUIPickerIndex = 2;
    break ;
    */
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ( textField == petSpeciesField ) {
        if (([[textField text] length] == 0) || [[textField text] isEqualToString:@"Species"]) {
            [textField setText:@"Dog"];
        }
        petUIPickerIndex = 0;
    } else if ( textField == petNameField) {
        if ([[textField text] isEqualToString:@"Name"]) {
            [textField setText:@""];
        }
    } else if ( textField == petBreedField) {
        if ([[textField text] isEqualToString:@"Breed"]) {
            [textField setText:@""];
        }
    } else if ( textField == petAgeField) {
        if ([[textField text] isEqualToString:@"Age"]) {
            [textField setText:@""];
        }
    } else if ( textField == petWeightField) {
        if ([[textField text] isEqualToString:@"Weight"]) {
            [textField setText:@""];
        }
    } else if ( textField == petGenderField) {
        if (([[textField text] length] == 0) || [[textField text] isEqualToString:@"Gender"]) {
            [textField setText:@"Male"];
        }
        petUIPickerIndex = 1;
    }
    [textField setTextColor:[UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f]];
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //Pet Type
    if ( textField == petSpeciesField) {
        [pet setPetSpecies: [textField text]];
    //Pet Name
    } else if ( textField == petNameField ) {
		[pet setPetName:[textField text]];
	//Pet Breed
    } else if ( textField == petBreedField ) {
		[pet setPetBreed:[textField text]];
	//Pet Gender
    } else if ( textField == petGenderField ) {
        [pet setPetGender:[textField text]];
	//Pet Age
    } else if ( textField == petAgeField ) {
        [pet setPetAgeString:[textField text]];
	//Pet Weight
    } else if ( textField == petWeightField ) {
        [pet setPetWeightString:[textField text]];
	//Pet Medications
    } else if ( textField == petMedicationsField ) {
		[pet setPetMedications:[textField text]];
	//Pet Diseases
    } else if ( textField == petDiseasesField ) {
		[pet setPetDiseases:[textField text]];
	}
}

/*
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
   [self setPetFieldList:[NSMutableArray arrayWithObjects:petSpeciesField, petNameField, petBreedField, petGenderField, petAgeField, petWeightField, petSpayNeuterField, petMedicationsField, petDiseasesField, nil]];
 
    NSUInteger i = textField.tag;
    i++;
    UITextField *nextField = [[UITextField alloc] init];
    nextField = [petFieldList objectAtIndex:i];
    [nextField becomeFirstResponder];
    return NO; 
}
*/


-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[UITextField alloc] init];
	tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
	tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
	return tf ;
}

-(UIPickerView*) makeUIPicker: (NSMutableArray*)items
                  placeholder: (NSString*)placeholder  {
	UIPickerView *pv = [[UIPickerView alloc] init];
    [pv setShowsSelectionIndicator:YES];
    //int numRows = [items count];
    //[pv numberOfRowsInComponent:numRows];
	return pv;
}


- (void)cancel: (id)sender
{
    if (![self editPet]) {
        [[DoggieDentalPetStore sharedStore] removeItem:pet];
    }
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)save: (id)sender
{

    BOOL error = NO;
    //do a little error checking
    if (([[petSpeciesField text] length] == 0) || [[petSpeciesField text] isEqualToString:@"Species"]) {
        [petSpeciesField setText:@"Species"];
        [petSpeciesField setTextColor:[UIColor redColor]];
        error = YES;
    } 
    if (([[petNameField text] length] == 0) || [[petNameField text] isEqualToString:@"Name"]) {
        [petNameField setText:@"Name"];
        [petNameField setTextColor:[UIColor redColor]];
        error = YES;
    } 
    if (([[petBreedField text] length] == 0) || [[petBreedField text] isEqualToString:@"Breed"]) {
        [petBreedField setText:@"Breed"];
        [petBreedField setTextColor:[UIColor redColor]];
        error = YES;
    } 
    if (([[petAgeField text] length] == 0) || [[petAgeField text] isEqualToString:@"Age"]) {
        [petAgeField setTextColor:[UIColor redColor]];
        [petAgeField setText:@"Age"];
        error = YES;
    } 
    if (([[petWeightField text] length] == 0) || [[petWeightField text] isEqualToString:@"Weight"]) {
        [petWeightField setText:@"Weight"];
        [petWeightField setTextColor:[UIColor redColor]];
        error = YES;
    }
    if (([[petGenderField text] length] == 0) || [[petGenderField text] isEqualToString:@"Gender"]) {
        [petGenderField setText:@"Gender"];
        [petGenderField setTextColor:[UIColor redColor]];
        error = YES;
    }
    
    if (!error) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
*/


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	//Pet Age or Pet Weight
    if ( textField == petAgeField || textField == petWeightField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return ((([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT)) || [string isEqualToString:@"\n"]);
    } else {
        return YES;
    }
}

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSMutableArray *selectedPicker = [[NSMutableArray alloc] init];
	switch ( petUIPickerIndex ) {
		case 0: {
            selectedPicker = petSpeciesList;
            break;
        }
        case 1: {
            selectedPicker = petGenderList;
            break;
        }
        case 2: {
            selectedPicker = petSpayNeuterList;
            break;
        }
    }
    return [selectedPicker count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSMutableArray *selectedPicker = [[NSMutableArray alloc] init];
	switch ( petUIPickerIndex ) {
		case 0: {
            selectedPicker = petSpeciesList;
            break;
        }
        case 1: {
            selectedPicker = petGenderList;
            break;
        }
        case 2: {
            selectedPicker = petSpayNeuterList;
            break;
        }
    }
    return [selectedPicker objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    NSMutableArray *selectedPicker = [[NSMutableArray alloc] init];
	switch ( petUIPickerIndex ) {
		case 0: {
            selectedPicker = petSpeciesList;
            [petSpeciesField setText: [petSpeciesList objectAtIndex: row]];
            break;
        }
        case 1: {
            selectedPicker = petGenderList;
            [petGenderField setText:[petGenderList objectAtIndex:row]];
            break;
        }
    }
    //NSLog(@"You selected this: %@", [selectedPicker objectAtIndex: row]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    petProfileImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *imageKey = [pet imageKeyProfile];
    UIImage *petProfileImage;
    if (imageKey) {
        //get image for image key from image store
        petProfileImage = [[DoggieDentalImageStore sharedStore] imageForKey:imageKey];
    } else {
        petProfileImage = [UIImage imageNamed:@"generic_contact2"];
    }
    
    [petProfileImageButton setImage:petProfileImage forState:UIControlStateNormal];
    //[petProfileImageButton setFrame:CGRectMake(10, 20, petProfileImage.size.width, petProfileImage.size.height)];
    [petProfileImageButton setFrame:CGRectMake(10, 20, 62, 62)];
    [petProfileImageButton addTarget:self action:@selector(takeProfilePhoto:) forControlEvents:UIControlEventTouchUpInside];

    //[self setMyFooterView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, petProfileImage.size.height + 30)]];
    [self setMyHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 62 + 30)]];
    [myHeaderView setBackgroundColor:[UIColor clearColor]];
    
    [myHeaderView addSubview:petProfileImageButton];
    
    //hide keyboard when background tapped
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [myHeaderView addGestureRecognizer:gestureRecognizer];
    
    return myHeaderView;
    
}

- (void)takeProfilePhoto:(id)sender
{
    //show action sheet to let user pick existing photo or take a new one
    UIActionSheet *photoMenu = [[UIActionSheet alloc]
                             initWithTitle:nil
                             delegate:self
                             cancelButtonTitle:nil
                             destructiveButtonTitle:nil
                             otherButtonTitles:nil];
    

    [photoMenu addButtonWithTitle:@"Take Photo"];
    [photoMenu addButtonWithTitle:@"Choose Existing"];

    photoMenu.cancelButtonIndex = [photoMenu addButtonWithTitle: @"Cancel"];
    
    [photoMenu showInView:self.view];
    
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [pet imageKeyProfile];
    if (oldKey) {
        //delete the old image
        [[DoggieDentalImageStore sharedStore] deleteImageForKey: oldKey];
    }
    
    //get picked image from info dicionary
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [pet setThumbnailDataFromImage:image];
    
    //create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    //generate  string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    //use unique id to set items imageKey
    NSString *key = (__bridge NSString *) newUniqueIDString;
    [pet setImageKeyProfile:key];
    
    // store image in the BNRImageStore with this key
    [[DoggieDentalImageStore sharedStore] setImage:image forKey:[pet imageKeyProfile]];
    
    //release memory - ARC cannot get rid of these because they are core foundation objects
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    // put that image onto the screen in our image view
    //[imageView setImage:image];
    
    // take image picker off the screen
    // you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (!(buttonIndex == 2)) {

         UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
         
         [imagePicker setAllowsEditing:YES];
         
        if (buttonIndex == 0 ) {    //take photo
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }
        else if (buttonIndex == 1) {    //choose existing
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        [imagePicker setDelegate:self];
         
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
     
}


@end
