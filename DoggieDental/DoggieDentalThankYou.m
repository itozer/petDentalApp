//
//  DoggieDentalThankYou.m
//  DoggieDental
//
//  Created by Isaac Tozer on 4/15/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalThankYou.h"
#import "DoggieDentalButton.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalThankYou ()

@end

@implementation DoggieDentalThankYou

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Thank You!"];
        
        [[self navigationItem] setHidesBackButton:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    //USER TEXT
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    UILabel *pageText = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, (width - 80), 100)];
    pageText.text = [NSString stringWithFormat:@"Thank you for using Pet Dental! You will receive an email and notification in no more than 48 hours letting you know your checkup is complete."];
    pageText.lineBreakMode = NSLineBreakByWordWrapping;
    pageText.numberOfLines = 0;
    [pageText sizeToFit];
    CGFloat height = pageText.frame.size.height + 40;
    UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 80, (width - 40), height)];
    [textContainer setBackgroundColor:[UIColor whiteColor]];
    textContainer.clipsToBounds = YES;
    textContainer.layer.cornerRadius = 4.0f;
    textContainer.layer.borderWidth = 1.0f;
    textContainer.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor];
    [textContainer addSubview:pageText];
    [[self view] addSubview:textContainer];
    
    //home button
    CGFloat buttonWidth = 160;
    CGFloat buttonHeight = 50;
    DoggieDentalButton *signup = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), textContainer.frame.size.height + textContainer.frame.origin.y + 20, buttonWidth, buttonHeight)];
    [signup setColorGradient:0];
    [signup setTitle:@"Home" forState:UIControlStateNormal];
    [signup addTarget:self action:@selector(homeButton:) forControlEvents:UIControlEventTouchUpInside];
    signup.layer.cornerRadius = 10;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)homeButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
