//
//  DoggieDentalButtonFlat.h
//  DoggieDental
//
//  Created by Isaac Tozer on 8/15/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoggieDentalButtonFlat : UIButton {
    CGFloat bodyRed;
    CGFloat bodyGreen;
    CGFloat bodyBlue;
    CGFloat borderRed;
    CGFloat borderGreen;
    CGFloat borderBlue;
    
    CGFloat hBodyRed;
    CGFloat hBodyGreen;
    CGFloat hBodyBlue;
    CGFloat hBorderRed;
    CGFloat hBorderGreen;
    CGFloat hBorderBlue;
}

@property NSInteger color;    //0 = green

@end
