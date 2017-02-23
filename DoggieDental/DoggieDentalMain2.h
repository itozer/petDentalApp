//
//  DoggieDentalMain2.h
//  DoggieDental
//
//  Created by Isaac Tozer on 5/18/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSPreviewScrollView.h"
@class DoggieDentalNearbyVets;
@interface DoggieDentalMain2 : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIScrollView	*_scrollView;   
}

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic) NSMutableArray *mainActionList;
@property (nonatomic) NSMutableArray *mainInfoList;

@end
