//
//  MainTabBar.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/18.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBar;


@protocol MainTabBarDelegate <NSObject>

@optional
-(void)didSelectedMainTabBar:(MainTabBar *)tabBar index:(NSUInteger)index;

@end

@interface MainTabBar : UIView

@property (weak, nonatomic) id <MainTabBarDelegate> delegate;

@end
