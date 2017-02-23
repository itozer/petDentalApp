//
//  DoggieDentalExamplePhoto.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/23/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalExamplePhoto.h"
#import "DoggieDentalButton.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalExamplePhoto ()

@end

@implementation DoggieDentalExamplePhoto

@synthesize petSpeciesIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Sample Photo"];
        
        DoggieDentalButton *button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button setColorGradient:1];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button.layer setCornerRadius:4.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button addTarget:self action:@selector(backToDentalPhotos:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:button];
        [[self navigationItem] setLeftBarButtonItem:lbbi];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    NSString *caption = [[NSString alloc] init];
    
    switch (petSpeciesIndex) {
        case 0:     //dog
            switch (_photoView) {
                case 0:
                    [sampleImage setImage: [UIImage imageNamed:@"front"]];
                    //[sampleImageCaption setText:@"Pay special attention and make sure the image is focused well and shows exposed gums."];
                    caption = @"Pay special attention and make sure the image is focused well and shows exposed gums";
                    break;
                case 1:
                    [sampleImage setImage: [UIImage imageNamed:@"left"]];
                    //[sampleImageCaption setText:@"Pay special attention and make sure you get the back molars in your photo as shown. Also make sure the image is focused well and shows exposed gums"];
                    caption = @"Pay special attention and make sure you get the back molars in your photo as shown. Also make sure the image is focused well and shows exposed gums";
                    
                    break;
                case 2:
                    [sampleImage setImage: [UIImage imageNamed:@"right"]];
                    //[sampleImageCaption setText:@"Pay special attention and make sure you get the back molars in your photo as shown. Also make sure the image is focused well and shows exposed gums."];
                    caption = @"Pay special attention and make sure you get the back molars in your photo as shown. Also make sure the image is focused well and shows exposed gums";
                    break;
                case 3:
                    [sampleImage setImage: [UIImage imageNamed:@"dog_optional"]];
                    //[sampleImageCaption setText:@"If there is a specific problem area you want to highlight, or if you just want to show us how awesome your dog is, you can use this optional image."];
                    caption = @"If there is a specific problem area you want to highlight, or if you just want to show us how awesome your dog is, you can use this optional image.";
                    break;
                default:
                    break;
            }
            break;
            
        case 1:     //cat
            switch (_photoView) {
                case 0:
                    [sampleImage setImage: [UIImage imageNamed:@"cat_front"]];
                    //[sampleImageCaption setText:@"Pay special attention and make sure the image is focused well and shows exposed gums."];
                    caption = @"Pay special attention and make sure the image is focused well and shows exposed gums";
                    break;
                case 1:
                    [sampleImage setImage: [UIImage imageNamed:@"cat_left"]];
                    //[sampleImageCaption setText:@"Pay special attention and make sure you get the back molars in your photo as shown. Also make sure the image is focused well and shows exposed gums."];
                    caption = @"Pay special attention and make sure you get the back molars in your photo as shown. Also make sure the image is focused well and shows exposed gums";
                    break;
                case 2:
                    [sampleImage setImage: [UIImage imageNamed:@"cat_right"]];
                    //[sampleImageCaption setText:@"Pay special attention and make sure you get the back molars in your photo as shown. Also make sure the image is focused well and shows exposed gums."];
                    caption = @"Pay special attention and make sure you get the back molars in your photo as shown. Also make sure the image is focused well and shows exposed gums";
                    break;
                case 3:
                    [sampleImage setImage: [UIImage imageNamed:@"cat_optional"]];
                    //[sampleImageCaption setText:@"If there is a specific problem area you want to highlight, or if you just want to show us how cute your cat is, you can use this optional image."];
                    caption = @"If there is a specific problem area you want to highlight, or if you just want to show us how awesome your cat is, you can use this optional image.";
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    UILabel *captionText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
    captionText.text = caption;
    captionText.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    captionText.lineBreakMode = NSLineBreakByWordWrapping;
    captionText.numberOfLines = 0;
    [captionText sizeToFit];
    
    CGFloat height = captionText.frame.size.height + 20;
    UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(10, sampleImage.frame.origin.y + sampleImage.frame.size.height + 6, (width - 20), height)];
    [textContainer setBackgroundColor:[UIColor whiteColor]];
    textContainer.clipsToBounds = YES;
    textContainer.layer.cornerRadius = 4.0f;
    textContainer.layer.borderWidth = 1.0f;
    textContainer.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor];
    [textContainer addSubview:captionText];
    [[self view] addSubview:textContainer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToDentalPhotos: (id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
