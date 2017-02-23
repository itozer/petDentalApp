//
//  DoggieDentalAccountLogin.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/24/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDJKeychainItemWrapper;

@interface DoggieDentalAccountLogin : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSURLConnectionDelegate> {

    NSString *accountEmail;
    NSString *accountPassword;
    
    UITextField *accountEmailField;
    UITextField *accountPasswordField;
    
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
