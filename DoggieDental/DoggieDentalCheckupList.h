//
//  DoggieDentalCheckupList.h
//  DoggieDental
//
//  Created by Isaac Tozer on 4/20/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DoggieDentalButton;

@interface DoggieDentalCheckupList : UITableViewController <NSURLConnectionDelegate>
{
    NSArray *checkupInfo;
    int numCheckups;
    //NSMutableData *receivedData;
    //UIActivityIndicatorView *spinner;
    DoggieDentalButton *button;
}


@end
