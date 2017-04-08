//
//  RegisterViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobIMSDK/BmobIMSDK.h>

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPswTextField;


@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.registerButton setBackgroundImage:[[UIImage imageNamed:@"login_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:[[UIImage imageNamed:@"login_btn_"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self setDefaultLeftBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerToApp:(id)sender {
    
    if (self.usernameTextField.text.length == 0) {
        [self showInfomation:@"请输入用户名"];
        return;
    }
    if (self.passwordTextField.text.length == 0 || self.confirmPswTextField.text.length == 0) {
        [self showInfomation:@"请输入密码"];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.confirmPswTextField.text]) {
        [self showInfomation:@"两次密码不一致，请重新输入"];
        return;
    }
    BmobUser *user = [[BmobUser alloc] init];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    
    
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:user.objectId];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self showInfomation:error.description];
        }
    } ];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
