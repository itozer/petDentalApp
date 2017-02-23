//
//  DoggieDentalAccountSignUp.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/10/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDJKeychainItemWrapper;

//@interface DoggieDentalAccountSignUp : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDownloadDelegate> {

//@class DoggieDentalButton;
    
@interface DoggieDentalAccountSignUp : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSURLConnectionDelegate> {
    
    NSString *accountEmail;
    NSString *accountPassword;
    NSString *accountPasswordConfirm;

    UITextField *accountEmailField;
    UITextField *accountPasswordField;
	UITextField *accountPasswordConfirmField;
    
    BOOL pop2Back;
    
    //UITextView *userResponse;
    UIView *spinnerView;
    UIActivityIndicatorView *spinner;
    //DoggieDentalButton *button2;
    NSMutableData *receivedData;
    KDJKeychainItemWrapper *keychain;
}

@property (nonatomic) NSMutableArray *signUpActionList;
@property (nonatomic) UITableView *signUpTable;
@property (nonatomic) int fromWhere;    //0 = from home page, 1 = from photo controller page

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder;



@end
