//
//  DoggieDentalLoggedIn.m
//  DoggieDental
//
//  Created by Isaac Tozer on 7/18/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalLoggedIn.h"
#import "DoggieDentalButton.h"
#import "DoggieDentalChangeAccountEmail.h"
#import "DoggieDentalChangeAccountPassword.h"
#import "KDJKeychainItemWrapper.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalLoggedIn ()

@end

@implementation DoggieDentalLoggedIn

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    //add buttons
    //change email address
    CGFloat buttonWidth = 160;
    CGFloat buttonHeight = 50;
    
    DoggieDentalButton *newButton = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), 220.0, buttonWidth, buttonHeight)];
    [newButton setColorGradient:0];
    [newButton setTitle:@"Change Email" forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(changeEmailAddress:) forControlEvents:UIControlEventTouchUpInside];
    newButton.layer.cornerRadius = 10;
    newButton.clipsToBounds = YES;
    
    DoggieDentalButton *newButton2 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), 280.0, buttonWidth, buttonHeight)];
    [newButton2 setColorGradient:0];
    [newButton2 setTitle:@"Change Password" forState:UIControlStateNormal];
    [newButton2 addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
    newButton2.layer.cornerRadius = 10;
    newButton2.clipsToBounds = YES;
    
    DoggieDentalButton *newButton3 = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), 340.0, buttonWidth, buttonHeight)];
    [newButton3 setColorGradient:0];
    [newButton3 setTitle:@"Logout" forState:UIControlStateNormal];
    [newButton3 addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    newButton3.layer.cornerRadius = 10;
    newButton3.clipsToBounds = YES;
    
    [self.view addSubview:newButton];
    [self.view addSubview:newButton2];
    [self.view addSubview:newButton3];
    
    keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
    [[self accountEmail] setText:[keychain objectForKey:(__bridge id)(kSecAttrAccount)]];
}

- (void) logout: (id) sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to logout?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //log user out
    if (buttonIndex == 0) {
        //clear keychain
        keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        [keychain setObject:@"" forKey:(__bridge id)(kSecAttrAccount)];
        [keychain setObject:@"" forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:@"NO" forKey:(__bridge id)(kSecAttrDescription)];

        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) changeEmailAddress: (id) sender
{
    DoggieDentalChangeAccountEmail *newViewController = [[DoggieDentalChangeAccountEmail alloc] init];
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void) changePassword: (id) sender
{
    DoggieDentalChangeAccountPassword *newViewController = [[DoggieDentalChangeAccountPassword alloc] init];
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
