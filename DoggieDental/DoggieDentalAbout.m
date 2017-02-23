//
//  DoggieDentalAbout.m
//  DoggieDental
//
//  Created by Isaac Tozer on 7/19/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalAbout.h"
#import "DoggieDentalButton.h"

@interface DoggieDentalAbout ()

@end

@implementation DoggieDentalAbout

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"About"];
        
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
        [n setLeftBarButtonItem:lbbi];
    }
    return self;
}

-(void) back: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    NSString *aboutP1 = @"Pet Dental is designed for pet owners to help them diagnose the condition of their dogs and cats teeth and gums. There is also information given after our veterinarian makes a diagnosis as to what steps the owner should take to address the problems his or her pet has. This may be a change in diet, food additives, oral sprays, and even brushing their pet’s teeth. (Flossing is going a little too far). In some cases there may be such severe disease that we would recommend dental care by your veterinarian. Early diagnosis of dental disease can help prevent expensive dental work and not only prevent pain, but help avoid diseases that a troubled mouth can pass on to the other organs of the body.";
    NSString *aboutP2 = @"Dogs and Cats have many of the same diseases that humans get when considering their teeth and gums. Perhaps in the wild the animals were eating different food and maybe chewing on things more to stimulate their gums and clean their teeth. The amount and frequency of feeding may have also decreased the amount of disease in the wild. And yes some animals may have died due to dental disease. Man has intervened and helped in many ways, but also has caused some of the issues. Man has created some problems by breeding for looks instead of function. Many of our domestic breeds that now exist would never make it in the wild. The other factor, affecting the mouth, is what we feed our pets. Not always is the food good for the oral cavity. Some lack in good nutrition and others have no chew ability. (Soft foods).";
    NSString *aboutP3 = @"Dental disease can be graded into one of four categories. [Grade I] is a sign that tartar is starting to form on the animals teeth. There is no gum inflammation or disease and there are no loose teeth. [Grade II] is more tartar build up and now the gums are starting to be involved. There may not be any infection of the gums but there is inflammation called gingivitis. [Grade III] There is more severe tartar and often some receding gum line. There is gingivitis but also infection of the gums called pyorrhea. This is the stage that most owners start to notice bad breath. This is also the stage that the pet starts to shower the blood stream with bacteria. One serious side effect of pyorrhea is low grade infection, heart disease, kidney disease and liver disease. When the major organs become infected the animal’s life becomes threatened. [Grade IV] There is more tartar built up on the teeth, more gum loss, pyorrhea, and often the teeth become loose. This is the most serious grade of the disease and often the owners think the animal is acting old when the reality is they have a low grade fever, are in pain and they are constantly fighting off infection from their mouth. The owners are often surprised when an animal with grade IV dental disease has the necessary dental work, that the animal starts to act young again after about three days. This is because the mouth is made healthy and the antibiotics have cleared the bacteria from the body. ";
    NSString *aboutP4 = @"From the photos that you send of your pet our veterinarian will make a diagnosis as to what stage of dental disease your pet has, if any. In addition our veterinarian will make specific recommendations that will aid you in keeping your pet’s teeth healthy as well as preventing gum disease leading to pain and other major diseases. These recommendations will be specific for your pet and will encompass many modalities that will make your pet live a longer pain free life with much sweeter breath. ";
    
    //NSString *disclaimer = @"This Dental pet App is designed to aid you, with the help of your regular veterinarian, prevent and recognize dental disease in your pet.  While our veterinarians examine photos, observe disease from those photos, and make suggestions for dental disease prevention, it is in no way implied that this methodology should be the sole source of your care of your pet’s teeth.  This Dental App is limited by its nature and while the suggestions made by our veterinarians should be very helpful in controlling dental disease there are some diseases of the mouth that can only be diagnosed by hands on examination by your local veterinarian.  If our recommendations do not seem to be working in a very short time please see your regular veterinarian for a complete exam.";

    
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    CGFloat height = CGRectGetHeight([[self view] bounds]);
    CGFloat scrollViewHeight;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    
    //Header - About
    /*
    UILabel *results = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
    results.text = @"About Pet Dental";
    results.font = [UIFont fontWithName:@"Helvetica" size:26.0f];
    [results setTextColor: [UIColor colorWithRed:8/255.0 green:69/255.0 blue:89/255.0 alpha:1]];
    [results sizeToFit];
    [scrollView addSubview:results];
    */
    
    UILabel *resultsText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
    resultsText.text = [NSString stringWithFormat:@"%@\r\n\r\n%@\r\n\r\n%@\r\n\r\n%@", aboutP1, aboutP2, aboutP3, aboutP4];
    resultsText.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    resultsText.lineBreakMode = NSLineBreakByWordWrapping;
    resultsText.numberOfLines = 0;
    [resultsText sizeToFit];
    
    height = resultsText.frame.size.height + 30;
    //UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(10, results.frame.origin.y + results.frame.size.height + 2, (width - 20), height)];
    UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(10, 20, (width - 20), height)];
    [textContainer setBackgroundColor:[UIColor whiteColor]];
    textContainer.clipsToBounds = YES;
    textContainer.layer.cornerRadius = 4.0f;
    textContainer.layer.borderWidth = 1.0f;
    textContainer.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor];
    [textContainer addSubview:resultsText];
    [scrollView addSubview:textContainer];
    
    //Header - Disclaimer
    /*
    results = [[UILabel alloc] initWithFrame:CGRectMake(10, textContainer.frame.origin.y + textContainer.frame.size.height + 30, 100, 100)];
    results.text = @"Disclaimer";
    results.font = [UIFont fontWithName:@"Helvetica" size:26.0f];
    [results setTextColor: [UIColor colorWithRed:8/255.0 green:69/255.0 blue:89/255.0 alpha:1]];
    [results sizeToFit];
    [scrollView addSubview:results];
    
    resultsText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
    resultsText.text = [NSString stringWithFormat:@"%@", disclaimer];
    resultsText.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    resultsText.lineBreakMode = NSLineBreakByWordWrapping;
    resultsText.numberOfLines = 0;
    [resultsText sizeToFit];

    height = resultsText.frame.size.height + 30;
    textContainer = [[UIView alloc] initWithFrame:CGRectMake(10, results.frame.origin.y + results.frame.size.height + 2, (width - 20), height)];
    [textContainer setBackgroundColor:[UIColor whiteColor]];
    textContainer.clipsToBounds = YES;
    textContainer.layer.cornerRadius = 4.0f;
    textContainer.layer.borderWidth = 1.0f;
    textContainer.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor];
    [textContainer addSubview:resultsText];
    [scrollView addSubview:textContainer];
     */
    
    scrollViewHeight = textContainer.frame.size.height + textContainer.frame.origin.y;

    [scrollView setContentSize:CGSizeMake(width, scrollViewHeight + 30)];
    
    [[self view] addSubview:scrollView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
