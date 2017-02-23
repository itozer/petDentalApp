//
//  DoggieDentalHomeCollectionCell.h
//  DoggieDental
//
//  Created by Isaac Tozer on 5/19/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoggieDentalHomeCollectionCell : UICollectionViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSString *imageName;

-(void)updateCell;

@end
