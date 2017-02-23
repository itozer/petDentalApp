//
//  DoggieDentalDisclaimer.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/23/14.
//  Copyright (c) 2014 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalDisclaimer.h"
#import "DoggieDentalButton.h"

@implementation DoggieDentalDisclaimer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Disclaimer"];
        
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
    
    NSString *disclaimer = @"This site is to be used for information only and cannot replace the relationship with your animal’s veterinarian.  This site cannot diagnose or treat any disease and cannot replace the physical exam that your animal should get from his or her veterinarian.  While this site uses pictures to help determine the degree of disease in your animal’s mouth, and makes recommendations that are designed to improve your pet’s oral state, actual diagnosis and treatment can only be made by your veterinarian after a complete exam.";
    
    NSString *disclaimer2 = @"The ideas and recommendations conveyed by our veterinarians are made after careful consideration of your pet’s breed, age, history and pictures of the oral cavity.  The recommendations are not a guarantee that the ideas or products will change your pet’s condition.  The recommendations are made for the specific animal in question and will help in the majority of cases but not in all cases.  The process by which our veterinarians are making a determination about your pet’s condition is limited and many diseases of the mouth could be missed.  If you follow the recommendations of our veterinarians and the problem is not better in a short time span, or seems to be getting worse, please consult with your veterinarian for a complete exam as soon as possible.  Failure to do this could make your pet’s condition worse and could even result in the death of your pet. ";
    
    NSString *disclaimer3 = @"The majority of our animals are presented to us because of bad breath.  The reason could be very simple, such as an improper diet, or much more serious, such as cancer of the oral cavity.   Oral disease in our pets should not be taken lightly.  The oral cavity is a source of serious disease and can and sometimes be life threatening.  Oral disease can lead to infection of the major organs of the body and can result in serious illness and even death. ";
    
    
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    CGFloat height = CGRectGetHeight([[self view] bounds]);
    CGFloat scrollViewHeight;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UILabel *resultsText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
    resultsText.text = [NSString stringWithFormat:@"%@\r\n\r\n%@\r\n\r\n%@", disclaimer, disclaimer2, disclaimer3];
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
