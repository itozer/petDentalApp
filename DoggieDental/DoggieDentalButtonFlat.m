//
//  DoggieDentalButtonFlat.m
//  DoggieDental
//
//  Created by Isaac Tozer on 8/15/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalButtonFlat.h"

@interface DoggieDentalButtonFlat ()

@end

@implementation DoggieDentalButtonFlat

@synthesize color;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}


 - (id)init
 {
 self = [super init];
 if (self) {
 self = [self initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
 }
 return self;
 }



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    switch (color) {
        case 0: //b
            //body
            bodyRed = 133 / 255.0;
            bodyGreen = 180 / 255.0;
            bodyBlue = 4 / 255.0;
            //border
            borderRed = 95 / 255.0;
            borderGreen = 130 / 255.0;
            borderBlue = 0 / 255.0;
            
            //highlighted body
            hBodyRed = 48 / 255.0;
            hBodyGreen = 25 / 255.0;
            hBodyBlue = 15 / 255.0;
            //highlighted border
            hBorderRed = 41 / 255.0;
            hBorderGreen = 21 / 255.0;
            hBorderBlue = 13 / 255.0;
            
            break;
        default:
            break;
    }
    
    /*
    if (self.highlighted == YES)
    {
        CGFloat colors [] = {
            hStartRed, hStartGreen, hStartBlue, 1.0,
            hEndRed, hEndGreen, hEndBlue, 1.0
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        //CGContextAddEllipseInRect(context, rect);
        //CGContextClip(context);
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        
        CGContextRestoreGState(context);
        
        //CGContextAddEllipseInRect(context, rect);
        //CGContextDrawPath(context, kCGPathStroke);
    }
    else
    {
        
        CGFloat colors [] = {
            startRed, startGreen, startBlue, 1.0,
            endRed, endGreen, endBlue, 1.0
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        //CGContextAddEllipseInRect(context, rect);
        //CGContextClip(context);
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        
        CGContextRestoreGState(context);
        
        //CGContextAddEllipseInRect(context, rect);
        //CGContextDrawPath(context, kCGPathStroke);
        
    }
    */
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"highlighted"];
}

@end
