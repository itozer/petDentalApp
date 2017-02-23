//
//  DoggieDentalHomeCollectionCell.m
//  DoggieDental
//
//  Created by Isaac Tozer on 5/19/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import "DoggieDentalHomeCollectionCell.h"

@implementation DoggieDentalHomeCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundView:nil];
        [self setBackgroundColor:[UIColor clearColor]];
        [[self imageView] setBackgroundColor:[UIColor clearColor]];
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DoggieDentalHomeCollectionCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}


-(void)updateCell {
    
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"slides"];
    NSString *filename = [NSString stringWithFormat:@"%@/%@", sourcePath, self.imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filename];
    
    [self.imageView setImage:image];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
