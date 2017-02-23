//
//  DoggieDentalChangeAccountPassword.m
//  DoggieDental
//
//  Created by Isaac Tozer on 8/3/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalChangeAccountPassword.h"
#import "DoggieDentalPaymentInfo.h"
#import "DoggieDentalButton.h"
#import "KDJKeychainItemWrapper.h"
#import  <QuartzCore/QuartzCore.h>

@implementation DoggieDentalChangeAccountPassword

@synthesize signUpActionList, signUpTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Change Password"];
        
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
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
    
    //Add UITableView
    [self setSignUpActionList:[NSMutableArray arrayWithObjects:@"Existing Password", @"New Password", @"Verify Password", nil]];
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    //[self setSignUpTable:[[UITableView alloc] initWithFrame:CGRectMake(20, 20, (width - 40), 132)]];
    [self setSignUpTable:[[UITableView alloc] initWithFrame:CGRectMake(20, 80, (width - 40), 132) style:UITableViewStyleGrouped]];
    
    //CGFloat headerHeight = [signUpTable headerViewForSection:1].frame.size.height;
    [signUpTable setContentInset:UIEdgeInsetsMake(-65, 0, 0, 0)];  //IM NOT SURE WHAT IS CAUSING THE GREY SPACE ON TOP
    
    [signUpTable setDelegate:self];
    [signUpTable setDataSource:self];
    [[signUpTable layer] setBorderWidth:1.0];
    [[signUpTable layer] setMasksToBounds:YES];
    [[signUpTable layer] setCornerRadius:4.0];
    [[signUpTable layer] setBorderWidth:1.0];
    [[signUpTable layer] setBorderColor:[[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor]];
    [signUpTable setScrollEnabled:NO];
    [self.view addSubview:signUpTable];
    
    //sign up button below table
    CGFloat buttonWidth = 160;
    CGFloat buttonHeight = 50;
    DoggieDentalButton *button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), signUpTable.frame.size.height + signUpTable.frame.origin.y + 30, buttonWidth, buttonHeight)];
    [button setColorGradient:0];
    [button setTitle:@"Update" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(updatePassword:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    
    //for spinner
    spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
    spinnerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(self.navigationController.view.frame.size.width/2.0, self.navigationController.view.frame.size.height/2.0)];
    [spinnerView addSubview:spinner];
    [spinnerView setHidden:YES];
    [self.navigationController.view addSubview:spinnerView];
    
    //Tap gesture to dismiss keyboard
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    receivedData = [[NSMutableData alloc] init];
    
}

-(void)dismissKeyboard {
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    // Make cell unselectable
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UITextField* tf = nil;
	switch ( indexPath.row ) {
		case 0: {
            tf = existingPasswordField = [self makeTextField:existingPassword placeholder:@"Existing Password"];
            //[tf setKeyboardType: UIKeyboardTypeEmailAddress];
            tf.secureTextEntry = YES;
            [cell addSubview:existingPasswordField];
			break ;
		}
		case 1: {
			tf = newPasswordField = [self makeTextField:newPassword placeholder:@"New Password"];
			[cell addSubview:newPasswordField];
            //[tf setKeyboardType: UIKeyboardTypeEmailAddress];
            tf.secureTextEntry = YES;
			break ;
		}
		case 2: {
			tf = newPasswordConfirmField = [self makeTextField:newPasswordConfirm placeholder:@"Confirm Password"];
			[cell addSubview:newPasswordConfirmField];
            //[tf setKeyboardType: UIKeyboardTypeEmailAddress];
            tf.secureTextEntry = YES;
			break ;
		}
	}
    
    // Textfield dimensions
    //tf.frame = CGRectMake(120, 12, 170, 30);
    tf.frame = CGRectMake(30, 12, 270, 30);
    
    // Workaround to dismiss keyboard when Done/Return is tapped
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // We want to handle textFieldDidEndEditing
    tf.delegate = self ;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int i = (int)[signUpActionList count];
    return i;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

-(void) updatePassword:(id) sender {
    
    BOOL process = YES;
    if (![existingPassword isEqualToString:[keychain objectForKey:(__bridge id)(kSecValueData)]]) {
        process = NO;
    }
    if (![newPassword isEqualToString:newPasswordConfirm]) {
        process = NO;
    }

    if (process) {
        [self dismissKeyboard];
        [spinner startAnimating];
        [spinnerView setHidden:NO];
        
        NSString *content = [NSString stringWithFormat:@"email=%@&existingPassword=%@&newPassword=%@&newPasswordConfirm=%@", [keychain objectForKey:(__bridge id)(kSecAttrAccount)], existingPassword, newPassword, newPasswordConfirm];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://petdental.isaactozer.com/change_account_password.php"]];
        //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.102/petdental/change_account_password.php"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[content dataUsingEncoding:NSISOLatin1StringEncoding]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[UITextField alloc] init];
	tf.placeholder = placeholder ;
	tf.text = text ;
	tf.autocorrectionType = UITextAutocorrectionTypeNo ;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
	tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
	return tf ;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([[textField text] isEqualToString:@""]) {
        textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //email
    if ( textField == existingPasswordField ) {
        existingPassword = [textField text];
        if ([[keychain objectForKey:(__bridge id)(kSecValueData)] isEqualToString:existingPassword]) {
            textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        } else {
            textField.textColor = [UIColor redColor];
        }
    //password
    } else if ( textField == newPasswordField ) {
		newPassword = [textField text];
    //password confirm
    } else if ( textField == newPasswordConfirmField ) {
        newPasswordConfirm = [textField text];
        if ([[textField text] isEqualToString:newPassword]) {
            textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            newPasswordField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        } else {
            textField.textColor = [UIColor redColor];
            newPasswordField.textColor = [UIColor redColor];
        }
    }
}


/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
    NSLog(@"data recieved");
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"Connection Fail: %@" , error);
    [self loginResponse:1];
}

/*
 if data is successfully received, this method will be called by connection
 */

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *e = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: receivedData options: NSJSONReadingMutableContainers error: &e];
    
    BOOL jsonReturn;
    if (!jsonDictionary) {
        //NSLog(@"Error parsing JSON: %@", e);
        [self loginResponse:0];
        
    } else {
        jsonReturn = [[jsonDictionary objectForKey:@"success"] boolValue];
        if (jsonReturn) {
            //user account created succesfully and logged in locally -
            //user will still need to validate their email
            [self loginResponse:2];
            
        } else {
            //invalid email
            jsonReturn = [[jsonDictionary objectForKey:@"passwordMatch"] boolValue];
            if (!jsonReturn) {
                //php and objective c valid email code not matching. check this.
                newPasswordField.textColor = [UIColor redColor];
                newPasswordConfirmField.textColor = [UIColor redColor];
                [self loginResponse:3];
            }
            //if update was not successfull BUT passwords match.
            //there was an error updating the password
            if (![[jsonDictionary objectForKey:@"success"] boolValue] && [[jsonDictionary objectForKey:@"passwordMatch"] boolValue]) {
                [self loginResponse:4];
            }
        }
    }
}

-(void)loginResponse: (int) response
{
    //response 0 = server error
    //response 1 = connection fail
    //response 2 = success
    //response 3 = succesfull post but bad user/pass
    
    NSMutableString *userMessage = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *alertTitle = [[NSMutableString alloc] initWithString:@""];
    [receivedData setLength:0]; //reset
    pop2Back = NO;
    
    if (response == 0) {
        [alertTitle setString:@"Blargh. Server error."];
        [userMessage setString:@"Please try again later."];
    } else if (response == 1) {
        [alertTitle setString:@"Blargh. Connection error."];
        [userMessage setString:@"Please try again later."];
    } else if (response == 2) {
        pop2Back = YES;
        [alertTitle setString:@"Yes!"];
        [userMessage setString:@"Password updated successfully."];
        [keychain setObject:newPassword forKey:(__bridge id)(kSecValueData)];
        existingPassword = @"";
        newPassword = @"";
        newPasswordConfirm = @"";
    } else if (response == 3) {
        [alertTitle setString:@"Oops!"];
        [userMessage setString:@"New password entry doesn't match."];
    } else if (response == 4) {
        [alertTitle setString:@"Darn."];
        [userMessage setString:@"There was an error updating your password. Please try again later."];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:userMessage
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [spinner stopAnimating];
    [spinnerView setHidden:YES];
    if (pop2Back) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
    
}

/*
 -(void) continueCheckup:(id) sender {
 [spinnerView removeFromSuperview];
 }
 */


/* THIS KILLS THE DOWNLOAD FOR SOME REASON????
 - (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
 NSLog(@"did finish downloading");
 }
 */


@end
