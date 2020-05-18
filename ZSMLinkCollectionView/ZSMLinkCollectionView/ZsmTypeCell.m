//
//  ZsmTypeCell.m
//  ZSMLinkCollectionView
//
//  Created by zsm on 2020/5/18.
//  Copyright © 2020 zsm. All rights reserved.
//

#import "ZsmTypeCell.h"

@implementation ZsmTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected{

    [super setSelected:selected];

    if(selected) {

        self.lab.backgroundColor=UIColor.grayColor;

    }else{

        self.lab.backgroundColor=UIColor.whiteColor;

    }

}
 

@end
