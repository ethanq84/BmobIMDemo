//
//  RootTabBarController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/18.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "RootTabBarController.h"
#import "UIColor+SubClass.h"
#import "BmobIMDemoPCH.h"
#import <BmobSDK/Bmob.h>
#import "ViewController.h"

@interface RootTabBarController ()

@end


@implementation RootTabBarController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViewControllers];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([BmobUser getCurrentUser]) {
//        [self toViewController];
    }else{
        [self toLoginVC];
    }
    
}



-(void)setupViewControllers{
    self.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *snc = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateInitialViewController];
    [snc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
    UINavigationController *cnc = [[UIStoryboard storyboardWithName:@"Contacts" bundle:nil] instantiateInitialViewController];
    [cnc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
    UINavigationController *rnc = [[UIStoryboard storyboardWithName:@"Recent" bundle:nil] instantiateInitialViewController];
    [rnc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
    self.viewControllers = @[rnc,cnc,snc];
    
    for (int i = 0; i < self.tabBar.items.count; i ++) {
        UITabBarItem *item = self.tabBar.items[i];
        switch (i) {
            case 0:{
                item.image = [UIImage imageNamed:@"tab_icon1"];
                item.selectedImage = [UIImage imageNamed:@"tab_icon1_"];
                item.title = @"会话";
            }
                break;
            case 1:{
                item.image = [UIImage imageNamed:@"tab_icon2"];
                item.selectedImage = [UIImage imageNamed:@"tab_icon2_"];
                item.title = @"联系人";
            }
                break;
            case 2:{
                item.image = [UIImage imageNamed:@"tab_icon3"];
                item.selectedImage = [UIImage imageNamed:@"tab_icon3_"];
                item.title = @"设置";
            }
                break;
            default:
                break;
        }
        
    }
    
    self.tabBar.barTintColor = [UIColor colorWithR:43 g:46 b:51];

}

-(void)toLoginVC{
    
    UINavigationController *loginNC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNC"];
//    UINavigationController *lnc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNC animated:YES completion:nil];
    [loginNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
    loginNC.navigationBar.titleTextAttributes = dic;

}


-(void)toViewController{
    ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
