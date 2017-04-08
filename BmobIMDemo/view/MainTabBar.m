//
//  MainTabBar.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/18.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "MainTabBar.h"
#import "UIColor+SubClass.h"
@interface MainTabBar ()<UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITabBarItem *recentTabbarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *contactTabbarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *settingTabbarItem;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@end


@implementation MainTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupTabBarAppearence];
        
        UIView *mainView = [[[NSBundle mainBundle] loadNibNamed:@"MainTabBar" owner:self options:nil] firstObject];
        [self addSubview:mainView];
        self.tabBar.selectedItem = self.recentTabbarItem;
        self.tabBar.delegate = self;
        
    }
    
    return self;
}


-(void)setupTabBarAppearence{
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithR:164 g:168 b:171], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithR:73  g:150 b:240], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
//    if (self.tabBar.selectedItem != item) {
        NSUInteger index = 0;
        if (item == self.recentTabbarItem) {
            index = 0;
        }else if (item == self.contactTabbarItem){
            index = 1;
        }else{
            index = 2;
        }
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMainTabBar:index:)]) {
            [self.delegate didSelectedMainTabBar:self index:index];
        }
//    }
    
    
//    for (UIBarButtonItem *item in tabBar.items) {
//        item.enabled = YES;
//    }
//    item.enabled = NO;
//    NSLog(@"item %@",item);
}


@end
