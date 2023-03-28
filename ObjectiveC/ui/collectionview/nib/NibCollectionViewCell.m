//
//  NibCollectionViewCell.m
//  ObjectiveC
//
//  Created by lzd_free on 2019/2/27.
//  Copyright © 2019 William. All rights reserved.
//

#import "NibCollectionViewCell.h"
#import "PersonModel.h"

@interface NibCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerIMGV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@end

@implementation NibCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setPerson:(PersonModel *)person{
    _person = person;
    self.headerIMGV.image = [UIImage imageNamed: person.header];
    self.nameLB.text = person.name;
}

@end
