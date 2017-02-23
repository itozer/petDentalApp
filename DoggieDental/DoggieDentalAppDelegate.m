//
//  DoggieDentalAppDelegate.m
//  DoggieDental
//
//  Created by Isaac Tozer on 9/22/12.
//  Copyright (c) 2012 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalAppDelegate.h"
#import "DoggieDentalMain2.h"
#import "DoggieDentalPetStore.h"
#import "KDJKeychainItemWrapper.h"
#import "DoggieDentalInAppPurchase.h"
#import "DoggieDentalCheckupPost.h"

@implementation DoggieDentalAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //initializes checkup post singleton. important if user gets disconnected
    //also listens for notification from DoggieDentalInAppPurchase
    [DoggieDentalCheckupPost sharedStore];
    
    //initializes in app purchase singleton. important if user purchases and is disconnected.
    [DoggieDentalInAppPurchase sharedStore];
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    receivedData = [[NSMutableData alloc] init];
    //spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    DoggieDentalMain2 *mainMenu = [[DoggieDentalMain2 alloc] initWithNibName:@"DoggieDentalMain2" bundle:nil];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    //create UINavigation controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainMenu];
    [[self window] setRootViewController:navController];
    [self.window makeKeyAndVisible];
    [self customizeAppearance];
            
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Application is resigning active state");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success = [[DoggieDentalPetStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"application did enter background. saved pets");
    } else {
        NSLog(@"application did enter background. save pets fail");
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //check to see how long ago user last logged in. if less than 15 seconds, dont ping server
    //this may not be necessary. its just in cast the user opens and closes the app quickly
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastLogin = [defaults objectForKey:@"lastLogin"];
    BOOL pingServer = YES;
    if (lastLogin) {
        if ([lastLogin timeIntervalSinceNow] > - 15) {  //15 seconds
            pingServer = NO;
        }
    }
    
    if (pingServer) {
        NSString *user = [[NSString alloc] init];
        NSString *pass = [[NSString alloc] init];
        keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        
        user = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
        pass = [keychain objectForKey:(__bridge id)(kSecValueData)];
        
        if (([user length] > 0) && ([pass length] > 0)) {
            //place spinner on view
            [UIApplication sharedApplication]. networkActivityIndicatorVisible =  YES;

            //attempt to login to pet dental server
            //this is making the server work too hard. eventually push notifications will be better
            NSString *content = [NSString stringWithFormat:@"email=%@&password=%@", user, pass];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://petdentalapp.com/return_checkup_results.php"]];
            //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.1.102/petdental/return_checkup_results.php"]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[content dataUsingEncoding:NSISOLatin1StringEncoding]];
                    
            (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)customizeAppearance
{
    // Create resizable images
    //UIImage *gradientImage44 = [[UIImage imageNamed:@"uinavigationbarsliver"]
                            //resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //[[UINavigationBar appearance] setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", [deviceToken description]);
    
    NSString *token = [deviceToken description];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    [receivedData setLength:0]; //reset
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *e = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: receivedData options: NSJSONReadingMutableContainers error: &e];
    
    
    if (!jsonDictionary) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        BOOL fail = NO;
        for (NSString *param in jsonDictionary) {
            if ([param isEqualToString:@"Fail"]) {
                fail = YES;
            }
            break;
        }
        if (fail) {   //dictionary returns nil if value is not present, and condition fails
            NSLog(@"error logging in. username and pass may be incorrect. i may want to reset keychain here");
            [keychain setObject:@"NO" forKey:(__bridge id)(kSecAttrDescription)];     //not logged in
        } else {
            NSLog(@"logged in. updating results");
            [[DoggieDentalPetStore sharedStore] updateCheckupResults:jsonDictionary];
            [keychain setObject:@"YES" forKey:(__bridge id)(kSecAttrDescription)];        //logged in
            [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidUpdateResults" object:nil];  //mainMenu and checkupList listens for this
        }
    }
     
    [receivedData setLength:0]; //reset
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //record last time user logged in
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date]forKey:@"lastLogin"];
    [defaults synchronize];
    
}

/*
-(void)removeSplash;
{
    [_splashView removeFromSuperview];
}
*/


@end
