//
//  DoggieDentalTermsOfService.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/23/14.
//  Copyright (c) 2014 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalTermsOfService.h"
#import "DoggieDentalButton.h"

@implementation DoggieDentalTermsOfService

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Terms of Service"];
        
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
    
    NSString *t1 = @"1. Acceptance of our Terms";
    NSString *t1a = @"By viewing, accessing or otherwise using PetDental and any of the services or information created, collected, compiled or submitted to PetDental, you agree to be bound by the following Terms and Conditions of Service. If you do not want to be bound by our Terms your only option is not to visit, view or otherwise use the services of PetDental. You understand, agree and acknowledge that these Terms constitute a legally binding agreement between you and PetDental and that your use of PetDental shall indicate your conclusive acceptance of this agreement.";
    NSString *t2 = @"2. Provision of Services";
    NSString *t2a = @"You agree and acknowledge that PetDental is entitled to modify, improve or discontinue any of its services at its sole discretion and without notice to you even if it may result in you being prevented from accessing any information contained in it. Furthermore, you agree and acknowledge that PetDental is entitled to provide services to you through subsidiaries or affiliated entities.";
    NSString *t3 = @"3. Proprietary Rights";
    NSString *t3a = @"You acknowledge and agree that PetDental may contain proprietary and confidential information including trademarks, service marks and patents protected by intellectual property laws and international intellectual property treaties. PetDental authorizes you to view and make a single copy of portions of its content for offline, personal, non-commercial use. Our content may not be sold, reproduced, or distributed without our written permission. Any third-party trademarks, service marks and logos are the property of their respective owners. Any further rights not specifically granted herein are reserved.";
    NSString *t4 = @"4. Submitted Content";
    NSString *t4a = @"When you submit content to PetDental you simultaneously grant PetDental an irrevocable, worldwide, royalty free license to publish, display, modify, distribute and syndicate your content worldwide. You confirm and warrant that you have the required authority to grant the above license to PetDental.";
    NSString *t5 = @"5. Termination of Agreement";
    NSString *t5a = @"The Terms of this agreement will continue to apply in perpetuity until terminated by either party without notice at any time for any reason. Terms that are to continue in perpetuity shall be unaffected by the termination of this agreement.";
    NSString *t6 = @"6. Disclaimer of Warranties";
    NSString *t6a = @"You understand and agree that your use of PetDental is entirely at your own risk and that our services are provided \"As Is\" and \"As Available\". PetDental does not make any express or implied warranties, endorsements or representations whatsoever as to the operation of the PetDental application, website, information, content, materials, or products. This shall include, but not be limited to, implied warranties of merchantability and fitness for a particular purpose and non-infringement, and warranties that access to or use of the service will be uninterrupted or error-free or that defects in the service will be corrected.";
    NSString *t7 = @"7. Limitation of Liability";
    NSString *t7a = @"You understand and agree that PetDental and any of its subsidiaries or affiliates shall in no event be liable for any direct, indirect, incidental, consequential, or exemplary damages. This shall include, but not be limited to damages for loss of profits, business interruption, business reputation or goodwill, loss of programs or information or other intangible loss arising out of the use of or the inability to use the service, or information, or any permanent or temporary cessation of such service or access to information, or the deletion or corruption of any content or information, or the failure to store any content or information. The above limitation shall apply whether or not PetDental has been advised of or should have been aware of the possibility of such damages. In jurisdictions where the exclusion or limitation of liability for consequential or incidental damages is not allowed the liability of PetDental is limited to the greatest extent permitted by law.";
    NSString *t8 = @"8. External Content";
    NSString *t8a = @"PetDental may include hyperlinks to third-party content, advertising or websites. You acknowledge and agree that PetDental is not responsible for and does not endorse any advertising, products or resource available from such resources or websites.";
    NSString *t9 = @"9. Jurisdiction";
    NSString *t9a = @"You expressly understand and agree to submit to the personal and exclusive jurisdiction of the courts of the country, state, province or territory determined solely by PetDental to resolve any legal matter arising from this agreement or related to your use of PetDental. If the court of law having jurisdiction, rules that any provision of the agreement is invalid, then that provision will be removed from the Terms and the remaining Terms will continue to be valid.";
    NSString *t10 = @"10. Entire Agreement";
    NSString *t10a = @"You understand and agree that the above Terms constitute the entire general agreement between you and PetDental. You may be subject to additional Terms and conditions when you use, purchase or access other services, affiliate services or third-party content or material.";
    NSString *t11 = @"11. Changes to the Terms";
    NSString *t11a = @"PetDental reserves the right to modify these Terms from time to time at our sole discretion and without any notice. Changes to our Terms become effective on the date they are posted and your continued use of PetDental after any changes to Terms will signify your agreement to be bound by them.";
    
    CGFloat width = CGRectGetWidth([[self view] bounds]);
    CGFloat height = CGRectGetHeight([[self view] bounds]);
    CGFloat scrollViewHeight;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UILabel *resultsText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (width - 40), 100)];
    resultsText.text = [NSString stringWithFormat:@"%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n%@: %@\r\n\r\n", t1, t1a, t2, t2a, t3, t3a, t4, t4a, t5, t5a, t6, t6a, t7, t7a, t8, t8a, t9, t9a, t10, t10a, t11, t11a];
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
