//
//  DoggieDentalButton.m
//  DoggieDental
//
//  Created by Isaac Tozer on 3/16/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalButton.h"

@interface DoggieDentalButton ()

@end

@implementation DoggieDentalButton

@synthesize colorGradient;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

/*
- (id)init
{
    self = [super init];
    if (self) {
        self = [self initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }
    return self;
}
*/


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    switch (colorGradient) {
        case 0: //brown
            //light
            startRed = 107 / 255.0;
            startGreen = 52 / 255.0;
            startBlue = 30 / 255.0;
            //dark
            endRed = 52 / 255.0;
            endGreen = 27 / 255.0;
            endBlue = 17 / 255.0;
            
            hStartRed = 48 / 255.0;
            hStartGreen = 25 / 255.0;
            hStartBlue = 15 / 255.0;
            //dark
            hEndRed = 41 / 255.0;
            hEndGreen = 21 / 255.0;
            hEndBlue = 13 / 255.0;
            
            
            break;
        case 1: //green
            /*
            //light
            startRed = 121 / 255.0;
            startGreen = 163 / 255.0;
            startBlue = 4 / 255.0;
            //dark
            endRed = 51 / 255.0;
            endGreen = 69 / 255.0;
            endBlue = 2 / 255.0;
            
            hStartRed = 51 / 255.0;
            hStartGreen = 69 / 255.0;
            hStartBlue = 2 / 255.0;
            //dark
            hEndRed = 47 / 255.0;
            hEndGreen = 64 / 255.0;
            hEndBlue = 1 / 255.0;
            */
            
            //light
            startRed = 121 / 255.0;
            startGreen = 163 / 255.0;
            startBlue = 4 / 255.0;
            //dark
            endRed = 71 / 255.0;
            endGreen = 96 / 255.0;
            endBlue = 3 / 255.0;
            
            hStartRed = 51 / 255.0;
            hStartGreen = 69 / 255.0;
            hStartBlue = 2 / 255.0;
            //dark
            hEndRed = 47 / 255.0;
            hEndGreen = 64 / 255.0;
            hEndBlue = 1 / 255.0;
            
            /*
            //green same as splash
            //light
            startRed = 160 / 255.0;
            startGreen = 190 / 255.0;
            startBlue = 79 / 255.0;
            //dark
            endRed = 128 / 255.0;
            endGreen = 167 / 255.0;
            endBlue = 19 / 255.0;
            
            hStartRed = 51 / 255.0;
            hStartGreen = 69 / 255.0;
            hStartBlue = 2 / 255.0;
            //dark
            hEndRed = 47 / 255.0;
            hEndGreen = 64 / 255.0;
            hEndBlue = 1 / 255.0;
            */
            
            break;
            
        case 2: //blue
            //light
            startRed = 12 / 255.0;
            startGreen = 120 / 255.0;
            startBlue = 156 / 255.0;
            //dark
            endRed = 8 / 255.0;
            endGreen = 69 / 255.0;
            endBlue = 89 / 255.0;
            
            hStartRed = 8 / 255.0;
            hStartGreen = 69 / 255.0;
            hStartBlue = 89 / 255.0;
            //dark
            hEndRed = 8 / 255.0;
            hEndGreen = 69 / 255.0;
            hEndBlue = 89 / 255.0;
            break;
        
        default:
            break;
    }
    
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
    
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"highlighted"];
}

@end
