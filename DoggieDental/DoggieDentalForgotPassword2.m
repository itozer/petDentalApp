//
//  DoggieDentalForgotPassword.m
//  DoggieDental
//
//  Created by Isaac Tozer on 8/3/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalForgotPassword2.h"
#import "DoggieDentalButton.h"
#import "KDJKeychainItemWrapper.h"
#import  <QuartzCore/QuartzCore.h>

@implementation DoggieDentalForgotPassword2


@synthesize loginActionList, loginTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Reset Password"];
        
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
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add UITableView
    [self setLoginActionList:[NSMutableArray arrayWithObjects:@"Account Email", @"New Password", @"Confirm Password", nil]];
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    [self setLoginTable:[[UITableView alloc] initWithFrame:CGRectMake(20, 80, (width - 40), 132) style:UITableViewStyleGrouped]];

    [loginTable setContentInset:UIEdgeInsetsMake(-65, 0, 0, 0)];  //IM NOT SURE WHAT IS CAUSING THE GREY SPACE ON TOP
    
    [loginTable setDelegate:self];
    [loginTable setDataSource:self];
    [loginTable setScrollEnabled:NO];
    [[loginTable layer] setBorderWidth:1.0];
    [[loginTable layer] setMasksToBounds:YES];
    [[loginTable layer] setCornerRadius:4.0];
    [[loginTable layer] setBorderWidth:1.0];
    [[loginTable layer] setBorderColor:[[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor]];
    [[self view] addSubview:loginTable];
    
    //reset password text
    UITextView *resetText = [[UITextView alloc] initWithFrame:CGRectMake(20, loginTable.frame.size.height + loginTable.frame.origin.y + 10, (width - 40), 80)];
    resetText.text = @"If you have forgotten your password, enter a new password above. We will send you an email with a time senstive confirmation code to activate your new password.";
    resetText.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    resetText.backgroundColor = [UIColor clearColor];
    [self.view addSubview:resetText];
    
    //reset password button below table
    CGFloat buttonWidth = 160;
    CGFloat buttonHeight = 50;
    DoggieDentalButton *button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), resetText.frame.size.height + resetText.frame.origin.y + 30, buttonWidth, buttonHeight)];
    [button setColorGradient:0];
    [button setTitle:@"Reset Password" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    receivedData = [[NSMutableData alloc] init];
    
    keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
}

-(void)resetPassword:(id)sender {
    BOOL process = YES;
    if (![self NSStringIsValidEmail: accountEmail]) {
        process = NO;
    }
    if (![newPassword isEqualToString:confirmNewPassword]) {
        process = NO;
    }
    
    if (process) {
        [self dismissKeyboard];
        [spinner startAnimating];
        [spinnerView setHidden:NO];
        
        NSString *content = [NSString stringWithFormat:@"email=%@&newPassword=%@&newPasswordConfirm=%@", accountEmail, newPassword, confirmNewPassword];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://petdentalapp.com/reset_account_password.php"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[content dataUsingEncoding:NSISOLatin1StringEncoding]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
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
            tf = accountEmailField = [self makeTextField:@"" placeholder:@"Account Email"];
            [tf setKeyboardType: UIKeyboardTypeEmailAddress];
            [cell addSubview:accountEmailField];
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
			tf = confirmNewPasswordField = [self makeTextField:confirmNewPassword placeholder:@"Confirm Password"];
			[cell addSubview:confirmNewPasswordField];
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
    int i = (int)[loginActionList count];
    return i;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
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
- (void)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //if ( textField == petTypeField ) {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //email
    if ( textField == accountEmailField) {
        accountEmail = [textField text];
        if ([self NSStringIsValidEmail: accountEmail]) {
            textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        } else {
            textField.textColor = [UIColor redColor];
        }
        //password
    } else if ( textField == newPasswordField ) {
		newPassword = [textField text];
        //password confirm
    } else if ( textField == confirmNewPasswordField ) {
        confirmNewPassword = [textField text];
        if ([[textField text] isEqualToString:newPassword]) {
            textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            newPasswordField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        } else {
            textField.textColor = [UIColor redColor];
            newPasswordField.textColor = [UIColor redColor];
        }
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

/*
 this method might be called more than one time according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
    NSLog(@"data recieved");
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
    [self loginResponse:1];
}

/*
 if data is successfully received, this method will be called by connection
 */

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *e = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: receivedData options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonDictionary) {
        //NSLog(@"Error parsing JSON: %@", e);
        [self loginResponse:0];
    } else {
        if ([[jsonDictionary objectForKey:@"emailSent"] boolValue]) {
            //reset succesfull and email verification link sent
            [self loginResponse:2];
        } else if (![[jsonDictionary objectForKey:@"emailVerified"] boolValue]) {
            //there is no account with this email address
            [self loginResponse:3];
        } else {
            //some other error occured.
            [self loginResponse:4];
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
        [alertTitle setString:@"Success!"];
        [userMessage setString:@"You must click the activation link sent to your email before your password will be changed."];
        accountEmail = @"";
        newPassword = @"";
        confirmNewPassword = @"";
    } else if (response ==3) {
        [alertTitle setString:(@"Oops!")];
        [userMessage setString:@"We do not have this email address on record."];
    } else if (response == 4) {
        [alertTitle setString:(@"Our bad!")];
        [userMessage setString:@"An error occured. Please try again later."];
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

@end
