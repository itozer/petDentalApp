//
//  DoggieDentalDentalPhotosController.m
//  DoggieDental
//
//  Created by Isaac Tozer on 10/6/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalDentalPhotosController.h"
#import "DoggieDentalPetStore.h"
#import "DoggieDentalPetProfile.h"
#import "DoggieDentalImageStore.h"
#import "DoggieDentalAccount.h"
#import "DoggieDentalButton.h"
#import "DoggieDentalExamplePhoto.h"
#import "DoggieDentalCheckup.h"
#import "DoggieDentalCheckupStore.h"
#import "DoggieDentalPaymentInfo.h"
#import "KDJKeychainItemWrapper.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalDentalPhotosController ()

@end

@implementation DoggieDentalDentalPhotosController

@synthesize pet, imagePickerReference;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"2. Dental Photos"];
                
        DoggieDentalButton *button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button setColorGradient:1];
        [button setTitle:@"Back" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button.layer setCornerRadius:4.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button addTarget:self action:@selector(backToPetList:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:button];
        [[self navigationItem] setLeftBarButtonItem:lbbi];
        
        DoggieDentalButton *button2 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button2 setColorGradient:1];
        [button2 setTitle:@"Next" forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button2.layer setCornerRadius:4.0f];
        [button2.layer setMasksToBounds:YES];
        [button2.layer setBorderWidth:1.0f];
        [button2.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button2 addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rbbi = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [[self navigationItem] setRightBarButtonItem:rbbi];
        
    }
    return self;
}


- (void)next:(id)sender
{
    
    //make sure all required photos have been added
    BOOL next = YES;
    if (![[[pet allCheckups] currentCheckup] imageKeyFront]) next = NO;
    if (![[[pet allCheckups] currentCheckup] imageKeyLeft]) next = NO;
    if (![[[pet allCheckups] currentCheckup] imageKeyRight]) next = NO;
    
    if (next) {
        
        //check to see if the user is logged in already. if not, log them in.
        NSString *user = [[NSString alloc] init];
        NSString *pass = [[NSString alloc] init];
        KDJKeychainItemWrapper *keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        user = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
        pass = [keychain objectForKey:(__bridge id)(kSecValueData)];
        BOOL loggedIN = [[keychain objectForKey:(__bridge id)(kSecAttrDescription)] boolValue];
        
        if (loggedIN && ([user length] > 0) && ([pass length] > 0)) {
        
            DoggieDentalPaymentInfo *newViewController = [[DoggieDentalPaymentInfo alloc] init];
            [newViewController setPet:pet];
            [self.navigationController pushViewController:newViewController animated:YES];
            
        } else {
            DoggieDentalAccount *newViewController = [[DoggieDentalAccount alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Please take, or choose an existing photo for the front, left, and right dental photo views."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        //if i want to color the photo red or something.
}

- (void)backToPetList:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    NSString *imageKey;
    for (int i = 0; i < 4; i++) {
        switch (i) {
            case 0:
                //imageKey = [pet imageKeyFront];
                imageKey = [[[pet allCheckups] currentCheckup] imageKeyFront];
                break;
            case 1:
                //imageKey = [pet imageKeyLeft];
                imageKey = [[[pet allCheckups] currentCheckup] imageKeyLeft];
                break;
            case 2:
                //imageKey = [pet imageKeyRight];
                imageKey = [[[pet allCheckups] currentCheckup] imageKeyRight];
                break;
            case 3:
                //imageKey = [pet imageKeyOptional];
                imageKey = [[[pet allCheckups] currentCheckup] imageKeyOptional];
                break;
            default:
                //wah wahh
                break;
        }
        
        if (imageKey) {
            //get image for image key from image store
            UIImage *imageToDisplay = [[DoggieDentalImageStore sharedStore] imageForKey:imageKey];
            
            //use that image to put on the screen in imageView
            switch (i) {
                case 0:
                    [frontImageView setImage:imageToDisplay];
                    break;
                case 1:
                    [leftImageView setImage:imageToDisplay];
                    break;
                case 2:
                    [rightImageView setImage:imageToDisplay];
                    break;
                case 3:
                    [optionalImageView setImage:imageToDisplay];
                    break;
                default:
                    //wah wahh
                    break;
            }
            
        }
    }
    //[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    //CREATE SAMPLE BUTTONS***********
    
    [frontImageButton setColorGradient:0];
    [frontImageButton addObserver:frontImageButton forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    [frontImageButton.layer setCornerRadius:4.0f];
    [frontImageButton.layer setMasksToBounds:YES];
    //[frontImageButton.layer setBorderWidth:1.0f];
    //[frontImageButton.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
    
    [leftImageButton setColorGradient:0];
    [leftImageButton addObserver:leftImageButton forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    [leftImageButton.layer setCornerRadius:4.0f];
    [leftImageButton.layer setMasksToBounds:YES];
    //[leftImageButton.layer setBorderWidth:1.0f];
    //[leftImageButton.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
    
    [rightImageButton setColorGradient:0];
    [rightImageButton addObserver:rightImageButton forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    [rightImageButton.layer setCornerRadius:4.0f];
    [rightImageButton.layer setMasksToBounds:YES];
    //[rightImageButton.layer setBorderWidth:1.0f];
    //[rightImageButton.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
    
    [optionalImageButton setColorGradient:0];
    [optionalImageButton addObserver:optionalImageButton forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    [optionalImageButton.layer setCornerRadius:4.0f];
    [optionalImageButton.layer setMasksToBounds:YES];
    //[optionalImageButton.layer setBorderWidth:1.0f];
    //[optionalImageButton.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
    
    //***********CREATE SAMPLE BUTTONS
    
    
}

- (void)viewDidUnload
{
    frontImageView = nil;
    leftImageView = nil;
    rightImageView = nil;
    optionalImageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)takeFrontPicture:(id)sender
{
    [self setImagePickerReference:0];
    //show action sheet to let user pick existing photo or take a new one
    UIActionSheet *photoMenu = [[UIActionSheet alloc]
                 initWithTitle:nil
                 delegate:self
                 cancelButtonTitle:nil
                 destructiveButtonTitle:nil
                 otherButtonTitles:nil];
    
    [photoMenu addButtonWithTitle:@"Take Photo"];
    [photoMenu addButtonWithTitle:@"Choose Existing"];
    //[photoMenu addButtonWithTitle:@"See Example"];
    
    photoMenu.cancelButtonIndex = [photoMenu addButtonWithTitle: @"Cancel"];
    [photoMenu showInView:self.view];
}

- (IBAction)takeLeftPicture:(id)sender
{
    [self setImagePickerReference:1];
    
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

- (IBAction)takeRightPicture:(id)sender
{
    [self setImagePickerReference:2];
    
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

- (IBAction)takeOptionalPicture:(id)sender
{
    [self setImagePickerReference:3];
    
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

- (IBAction)showFrontExample:(id)sender {
    
    DoggieDentalExamplePhoto *newViewController = [[DoggieDentalExamplePhoto alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    [newViewController setPhotoView:0];
    [newViewController setPetSpeciesIndex:[pet petSpeciesIndex]];
    [self presentViewController:navigationController animated:YES completion: nil];
    
}

- (IBAction)showLeftExample:(id)sender {
    
    DoggieDentalExamplePhoto *newViewController = [[DoggieDentalExamplePhoto alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    [newViewController setPhotoView:1];
    [newViewController setPetSpeciesIndex:[pet petSpeciesIndex]];
    [self presentViewController:navigationController animated:YES completion: nil];
    
}

- (IBAction)showRightExample:(id)sender {
    
    DoggieDentalExamplePhoto *newViewController = [[DoggieDentalExamplePhoto alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    [newViewController setPhotoView:2];
    [newViewController setPetSpeciesIndex:[pet petSpeciesIndex]];
    [self presentViewController:navigationController animated:YES completion: nil];
    
}

- (IBAction)showOptionalExample:(id)sender {
    
    DoggieDentalExamplePhoto *newViewController = [[DoggieDentalExamplePhoto alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    [newViewController setPhotoView:3];
    [newViewController setPetSpeciesIndex:[pet petSpeciesIndex]];
    [self presentViewController:navigationController animated:YES completion: nil];
    
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey;
    switch ([self imagePickerReference]) {
        case 0:
            //oldKey = [pet imageKeyFront];
            oldKey = [[[pet allCheckups] currentCheckup] imageKeyFront];
            break;
        case 1:
            //oldKey = [pet imageKeyLeft];
            oldKey = [[[pet allCheckups] currentCheckup] imageKeyLeft];
            break;
        case 2:
            //oldKey = [pet imageKeyRight];
            oldKey = [[[pet allCheckups] currentCheckup] imageKeyRight];
            break;
        case 3:
            //oldKey = [pet imageKeyOptional];
            oldKey = [[[pet allCheckups] currentCheckup] imageKeyOptional];
            break;
        default:
            //wah wahh
            break;
    }
    
    if (oldKey) {
        //delete the old image
        [[DoggieDentalImageStore sharedStore] deleteImageForKey: oldKey];
    }
    
    //get picked image from info dicionary
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //create a CFUUID object - it knows how to create unique identifier strings
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    //generate  string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    //use unique id to set items imageKey
    NSString *key = (__bridge NSString *) newUniqueIDString;
    switch ([self imagePickerReference]) {
        case 0:
            //[pet setImageKeyFront:key];
            [[[pet allCheckups] currentCheckup] setImageKeyFront:key];
            break;
        case 1:
            //[pet setImageKeyLeft:key];
            [[[pet allCheckups] currentCheckup] setImageKeyLeft:key];
            break;
        case 2:
            //[pet setImageKeyRight:key];
            [[[pet allCheckups] currentCheckup] setImageKeyRight:key];
            break;
        case 3:
            //[pet setImageKeyOptional:key];
            [[[pet allCheckups] currentCheckup] setImageKeyOptional:key];
            break;
        default:
            //wah wahh
            break;
    }
    
    // store image in the BNRImageStore with this key
    switch ([self imagePickerReference]) {
        case 0:
            //[[DoggieDentalImageStore sharedStore] setImage:image forKey:[pet imageKeyFront]];
            [[DoggieDentalImageStore sharedStore] setImage:image forKey:[[[pet allCheckups] currentCheckup] imageKeyFront]];
            break;
        case 1:
            [[DoggieDentalImageStore sharedStore] setImage:image forKey:[[[pet allCheckups] currentCheckup] imageKeyLeft]];
            break;
        case 2:
            [[DoggieDentalImageStore sharedStore] setImage:image forKey:[[[pet allCheckups] currentCheckup] imageKeyRight]];
            break;
        case 3:
            [[DoggieDentalImageStore sharedStore] setImage:image forKey:[[[pet allCheckups] currentCheckup] imageKeyOptional]];
            break;
        default:
            //wah wahh
            break;
    }
    
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
