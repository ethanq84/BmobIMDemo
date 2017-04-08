//
//  ViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/13.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ViewController.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
@interface ViewController ()<BmobIMDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *targetTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) BmobIM *bIM;
@property (copy, nonatomic) NSString *userId;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveMessage:) name:@"NewMessages" object:nil];
    BmobUser *user = [BmobUser getCurrentUser];
    if (!user) {
        [self performSelector:@selector(presentLoginVC) withObject:nil afterDelay:1.5f];
    }else{
        
    }
    _bIM = [BmobIM  sharedBmobIM];
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        self.userId = user.objectId;
        //@"5VXTNNNf" @"GLscCCCO"
        if ([user.objectId isEqualToString:@"5VXTNNNf"]) {
            self.targetTextField.text = @"GLscCCCO";
        }else{
            self.targetTextField.text = @"5VXTNNNf";
        }
    }
}

-(void)presentLoginVC{
    LoginViewController *lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self presentViewController:lvc animated:YES completion:nil];
}

- (IBAction)sendMessage:(id)sender {
    
    
//    BmobIMMessage *msg       = [[BmobIMMessage alloc] init];
//    msg.toId              = self.targetTextField.text;
//    msg.msgType           = BIMMessageTypeText;
//    msg.content           = self.textField.text;
//    msg.createdTime       = (long)([[NSDate date] timeIntervalSince1970] * 1000);
//    msg.fromId            = self.userId;
//    msg.isRead            = BIMMessageReaded;
//    msg.conversationId    = [NSString stringWithFormat:@"%@&%@",msg.toId,msg.fromId];
//    [self.chatManager sendMessage:msg completion:^(BOOL isSuccessful, NSError *error) {
//        if (isSuccessful) {
//            msg.status = BIMMessageStatusDefault;
//        }else{
//            msg.status = BIMMessageStatusSendFailed;
//        }
//        
//        msg.updatedTime = (long)([[NSDate date] timeIntervalSince1970] * 1000);
//        [[BIMDatabaseManager defaultDatabaseManager] saveMessage:msg];
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didRecieveMessage:(NSNotification *)noti{
    BmobIMMessage *message = noti.object;
    self.textView.text = message.content;
}


-(void)main{
    NSLog(@"123");
}

@end
