//
//  DoggieDentalAccountLogin.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/24/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalAccountLogin.h"
#import "DoggieDentalButton.h"
#import "KDJKeychainItemWrapper.h"
#import "DoggieDentalForgotPassword2.h"
#import  <QuartzCore/QuartzCore.h>

@interface DoggieDentalAccountLogin ()

@end

@implementation DoggieDentalAccountLogin

@synthesize loginActionList, loginTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Login"];
        
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
    [self setLoginActionList:[NSMutableArray arrayWithObjects:@"Email", @"Password", nil]];
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    [self setLoginTable:[[UITableView alloc] initWithFrame:CGRectMake(20, 80, (width - 40), 88) style:UITableViewStyleGrouped]];
    //[self setLoginTable:[[UITableView alloc] initWithFrame:CGRectMake(20, 100, (width - 40), 88)]];
    
    //CGFloat headerHeight = [loginTable headerViewForSection:1].frame.size.height;
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
    
    //login button below table
    CGFloat buttonWidth = 160;
    CGFloat buttonHeight = 50;
    DoggieDentalButton *button = [[DoggieDentalButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), loginTable.frame.size.height + loginTable.frame.origin.y + 30, buttonWidth, buttonHeight)];
    [button setColorGradient:0];
    [button setTitle:@"Log In" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    
    //forgot password button below login
    UIButton *forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - ( buttonWidth / 2), button.frame.size.height + button.frame.origin.y + 10, buttonWidth, buttonHeight - 20)];
    [forgotPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [forgotPasswordButton addTarget:self action:@selector(forgotPassword:) forControlEvents:UIControlEventTouchUpInside];
    [forgotPasswordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:forgotPasswordButton];
    
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

-(void)login:(id)sender {
    BOOL process = YES;
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
        
        NSString *content = [NSString stringWithFormat:@"email=%@&password=%@", accountEmail, accountPassword];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://petdentalapp.com/login.php"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[content dataUsingEncoding:NSISOLatin1StringEncoding]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
    /*
    //synchronous version
    NSString *content = [NSString stringWithFormat:@"email=%@&password=%@", accountEmail, accountPassword];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/petdental/account_post.php"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://petdentalapp.com/login.php"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:NSISOLatin1StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil) {
            //[self receivedData:data];
            NSError *e = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
            for (NSString *key in jsonDictionary) {
                NSLog(@"%@ : %@", key, [jsonDictionary objectForKey:key]);
            }
        } else if ([data length] == 0 && error == nil)
            //[self emptyReply];
            NSLog(@"empty");
        //else if (error != nil && error.code == ERROR_CODE_TIMEOUT)
            //[self timedOut];
            //NSLog(@"timeout");
        else if (error != nil)
            //[self downloadError:error];
            NSLog(@"download error");
    }];
    */
}

-(void)forgotPassword:(id)sender {
    
    DoggieDentalForgotPassword2 *newViewController = [[DoggieDentalForgotPassword2 alloc] init];
    [self.navigationController pushViewController:newViewController animated:YES];
    
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
			//cell.textLabel.text = @"Name" ;
			tf = accountPasswordField = [self makeTextField:@"" placeholder:@"Password"];
			[tf setKeyboardType: UIKeyboardTypeDefault];
            tf.secureTextEntry = YES;
            [cell addSubview:accountPasswordField];
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
    } else if ( textField == accountPasswordField ) {
		accountPassword = [textField text];
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
    
    BOOL jsonReturn;
    if (!jsonDictionary) {
        //NSLog(@"Error parsing JSON: %@", e);
        [self loginResponse:0];
    } else {
        jsonReturn = [[jsonDictionary objectForKey:@"login"] boolValue];
        if (jsonReturn) {
            //successfull login
            [self loginResponse:2];
        } else {
            //invalid login credentials
            [self loginResponse:3];
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
        [keychain setObject:@"" forKey:(__bridge id)(kSecAttrAccount)];
        [keychain setObject:@"" forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:@"NO" forKey:(__bridge id)(kSecAttrDescription)];
    } else if (response == 2) {
        pop2Back = YES;
        [alertTitle setString:@"Rad! Login Success."];
        [userMessage setString:@"Welcome back."];
        
        //log user in locally
        keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        [keychain setObject:accountEmail forKey:(__bridge id)(kSecAttrAccount)];
        [keychain setObject:accountPassword forKey:(__bridge id)(kSecValueData)];
        [keychain setObject:@"YES" forKey:(__bridge id)(kSecAttrDescription)];
        accountEmail = @"";
        accountPassword = @"";
    } else if (response ==3) {
        [alertTitle setString:(@"Oops!")];
        [userMessage setString:@"Incorrect email and password. Please try again."];
        
        //clear keychain
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
