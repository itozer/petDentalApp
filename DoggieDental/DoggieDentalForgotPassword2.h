//
//  DoggieDentalForgotPassword.h
//  DoggieDental
//
//  Created by Isaac Tozer on 8/3/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KDJKeychainItemWrapper;

@interface DoggieDentalForgotPassword2 : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSURLConnectionDelegate> {

    NSString *accountEmail;
    NSString *newPassword;
    NSString *confirmNewPassword;

    UITextField *accountEmailField;
    UITextField *newPasswordField;
    UITextField *confirmNewPasswordField;

    BOOL pop2Back;

    //UITextView *userResponse;
    UIView *spinnerView;
    UIActivityIndicatorView *spinner;
    NSMutableData *receivedData;
    KDJKeychainItemWrapper *keychain;

}

@property (nonatomic) NSMutableArray *loginActionList;
@property (nonatomic) UITableView *loginTable;
@property (nonatomic) int fromWhere;    //0 = from home page, 1 = from photo controller page

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder;

@end
