//
//  DoggieDentalButton.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/16/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoggieDentalButton : UIButton {
    CGFloat startRed;
    CGFloat startGreen;
    CGFloat startBlue;
    CGFloat endRed;
    CGFloat endGreen;
    CGFloat endBlue;
    
    CGFloat hStartRed;
    CGFloat hStartGreen;
    CGFloat hStartBlue;
    CGFloat hEndRed;
    CGFloat hEndGreen;
    CGFloat hEndBlue;
}

@property NSInteger colorGradient;    //0 = brown, 1 = green

@end

