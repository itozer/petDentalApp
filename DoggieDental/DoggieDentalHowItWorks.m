//
//  DoggieDentalHowItWorks.m
//  DoggieDental
//
//  Created by Isaac Tozer on 4/21/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalHowItWorks.h"
#import "DoggieDentalButton.h"
#import <QuartzCore/QuartzCore.h>


@interface DoggieDentalHowItWorks ()

@end

@implementation DoggieDentalHowItWorks

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"How It Works"];
        
        DoggieDentalButton *button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 60.0, 30.0)];
        [button setColorGradient:1];
        [button setTitle:@"Back" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        [button.layer setCornerRadius:4.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor: [[UIColor colorWithRed:(86.0f / 255.0f) green:(116.0f / 255.0f) blue:(3.0f / 255.0f) alpha:1.0f] CGColor]];
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *lbbi = [[UIBarButtonItem alloc] initWithCustomView:button];
        [[self navigationItem] setLeftBarButtonItem:lbbi];
        
    }
    return self;
}

-(void)back: (id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scrollView setFrame:self.view.frame];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, finalParagraph.frame.origin.y + finalParagraph.frame.size.height + 10)];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
