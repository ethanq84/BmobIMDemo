//
//  SettingsViewController.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


typedef NS_ENUM(NSUInteger,SettingType) {
    SettingTypeSpace    = 0,   //空白
    SettingTypeAvatar   = 1,
    SettingTypeNick     = 2,
    SettingTypeGender   = 3,
    SettingTypeFeedback = 4
};


@interface SettingsViewController : BaseViewController

@end
