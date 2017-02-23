//
//  DoggieDentalCheckupAnalysis.m
//  DoggieDental
//
//  Created by Isaac Tozer on 4/20/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalCheckupAnalysis.h"
#import "DoggieDentalImageStore.h"
#import "DoggieDentalPetProfile.h"
#import "DoggieDentalButton.h"
#import <QuartzCore/QuartzCore.h>

@interface DoggieDentalCheckupAnalysis ()

@end

@implementation DoggieDentalCheckupAnalysis

@synthesize pet, checkup, checkupAnalyzed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Checkup"];
            
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

-(void) back: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg"]]];
    
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    CGFloat height = CGRectGetHeight([[self view] bounds]);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    if (checkupAnalyzed) {
    
        //Results TEXT
        UILabel *results = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
        results.text = @"Results";
        results.font = [UIFont fontWithName:@"Helvetica" size:26.0f];
        [results setTextColor: [UIColor colorWithRed:8/255.0 green:69/255.0 blue:89/255.0 alpha:1]];
        [results sizeToFit];
        [scrollView addSubview:results];
        
        UILabel *resultsText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
        resultsText.text = checkup.checkupResults;
        resultsText.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        resultsText.lineBreakMode = NSLineBreakByWordWrapping;
        resultsText.numberOfLines = 0;
        [resultsText sizeToFit];
        
        height = resultsText.frame.size.height + 30;
        UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(10, results.frame.origin.y + results.frame.size.height + 2, (width - 20), height)];
        [textContainer setBackgroundColor:[UIColor whiteColor]];
        textContainer.clipsToBounds = YES;
        textContainer.layer.cornerRadius = 4.0f;
        textContainer.layer.borderWidth = 1.0f;
        textContainer.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor];
        [textContainer addSubview:resultsText];
        [scrollView addSubview:textContainer];
        
        //Recommendations TEXT
        UILabel *recommendations = [[UILabel alloc] initWithFrame:CGRectMake(10, textContainer.frame.size.height + textContainer.frame.origin.y + 30, 100, 100)];
        recommendations.text = @"Recommendations";
        recommendations.font = [UIFont fontWithName:@"Helvetica" size:26.0f];
        [recommendations setTextColor: [UIColor colorWithRed:8/255.0 green:69/255.0 blue:89/255.0 alpha:1]];
        [recommendations sizeToFit];
        [scrollView addSubview:recommendations];
        
        UILabel *recommendationsText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
        recommendationsText.text = checkup.checkupRecommendation;
        recommendationsText.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        recommendationsText.lineBreakMode = NSLineBreakByWordWrapping;
        recommendationsText.numberOfLines = 0;
        [recommendationsText sizeToFit];
        
        height = recommendationsText.frame.size.height + 30;
        UIView *textContainer2 = [[UIView alloc] initWithFrame:CGRectMake(10, recommendations.frame.origin.y + recommendations.frame.size.height + 2, (width - 20), height)];
        [textContainer2 setBackgroundColor:[UIColor whiteColor]];
        textContainer2.clipsToBounds = YES;
        textContainer2.layer.cornerRadius = 4.0f;
        textContainer2.layer.borderWidth = 1.0f;
        textContainer2.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor];
        [textContainer2 addSubview:recommendationsText];
        [scrollView addSubview:textContainer2];
        
        [scrollView setContentSize:CGSizeMake(width, textContainer2.frame.size.height + textContainer2.frame.origin.y + 30)];
        
    } else {
        
        //Checkup Pending
        UILabel *results = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
        results.text = @"Checkup Pending";
        results.font = [UIFont fontWithName:@"Helvetica" size:26.0f];
        [results setTextColor: [UIColor colorWithRed:8/255.0 green:69/255.0 blue:89/255.0 alpha:1]];
        [results sizeToFit];
        [scrollView addSubview:results];
        
        UILabel *resultsText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
        resultsText.text = @"Thanks for using Pet Dental! We will let you know as soon as we are finished with your results.";
        resultsText.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        resultsText.lineBreakMode = NSLineBreakByWordWrapping;
        resultsText.numberOfLines = 0;
        [resultsText sizeToFit];
        [[self view] addSubview:resultsText];
        
        height = resultsText.frame.size.height + 30;
        UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(10, results.frame.origin.y + results.frame.size.height + 6, (width - 20), height)];
        [textContainer setBackgroundColor:[UIColor whiteColor]];
        textContainer.clipsToBounds = YES;
        textContainer.layer.cornerRadius = 4.0f;
        textContainer.layer.borderWidth = 1.0f;
        textContainer.layer.borderColor = [[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor];
        [textContainer addSubview:resultsText];
        [scrollView addSubview:textContainer];
        
    }
    
    [[self view] addSubview:scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    /*
    NSString *imageKey = [pet imageKeyProfile];
    if (imageKey) {
        //get image for image key from image store
        UIImage *imageToDisplay = [[DoggieDentalImageStore sharedStore] imageForKey:imageKey];
        
        //use that image to put on the screen in UIButtonView
        [petThumb setImage:imageToDisplay];
    }
    
    petNameLabel.text = pet.petName;
    */
    
    /*
    
    CGRect frame = checkupResultsText.frame;
    checkupResultsText.text = checkup.checkupResults;
    frame.size.height = checkupResultsText.contentSize.height;
    checkupResultsText.frame = frame;
    
    frame = recommendationsLabel.frame;
    frame.origin.y = checkupResultsText.frame.origin.y + checkupResultsText.frame.size.height + 30;
    recommendationsLabel.frame = frame;
    
    frame = recommendationsText.frame;
    recommendationsText.text = checkup.checkupRecommendation;
    frame.size.height = recommendationsText.contentSize.height;
    frame.origin.y = recommendationsLabel.frame.origin.y + recommendationsLabel.frame.size.height + 10;
    recommendationsText.frame = frame;
     
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
