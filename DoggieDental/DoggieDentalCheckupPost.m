//
//  DoggieDentalCheckupPost.m
//  DoggieDental
//
//  Created by Isaac Tozer on 10/13/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalCheckupPost.h"
#import "DoggieDentalPetProfile.h"
#import "KDJKeychainItemWrapper.h"
#import "DoggieDentalCheckup.h"
#import "DoggieDentalCheckupStore.h"
#import "DoggieDentalImageStore.h"
#import "DoggieDentalPetStore.h"

@implementation DoggieDentalCheckupPost

@synthesize silent, backgroundTask;



//*************** create singleton
+ (id)allocWithZone: (NSZone *)zone
{
    return [self sharedStore];
}

+ (DoggieDentalCheckupPost *) sharedStore
{
    static DoggieDentalCheckupPost *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}


- (id)init
{
    self = [super init];
    if (self) {
        //check to see if the current checkup needs to be posted or not
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(postCheckupSelector:)
                                                     name:@"IAPHelperProductPurchasedNotification"
                                                   object:nil];
        
        
        silent = YES;   //eventually I need to figure out how to change the delegate on a different object to something other than self
        backgroundTask = UIBackgroundTaskInvalid;
        [self postCheckup]; //in case the program crashes after checkup is paid for and we need to post a checkup still.

    }
    return self;
}

-(void) postCheckupSelector: (id) sender {
    NSLog(@"iTunes purchase notification");
    [self postCheckup];
}

-(void)postCheckup {
    
    [receivedData setLength:0]; //reset
    pet = [[DoggieDentalPetStore sharedStore] petTransactionToPost];
    
    if (pet) {
    
        NSString *user = [[NSString alloc] init];
        NSString *pass = [[NSString alloc] init];
        KDJKeychainItemWrapper *keychain = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"account" accessGroup:nil];
        user = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
        pass = [keychain objectForKey:(__bridge id)(kSecValueData)];
        BOOL loggedIn = [[keychain objectForKey:(__bridge id)(kSecAttrDescription)] boolValue];
        
        BOOL checkupPost = [[[pet allCheckups] currentCheckup] transactionStatus] > 1;  //has this checkup been paid for but not posted
        
        if (loggedIn && ([user length] > 0) && ([pass length] > 0) && checkupPost) {
            
            receivedData = [[NSMutableData alloc] init];
            
            //now post to pet dental web server
            //pet and checkup info
            NSMutableDictionary* petCheckupDictionary = [[NSMutableDictionary alloc] init];
            [petCheckupDictionary setObject:user forKey:@"email"];
            [petCheckupDictionary setObject:pass forKey:@"password"];
            [petCheckupDictionary setObject:[pet petKey] forKey:@"petKey"];
            [petCheckupDictionary setObject:[pet petSpecies] forKey:@"species"];
            [petCheckupDictionary setObject:[pet petName] forKey:@"name"];
            [petCheckupDictionary setObject:[pet petBreed] forKey:@"breed"];
            [petCheckupDictionary setObject:[pet petGender] forKey:@"gender"];
            [petCheckupDictionary setObject:[pet petAgeString] forKey:@"age"];
            [petCheckupDictionary setObject:[pet petWeightString] forKey:@"weight"];
            [petCheckupDictionary setObject:[pet petMedications] forKey:@"medications"];
            [petCheckupDictionary setObject:[pet petDiseases] forKey:@"diseases"];
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
            if (deviceToken) {
                [petCheckupDictionary setObject:deviceToken forKey:@"deviceToken"];
            } else {
                [petCheckupDictionary setObject:@"" forKey:@"deviceToken"];
            }
            //[petCheckupDictionary setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"] forKey:@"deviceToken"];
            [petCheckupDictionary setObject:[[[pet allCheckups] currentCheckup] transactionIdentifier] forKey:@"transactionIdentifier"];
            [petCheckupDictionary setObject:[[[pet allCheckups] currentCheckup] imageKeyFront] forKey:@"frontPictureKey"];
            [petCheckupDictionary setObject:[[[pet allCheckups] currentCheckup] imageKeyLeft] forKey:@"leftPictureKey"];
            [petCheckupDictionary setObject:[[[pet allCheckups] currentCheckup] imageKeyRight] forKey:@"rightPictureKey"];
            NSString *optionalPictureKey = [[[pet allCheckups] currentCheckup] imageKeyOptional];
            if (optionalPictureKey) [petCheckupDictionary setObject:[[[pet allCheckups] currentCheckup] imageKeyOptional] forKey:@"optionalPictureKey"];
            NSString *imageProfileKey = [pet imageKeyProfile];
            if (imageProfileKey) [petCheckupDictionary setObject:imageProfileKey forKey:@"profilePictureKey"];
            
            /*
            for(id key in petCheckupDictionary) {
                NSLog(@"key=%@ value=%@", key, [petCheckupDictionary objectForKey:key]);
            }
            */

            //checkup images to upload
            UIImage *picture = [[DoggieDentalImageStore sharedStore] imageForKey: [[[pet allCheckups] currentCheckup] imageKeyFront]];
            NSData *frontImageData = UIImageJPEGRepresentation(picture, 0.7);
            
            picture = [[DoggieDentalImageStore sharedStore] imageForKey: [[[pet allCheckups] currentCheckup] imageKeyLeft]];
            NSData *leftImageData = UIImageJPEGRepresentation(picture, 0.7);
            
            picture = [[DoggieDentalImageStore sharedStore] imageForKey: [[[pet allCheckups] currentCheckup] imageKeyRight]];
            NSData *rightImageData = UIImageJPEGRepresentation(picture, 0.7);
            
            NSData *optionalImageData;
            if (optionalPictureKey) {
                picture = [[DoggieDentalImageStore sharedStore] imageForKey: [[[pet allCheckups] currentCheckup] imageKeyOptional]];
                optionalImageData = UIImageJPEGRepresentation(picture, 0.7);
            }
            
            // setting up the URL to post to
            //NSString *urlString = @"http://192.168.1.102/petdental/submit_checkup.php";
            NSString *urlString = @"https://petdentalapp.com/submit_checkup.php";
            
            // setting up the request object now
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            //add some header info now
            //we always need a boundary when we post a file
            //also we need to set the content type
            
            //You might want to generate a random boundary.. this is just the same
            //as my output from wireshark on a valid html post
            
            NSString *boundary = @"---------------------------14737809333466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            //now lets create the body of the post
            
            NSMutableData *body = [NSMutableData data];
            
            //pet info and image keys
            for (NSString *param in petCheckupDictionary) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", [petCheckupDictionary objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
                //[body appendData:[[NSString stringWithFormat:@"%@", [petCheckupDictionary objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
                //NSLog(@"%@", body);
            }
            
            //front image
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"userImageFront\"; filename=\"front.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:frontImageData]];
            //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //left image
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"userImageLeft\"; filename=\"left.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:leftImageData]];
            //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //right image
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"userImageRight\"; filename=\"right.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:rightImageData]];
            //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //optional image
            if (optionalPictureKey) {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Disposition: form-data; name=\"userImageOptional\"; filename=\"optional.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:optionalImageData]];
                //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            //profile image
            if (imageProfileKey) {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Disposition: form-data; name=\"userImageProfile\"; filename=\"profile.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:[pet thumbnailData]]];
                //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            //closing boundary for post
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            NSLog(@"post request started");
            
            //if the app is backgrounded, we want the post to continue
            self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                NSLog(@"Background handler called. Not running background tasks anymore.");
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
                self.backgroundTask = UIBackgroundTaskInvalid;
            }];
            
        } else {
            [self postCheckupResponse:4];
        }
        
    } else {
        NSLog(@"There is not a pet in transaction that need to be posted");
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
    
    NSLog(@"%@" , error);
    [self postCheckupResponse:1];
}

/*
 if data is successfully received, this method will be called by connection
 */

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError *e = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: receivedData options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonDictionary) {
        //NSLog(@"Error parsing JSON: %@", e);
        [self postCheckupResponse:0];
    } else {
        /*
        for(id key in jsonDictionary) {
            NSLog(@"key=%@ value=%@", key, [jsonDictionary objectForKey:key]);
        }
        */
        
        //tell user what happened
        if ([[jsonDictionary objectForKey:@"success"] boolValue]) {
            [pet setPetID:[[jsonDictionary objectForKey:@"petID"] intValue]];
            [[[pet allCheckups] currentCheckup] setCheckupID:[[jsonDictionary objectForKey:@"checkupID"] intValue]];
            
            //TESTING FOR BACKGROUND COMPLETION
            /*
            NSLog(@"wait timer started");
            [self performSelector:@selector(backgroundTest:) withObject:nil afterDelay:20.0];
            */
            
            [self postCheckupResponse:2];
            
        } else {
            //some other error occured.
            [self postCheckupResponse:3];
        }
    }
}

/*
-(void) backgroundTest: (id) sender {
    [self postCheckupResponse:2];
}
*/


-(void)postCheckupResponse: (int) response
{
    //response 0 = server error
    //response 1 = connection fail
    //response 2 = success
    //response 3 = some other error? this should never get called
    
    BOOL checkupSubmitted = NO;
    
    NSMutableString *userMessage = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *alertTitle = [[NSMutableString alloc] initWithString:@""];
    [receivedData setLength:0]; //reset
    
    if (response == 0) {
        [alertTitle setString:@"Blargh. Server error."];
        [userMessage setString:@"Please try again later."];
    } else if (response == 1) {
        [alertTitle setString:@"Blargh. Connection error."];
        [userMessage setString:@"Please try again later."];
    } else if (response == 2) {
        [[[pet allCheckups] currentCheckup] setCheckupType:0];      //original checkup. not followup.
        [[[pet allCheckups] currentCheckup] setTransactionStatus:0];    //no longer in transaction state
        [[[pet allCheckups] currentCheckup] setDateSubmitted:[[NSDate alloc] init]];
        [[[pet allCheckups] currentCheckup] setSubmitted:YES];  //once submitted, it is no longer the current checkup.
        checkupSubmitted = YES;
        
        //save pets now in case of program crash. I need to know status of checkup post
        BOOL success = [[DoggieDentalPetStore sharedStore] saveChanges];
        if (success) {
            NSLog(@"checkup post complete. saving pets");
        } else {
            NSLog(@"checkup post complete. save pets fail");
        }
        
    } else if (response ==3) {
        [alertTitle setString:(@"Oh Snap!")];
        [userMessage setString:@"Something weird happened. Please try again later."];
    } else if (response == 4) {
        //called if not logged in or if pet does not need to post its checkup (not paid)
        //this should never happen
        NSLog(@"ERROR CheckupPost. User not logged in or checkup did not need to be posted");
    }
    
    [receivedData setLength:0]; //reset
    NSMutableDictionary* checkupDictionary = [[NSMutableDictionary alloc] init];
    [checkupDictionary setObject:[NSNumber numberWithBool:checkupSubmitted] forKey:@"success"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkupPost" object:nil userInfo:checkupDictionary];
    
    //kill background task
    if (self.backgroundTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}


@end
