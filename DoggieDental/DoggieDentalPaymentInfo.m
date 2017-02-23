//
//  DoggieDentalPaymentInfo.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/10/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalPaymentInfo.h"
#import "DoggieDentalPetProfile.h"
#import "DoggieDentalCheckup.h"
#import "DoggieDentalCheckupStore.h"
#import "DoggieDentalImageStore.h"
#import "DoggieDentalButton.h"
#import "DoggieDentalThankYou.h"
#import "KDJKeychainItemWrapper.h"
#import "DoggieDentalAccount.h"
#import "DoggieDentalInAppPurchase.h"
#import "DoggieDentalCheckupPost.h"
#import "DoggieDentalPetStore.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalPaymentInfo ()

@end

@implementation DoggieDentalPaymentInfo

@synthesize pet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"3. Submit Checkup"];
        
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    receivedData = [[NSMutableData alloc] init];
    
    //for spinner
    spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
    spinnerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(self.navigationController.view.frame.size.width/2.0, self.navigationController.view.frame.size.height/2.0)];
    [spinnerView addSubview:spinner];
    [spinnerView setHidden:YES];
    [self.navigationController.view addSubview:spinnerView];
        
    optionalPicture = [[[pet allCheckups] currentCheckup] imageKeyOptional] ? YES : NO;
    
    //USER TEXT
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    UILabel *pageText = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, (width - 80), 100)];
    pageText.text = [NSString stringWithFormat:@"After you submit %@’s dental checkup, our certified veterinarians will analyze your pets info and photos within 48 hours, and return professional results and recommendations on how to keep %@ mouth healthy and happy.", [pet petName], ([pet petGenderIndex] == 0? @"his": @"her")];
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
    
    CGFloat buttonWidth = 160;
    CGFloat buttonHeight = 50;
    NSString *buttonTitle = @"Purchase (4.99)";
    DoggieDentalButton *newButton = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), textContainer.frame.size.height + textContainer.frame.origin.y + 20, buttonWidth, buttonHeight)];
    [newButton setColorGradient:0];
    [newButton setTitle:buttonTitle forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(continueButton:) forControlEvents:UIControlEventTouchUpInside];
    newButton.layer.cornerRadius = 10;
    newButton.clipsToBounds = YES;
    [[self view] addSubview:newButton];
    
    //temp button
    /*
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, textContainer.frame.size.height + 90, 100, 30)];
    [btn setTitle: buttonTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(continueButton:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:btn];
    */
    
    numberOfTries = 0;
}

- (void)viewWillAppear:(BOOL)animated {

/*
    //this is the notification sent from iTunes store if purchase is successfull
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iTunesPurchaseResponse:)
                                                 name:@"IAPHelperProductPurchasedNotification"
                                               object:nil];
*/
    
    //this is the notification sent from iTunes store if purchase has failed (user cancelled)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(transactionFail:)
                                                 name:@"failedTransaction"
                                               object:nil];
    
    //this is the notification sent from CheckupPost that posts checkup data to web server
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postCheckupResponse:)
                                                 name:@"checkupPost"
                                               object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)continueButton:(id)sender
{
    //There can only be 1 transaction in process at a time. Program logic is dependant on this assumption.
    if (![[DoggieDentalPetStore sharedStore] transactionInProgress]) {
        
        [spinner startAnimating];
        [spinnerView setHidden:NO];
        
        NSString *user = [[NSString alloc] init];
        NSString *pass = [[NSString alloc] init];
        KDJKeychainItemWrapper *keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        user = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
        pass = [keychain objectForKey:(__bridge id)(kSecValueData)];
        BOOL loggedIn = [[keychain objectForKey:(__bridge id)(kSecAttrDescription)] boolValue];
    
        if (loggedIn && ([user length] > 0) && ([pass length] > 0)) {
            
            //first ask iTunes for product information
            [[DoggieDentalInAppPurchase sharedStore] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
                if (success && (products.count > 0)) {
                    _products = products;
                    NSLog(@"Products retrieved from iTunes");
                    
                    [[[pet allCheckups] currentCheckup] setTransactionStatus:1]; //1 = iTunes transaction in progress
                    //save pets now in case of program crash. I need to know that this payment is in process
                    BOOL success = [[DoggieDentalPetStore sharedStore] saveChanges];
                    if (success) {
                        NSLog(@"saved pets. iTunesPurchase");
                    } else {
                        NSLog(@"save pets fail. iTunesPurchase");
                    }
                    
                    //*********make iTunes purchase
                    //do i want to use the notification??
                    //V2 I should make this dynamic
                    //Application enters background when buyProduct is called???!!
                    NSLog(@"Buying %@...", _products[0]);
                    SKProduct *product = _products[0];
                    [[DoggieDentalInAppPurchase sharedStore] buyProduct:product];
                    
                } else {
                    // pop up mesage to user saying we could not connect to iTunes
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                    message:@"Could not connect to iTunes. Please try again"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
        
                }
            }];
            
            //****blocks are asynchronous. this code will get called before itunes responds and the block finishes.
         
        } else {
            //login user
            DoggieDentalAccount *newViewController = [[DoggieDentalAccount alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"We are still processing your last checkup. Please try again later."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }

}

- (void)transactionFail: (NSNotification *)notification {
    
    NSDictionary *postDictionary = [notification userInfo];
    SKPaymentTransaction *transaction = [postDictionary objectForKey:@"error"];
    //NSLog(@"error: %ld", (long)transaction.error.code);
    //when canceling on fingerprint/password the error message 0 gets thrown.
    if (transaction.error.code != SKErrorPaymentCancelled && transaction.error.code != 0)
    {
        //NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iTunes transaction error."
                                                        message:transaction.error.localizedDescription
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    [spinner stopAnimating];
    [spinnerView setHidden:YES];
}


//this is the response from the checkupPost object.
- (void)postCheckupResponse:(NSNotification *)notification {
    NSLog(@"Checkup post complete.");

    //look at dictionary item "success" for status of post
    NSDictionary *postDictionary = [notification userInfo];
    if ([[postDictionary objectForKey:@"success"] boolValue]) {
        
        [spinner stopAnimating];
        [spinnerView setHidden:YES];
        
        DoggieDentalThankYou *newViewController = [[DoggieDentalThankYou alloc] init];
        [self.navigationController pushViewController:newViewController animated:YES];
        
    } else {
        //post to pet dental servers failed
        NSLog(@"Post to Pet Dental Servers failed");
        
        //try 1 more time.
        if (numberOfTries < 1) {
            numberOfTries++;
            [[DoggieDentalCheckupPost sharedStore] postCheckup];
        } else {
            //otherwise, tell user we suck
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!"
                                                            message:@"We're sorry, there was an error submitting your checkup. We will try submitting again next time you log in."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [spinner stopAnimating];
        [spinnerView setHidden:YES];
        
    }
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [spinner stopAnimating];
    [spinnerView setHidden:YES];
}



@end
