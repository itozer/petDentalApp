//
//  DoggieDentalDentalPhotosController.h
//  DoggieDental
//
//  Created by Isaac Tozer on 10/6/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoggieDentalPetProfile, DoggieDentalButton;

@interface DoggieDentalDentalPhotosController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
{
    __weak IBOutlet UIImageView *frontImageView;
    __weak IBOutlet UIImageView *leftImageView;
    __weak IBOutlet UIImageView *rightImageView;
    __weak IBOutlet UIImageView *optionalImageView;
    __weak IBOutlet DoggieDentalButton *frontImageButton;
    __weak IBOutlet DoggieDentalButton *leftImageButton;
    __weak IBOutlet DoggieDentalButton *rightImageButton;
    __weak IBOutlet DoggieDentalButton *optionalImageButton;
    
    
}

@property (nonatomic, strong) DoggieDentalPetProfile *pet;
@property (nonatomic) int imagePickerReference;      // 0 = front, 1 = left, 2 = right, 3 = optional

- (IBAction)takeFrontPicture:(id)sender;
- (IBAction)takeLeftPicture:(id)sender;
- (IBAction)takeRightPicture:(id)sender;
- (IBAction)takeOptionalPicture:(id)sender;
- (IBAction)showFrontExample:(id)sender;
- (IBAction)showLeftExample:(id)sender;
- (IBAction)showRightExample:(id)sender;
- (IBAction)showOptionalExample:(id)sender;

@end
