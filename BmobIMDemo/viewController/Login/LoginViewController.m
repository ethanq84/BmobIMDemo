//
//  LoginViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/13.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "TTTAttributedLabel.h"
#import "UIColor+SubClass.h"

@interface LoginViewController ()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *registerLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.LoginButton setBackgroundImage:[[UIImage imageNamed:@"login_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.LoginButton setBackgroundImage:[[UIImage imageNamed:@"login_btn_"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    NSString *string = @"还没有账号?立即注册";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithR:159 g:160 b:160]}];
    
    NSRange range = [string rangeOfString:@"立即注册"];
    
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithR:71 g:156 b:249]} range:range];
    self.registerLabel.text = attributedString;
    self.registerLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [self.registerLabel addLinkToURL:[NSURL URLWithString:@"register"] withRange:range];
    
    self.registerLabel.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    
    if (self.usernameTextField.text.length == 0) {
        [self showInfomation:@"请输入用户名"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [self showInfomation:@"请输入密码"];
        return;
    }
    
    [self showLoading];
    
    [BmobUser loginInbackgroundWithAccount:self.usernameTextField.text
                               andPassword:self.passwordTextField.text
                                     block:^(BmobUser *user, NSError *error) {
                                         if (user) {
                                             
//                                             BmobUser *user = [BmobUser getCurrentUser];
//                                             
//                                             [user setObject:@"kaka" forKey:@"nickname"];
//                                             
//                                             [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                                                 
//                                                 if (isSuccessful){
//                                                     NSLog(@"修改昵称 successfully");
//                                                     
//                                                     [self.navigationController popViewControllerAnimated:YES];
//                                                 } else {
//                                                     NSLog(@"修改昵称 %@",error);
//                                                 }
//                                             }];

                                             [self hideLoading];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:user.objectId];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }else{
                                             [self showInfomation:error.description];
                                         }
    }];
    
//    [BmobUser loginWithUsernameInBackground:self.usernameTextField.text
//                                   password:self.passwordTextField.text
//                                      block:^(BmobUser *user, NSError *error) {
//                                          if (user) {
//                                              [self hideLoading];
//                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:user.objectId];
//                                              [self dismissViewControllerAnimated:YES completion:nil];
//                                          }else{
//                                              [self showInfomation:error.description];
//                                          }
//                                      }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    NSLog(@"url %@",url.absoluteString);
    
    [self performSegueWithIdentifier:@"toRegisterVC" sender:nil];
}

@end
