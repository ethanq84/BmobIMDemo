//
//  AvatarTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/20.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "AvatarTableViewCell.h"

@implementation AvatarTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView.layer setCornerRadius:25];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
