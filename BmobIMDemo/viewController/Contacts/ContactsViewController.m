//
//  ContactsViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ContactsViewController.h"
#import "ViewUtil.h"
#import "UserService.h"
#import "UserInfoTableViewCell.h"
#import "ChatViewController.h"


@interface ContactsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *inviteView;
@property (weak, nonatomic) IBOutlet UIView *nearbyView;
@property (strong, nonatomic) NSMutableArray *userArray;
@end

@implementation ContactsViewController

static NSString *cellId = @"UserInfoCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubviews];
    
    _userArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadUserFriends];
}


-(void)setupSubviews{
    [self setupRightBarButtonItem];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMessagesVC)];
    [self.inviteView addGestureRecognizer:tapRecognizer];
    
    UINib *nib = [UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellId];
    self.tableView.rowHeight = 60;
}


-(void)setupRightBarButtonItem{
    UIButton *button = [ViewUtil buttonWithTitle:nil image:[UIImage imageNamed:@"contact_add"] highlightedImage:[UIImage imageNamed:@"contact_add_"]];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(toUserVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

}


-(void)loadUserFriends{
    [UserService friendsWithCompletion:^(NSArray *array, NSError *error) {
        if (error) {
            [self showInfomation:error.localizedDescription];
        }else{
            BmobUser *loginUser = [BmobUser getCurrentUser];
            NSMutableArray *result  = [NSMutableArray array];
            for (BmobObject *obj in array) {
               
                BmobUser *friend = nil;
                if ([[(BmobUser *)[obj objectForKey:@"user"] objectId] isEqualToString:loginUser.objectId]) {
                    friend = [obj objectForKey:@"friendUser"];
                }else{
                    friend = [obj objectForKey:@"user"];
                }
                BmobIMUserInfo *info = [BmobIMUserInfo userInfoWithBmobUser:friend];
                
                [result addObject:info];
            }
            if (result && result.count > 0) {
                [self.userArray setArray:result];
                [self.tableView reloadData];
                
            }
            
        }
    }];
}


-(void)toUserVC{
    [self performSegueWithIdentifier:@"toUserVC" sender:nil];
}

-(void)toMessagesVC{
    [self performSegueWithIdentifier:@"toMessageVC" sender:nil];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentifier = cellId;
    
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    BmobIMUserInfo *info = self.userArray[indexPath.row];
    
    [cell setInfo:info];
    
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BmobIMUserInfo *info = self.userArray[indexPath.row];
    
    BmobIMConversation *conversation = [BmobIMConversation conversationWithId:info.userId conversationType:BmobIMConversationTypeSingle];
    conversation.conversationTitle =  info.name;
    [self performSegueWithIdentifier:@"toChatVC" sender:conversation];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toChatVC"]) {
        ChatViewController *cvc = segue.destinationViewController;
        cvc.conversation = sender;
    }
}


@end
