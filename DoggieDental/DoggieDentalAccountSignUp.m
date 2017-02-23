//
//  DoggieDentalAccountSignUp.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/10/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalAccountSignUp.h"
#import  "DoggieDentalPaymentInfo.h"
#import "DoggieDentalButton.h"
#import "KDJKeychainItemWrapper.h"
#import  <QuartzCore/QuartzCore.h>

@interface DoggieDentalAccountSignUp ()

@end

@implementation DoggieDentalAccountSignUp

@synthesize signUpActionList, signUpTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Sign Up"];
        
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
    [super viewDidLoad];
    
    //Add UITableView
    [self setSignUpActionList:[NSMutableArray arrayWithObjects:@"Email", @"Password", @"Password2", nil]];
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
    [button setTitle:@"Sign Up" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    
    //disclaimer text
    UILabel *resultsText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
    resultsText.text = @"Don't worry, we hate spam as much as you do. We will never share your email address.";
    resultsText.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    resultsText.textColor = [UIColor grayColor];
    resultsText.lineBreakMode = NSLineBreakByWordWrapping;
    resultsText.numberOfLines = 0;
    [resultsText sizeToFit];
    
    int height = resultsText.frame.size.height + 20;
    UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(10, button.frame.origin.y + button.frame.size.height + 15, (width - 20), height)];
    [textContainer setBackgroundColor:[UIColor whiteColor]];
    textContainer.clipsToBounds = YES;
    textContainer.layer.cornerRadius = 4.0f;
    textContainer.layer.borderWidth = 1.0f;
    textContainer.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor];
    [textContainer addSubview:resultsText];
    [self.view addSubview:textContainer];
    
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
            tf = accountEmailField = [self makeTextField:accountEmail placeholder:@"Account Email"];
            [tf setKeyboardType: UIKeyboardTypeEmailAddress];
            [cell addSubview:accountEmailField];
			break ;
		}
		case 1: {
			tf = accountPasswordField = [self makeTextField:accountPassword placeholder:@"Password"];
			[cell addSubview:accountPasswordField];
            [tf setKeyboardType: UIKeyboardTypeDefault];
            tf.secureTextEntry = YES;
			break ;
		}
		case 2: {
			tf = accountPasswordConfirmField = [self makeTextField:accountPasswordConfirm placeholder:@"Confirm Password"];
			[cell addSubview:accountPasswordConfirmField];
            [tf setKeyboardType: UIKeyboardTypeDefault];
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

-(void) signUp:(id) sender {
    
    BOOL process = YES;
    if ([accountPassword isEqualToString:accountPasswordConfirm]) {

    } else {
        process = NO;
        //textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    }
    if ([self NSStringIsValidEmail: accountEmail]) {
       accountEmailField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    } else {
        process = NO;
        accountEmailField.textColor = [UIColor redColor];
    }
    
    if (process) {
        [self dismissKeyboard];
        [spinner startAnimating];
        [spinnerView setHidden:NO];
        //[spinnerView setHidden:NO];
        //[spinner stopAnimating];
        
        NSString *content = [NSString stringWithFormat:@"email=%@&password=%@&password2=%@", accountEmail, accountPassword, accountPasswordConfirm];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://petdentalapp.com/create_account.php"]];
        //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.102/petdental/create_account.php"]];
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
    if ( textField == accountEmailField) {
        accountEmail = [textField text];
        if ([self NSStringIsValidEmail: accountEmail]) {
            textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        } else {
            textField.textColor = [UIColor redColor];
        }
    //password
    } else if ( textField == accountPasswordField ) {
		accountPassword = [textField text];
        //accountPasswordConfirm = @"";
    //password confirm
    } else if ( textField == accountPasswordConfirmField ) {
		accountPasswordConfirm = [textField text];
        if ([[textField text] isEqualToString:accountPassword]) {
            textField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            accountPasswordField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        } else {
            textField.textColor = [UIColor redColor];
            accountPasswordField.textColor = [UIColor redColor];
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
    
    NSLog(@"%@" , error);
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
            //valid email
            jsonReturn = [[jsonDictionary objectForKey:@"emailValid"] boolValue];
            if (!jsonReturn) {
                //php and objective c valid email code not matching. check this.
                accountEmailField.textColor = [UIColor redColor];
                [self loginResponse:3];
            }
            //password match
            jsonReturn = [[jsonDictionary objectForKey:@"passwordMatch"] boolValue];
            if (!jsonReturn) {
                accountPasswordField.textColor = [UIColor redColor];
                accountPasswordConfirmField.textColor = [UIColor redColor];
                [self loginResponse:4];
            }
            //email available
            jsonReturn = [[jsonDictionary objectForKey:@"emailAvailable"] boolValue];
            if (!jsonReturn) {
                accountEmailField.textColor = [UIColor orangeColor];
                [self loginResponse:5];
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
        
        //clear keychain
        keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        [keychain setObject:@"" forKey:(__bridge id)(kSecAttrAccount)];
        [keychain setObject:@"" forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:@"NO" forKey:(__bridge id)(kSecAttrDescription)];
    } else if (response == 2) {
        pop2Back = YES;
        [alertTitle setString:@"Rad! Account created successfully."];
        [userMessage setString:@"Please check your email to validate account email address."];
        
        keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        [keychain setObject:accountPassword forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:accountEmail forKey:(__bridge id)(kSecAttrAccount)];
        [keychain setObject:@"YES" forKey:(__bridge id)(kSecAttrDescription)];        //logged in
        accountEmail = @"";
        accountPassword = @"";
        accountPasswordConfirm = @"";
    } else if (response ==3) {
        [alertTitle setString:@"Oops!"];
        [userMessage setString:@"Invalid email. Please try again."];
        
        //clear keychain
        keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        [keychain setObject:@"" forKey:(__bridge id)(kSecAttrAccount)];
        [keychain setObject:@"" forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:@"NO" forKey:(__bridge id)(kSecAttrDescription)];
    } else if (response ==4) {
        [alertTitle setString:@"Oops!"];
        [userMessage setString:@"Passwords do not match. Please try again."];
        
        //clear keychain
        keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        [keychain setObject:@"" forKey:(__bridge id)(kSecAttrAccount)];
        [keychain setObject:@"" forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:@"NO" forKey:(__bridge id)(kSecAttrDescription)];
    } else if (response ==5) {
        [alertTitle setString:@"Oops! "];
        [userMessage setString:@"There is already an account using this email address. Please login instead."];
        
        //clear keychain
        keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        [keychain setObject:@"" forKey:(__bridge id)(kSecAttrAccount)];
        [keychain setObject:@"" forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:@"NO" forKey:(__bridge id)(kSecAttrDescription)];
}

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:userMessage
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    //response text to user
    /*
    [userResponse setText:[NSString stringWithString: userMessage]];
    [userResponse setBackgroundColor:[UIColor clearColor]];
    [userResponse setTextColor:[UIColor whiteColor]];
    [userResponse setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [userResponse setTextAlignment:NSTextAlignmentCenter];
    [userResponse setEditable:NO];
    [userResponse setUserInteractionEnabled:NO];
    */
    /*
     **** for some reason changing the frame size does not get drawn in time to be shown. ****
     CGRect frame = userResponse.frame;
     frame.size.height = userResponse.contentSize.height;
     frame.size.width = userResponse.contentSize.width;
     userResponse.frame = frame;
     */
    /*
    [userResponse setCenter:CGPointMake(self.navigationController.view.frame.size.width/2.0, self.navigationController.view.frame.size.height/2.0)];
    [userResponse setHidden: NO];
     */
    
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
