//
//  DoggieDentalAddPetController2.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/3/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoggieDentalPetProfile;

@interface DoggieDentalAddPetController2 : UITableViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {
    
    UIView *myFooterView;
    
    UITextField *petSpeciesField;
    UITextField *petNameField;
	UITextField *petBreedField;
    UITextField *petBirthdateField;
    UITextField *petAgeField;
    UITextField *petWeightField;
    UITextField *petGenderField;
    UITextField *petMedicationsField;
    UITextField *petDiseasesField;
    
    UIButton *petProfileImageButton;
}

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder;

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender ;

@property BOOL editPet;
@property (nonatomic, strong) DoggieDentalPetProfile *pet;
@property (nonatomic) NSMutableArray *petSpeciesList;
@property (nonatomic) NSMutableArray *petGenderList;
@property (nonatomic) NSMutableArray *petSpayNeuterList;
@property (nonatomic) NSMutableArray *petFieldList;
@property (nonatomic) int petUIPickerIndex;  //0 = pet type, 1 = pet gender, 2 = spay/neuter
@property (nonatomic, retain) IBOutlet UIView *myHeaderView;


@end
