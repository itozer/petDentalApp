//
//  DoggieDentalAccount.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/10/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalAccount.h"
#import "DoggieDentalAccountLogin.h"
#import "DoggieDentalAccountSignUp.h"
#import "DoggieDentalButton.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalAccount ()

@end

@implementation DoggieDentalAccount


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Account"];
        
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
        
        //signup buttons
        CGFloat buttonWidth = 160;
        CGFloat buttonHeight = 50;
        DoggieDentalButton *signup = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), 100.0, buttonWidth, buttonHeight)];
        [signup setColorGradient:0];
        [signup setTitle:@"Sign Up" forState:UIControlStateNormal];
        [signup addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
        signup.layer.cornerRadius = 10;
        signup.clipsToBounds = YES;
        [self.view addSubview:signup];
        
        DoggieDentalButton *login = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), 160.0, buttonWidth, buttonHeight)];
        [login setColorGradient:0];
        [login setTitle:@"Login" forState:UIControlStateNormal];
        [login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        login.layer.cornerRadius = 10;
        login.clipsToBounds = YES;
        [self.view addSubview:login];
    }
    return self;
}

- (void)back:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signUp:(id)sender {
    DoggieDentalAccountSignUp *newViewController = [[DoggieDentalAccountSignUp alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    [newViewController setFromWhere:0];
    [self.navigationController pushViewController:newViewController animated:YES];
    //[self presentViewController:navigationController animated:NO completion:nil];
}

- (void)login:(id)sender {
    DoggieDentalAccountLogin *newViewController = [[DoggieDentalAccountLogin alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    [newViewController setFromWhere:0];
    [self.navigationController pushViewController:newViewController animated:YES];
    //[self presentViewController:navigationController animated:NO completion:nil];

}

@end
