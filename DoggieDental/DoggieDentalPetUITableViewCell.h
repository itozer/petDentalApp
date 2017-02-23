//
//  DoggieDentalPetUITableViewCell.h
//  DoggieDental
//
//  Created by Isaac Tozer on 3/16/13.
//  Copyright (c) 2013 Isaac Tozer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoggieDentalPetUITableViewCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *petNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *petTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *petDescriptionLabel;

@end
