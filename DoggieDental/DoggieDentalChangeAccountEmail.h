//
//  DoggieDentalChangeAccountInfo.h
//  DoggieDental
//
//  Created by Isaac Tozer on 8/3/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KDJKeychainItemWrapper;

@interface DoggieDentalChangeAccountEmail : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSURLConnectionDelegate> {
    
    NSString *existingEmail;
    NSString *newEmail;
    NSString *newEmailConfirm;
    
    UITextField *existingEmailField;
    UITextField *newEmailField;
	UITextField *newEmailConfirmField;
    
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
