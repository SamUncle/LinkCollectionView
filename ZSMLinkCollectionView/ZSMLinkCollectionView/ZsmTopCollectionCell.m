//
//  ZsmTopCollectionCell.m
//  ZSMLinkCollectionView
//
//  Created by zsm on 2020/5/18.
//  Copyright © 2020 zsm. All rights reserved.
//

#import "ZsmTopCollectionCell.h"

@implementation ZsmTopCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected{

    [super setSelected:selected];

    if(selected) {

        self.contentView.layer.borderColor=UIColor.grayColor.CGColor;

    }else{

        self.contentView.layer.borderColor=UIColor.whiteColor.CGColor;

    }

}
@end
