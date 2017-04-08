//
//  SettingsViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "SettingsViewController.h"
#import "AvatarTableViewCell.h"
#import "TitleTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <BmobSDK/Bmob.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "UIColor+SubClass.h"
#import "ViewUtil.h"


@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) BmobUser       *user;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] initWithObjects:@(SettingTypeSpace),@(SettingTypeAvatar),@(SettingTypeNick),@(SettingTypeGender),@(SettingTypeSpace),@(SettingTypeFeedback), nil];
    self.user = [BmobUser getCurrentUser];
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([BmobUser getCurrentUser]) {
        self.logoutButton.enabled = YES;
        self.user = [BmobUser getCurrentUser];
        [self.tableView reloadData];
    }else{
        self.logoutButton.enabled = NO;
    }
}


-(void)setupSubviews{
    [self.logoutButton setBackgroundImage:[[UIImage imageNamed:@"logout_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundImage:[[UIImage imageNamed:@"logout_btn_"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    self.tableView.backgroundColor = [UIColor colorWithR:241 g:242 b:246];
    [self.tableView reloadData];
    [self.logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
}

-(void)logout{
    if ([BmobUser getCurrentUser]) {
        [BmobUser logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
        [self showInfomation:@"退出成功"];
        [self toLoginVC];
    }else{
        [self showInfomation:@"未登录"];
    }
    
}


#pragma mark - UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat heght = 44.0f;
    NSUInteger type = [self.dataArray[indexPath.row] unsignedIntegerValue];
    switch (type) {
        case SettingTypeSpace:{
            heght = 20.0f;
        }
            break;
        case SettingTypeAvatar:{
            heght = 70.0f;
        }
            break;
        default:
            break;
    }
    
    return heght;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger type = [self.dataArray[indexPath.row] unsignedIntegerValue];
    switch (type) {
        case SettingTypeSpace:{
            return [self spaceTableViewCell:tableView indexPath:indexPath];
        }
            break;
        case SettingTypeAvatar:{
            return [self avatarTableViewCell:tableView indexPath:indexPath];
        }
            break;
        default:{
            return [self titleTableViewCell:tableView indexPath:indexPath type:type];
        }
            break;
    }
    
}

-(UITableViewCell *)spaceTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor colorWithR:241 g:242 b:246];
    return cell;
}

-(UITableViewCell *)avatarTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"AvatarCellID";
    AvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[AvatarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.titleLabel.text = @"头像";
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[self.user objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"head"]];
    return cell;
}

-(UITableViewCell *)titleTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath type:(SettingType)type{
    static NSString *cellIdentifier = @"SettingsCellID";
    TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[TitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (type) {
        case SettingTypeNick:{
            cell.titleLabel.text = @"昵称";
            cell.contentLabel.text = [self.user objectForKey:@"nick"]?:self.user.username;
        }
            break;
        case SettingTypeGender:{
            cell.titleLabel.text = @"性别";
//            if ([self.user objectForKey:@"gender"]) {
//                if ([[self.user objectForKey:@"gender"] integerValue] == BIMUserMan) {
//                    cell.contentLabel.text = @"男";
//                }else{
//                    cell.contentLabel.text = @"女";
//                }
//            }else{
//                cell.contentLabel.text = nil;
//            }
            
        }
            break;
        case SettingTypeFeedback:{
            cell.titleLabel.text = @"意见反馈";
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSUInteger type = [self.dataArray[indexPath.row] unsignedIntegerValue];
    switch (type) {
        case SettingTypeGender:{
//            [self changeGender];
        }
            break;
        case SettingTypeAvatar:{
            [self upload];
        }
            break;
        case SettingTypeNick:{
            [self changeNick];
        }
            break;
        default:
            break;
    }
}


-(void)upload{
    UIActionSheet *acs = [[UIActionSheet alloc] initWithTitle:@"上传头像"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"相册",@"拍照", nil];
    acs.tag = 1000;
    [acs showInView:self.tableView];
}


-(void)changeGender{
    UIActionSheet *acs = [[UIActionSheet alloc] initWithTitle:@"选择性别"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"男",@"女", nil];
    acs.tag = 1001;
    [acs showInView:self.tableView];
}

-(void)changeNick{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"填入昵称"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - image picker
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image.size.width != image.size.height) {
        [self showInfomation:@"长宽不一致"];
    }else{
        UIImage *scaleImage = [ViewUtil imageByScalingToSize:CGSizeMake(200, 200) sourceImage:image];
        BmobFile *file = [[BmobFile alloc] initWithFileName:@"avatar.png" withFileData:UIImagePNGRepresentation(scaleImage)];
        [file saveInBackgroundByDataSharding:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [self modifyUserWithKey:@"avatar" object:file.url type:SettingTypeAvatar];
            }else{
                [self showInfomation:error.localizedDescription];
            }
        } progressBlock:^(CGFloat progress) {
            [self showProgress:progress];
        }];
    }
}

#pragma mark - uiaction sheet
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 1000) {
        switch (buttonIndex) {
            case 0:{
                [self toPhotoLib];
            }
                break;
            case 1:{
                [self toTakePhoto];
            }
                break;
            default:
                break;
        }
    }else if(actionSheet.tag == 1001){
//        switch (buttonIndex) {
//            case 0:{
//                [self modifyUserWithKey:@"gender" object:[NSNumber numberWithInt:BIMUserMan] type:SettingTypeGender];
//            }
//                break;
//            case 1:{
//                        [self modifyUserWithKey:@"gender" object:[NSNumber numberWithInt:BIMUserWoman] type:SettingTypeGender];
//            }
//                break;
//            default:
//                break;
//        }
    }
}



-(void)modifyUserWithKey:(NSString *)key object:(id )object type:(SettingType)type{
    BmobUser *user = [BmobUser objectWithoutDatatWithClassName:nil objectId:self.user.objectId];
    [user setObject:object forKey:key];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self.user setObject:object forKey:key];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.dataArray indexOfObject:@(type)] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    }
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:{
            [self modifyUserWithKey:@"nick" object:[alertView textFieldAtIndex:0].text type:SettingTypeNick];
        }
            break;
        default:
            break;
    }
}


-(void)toPhotoLib{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [imagePickerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsCompact];
    
    imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)toTakePhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [imagePickerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsCompact];
        
        imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        [self showInfomation:@"无可用摄像头"];
    }
}


-(void)toLoginVC{

    UINavigationController *loginNC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNC"];
    //    UINavigationController *lnc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNC animated:YES completion:nil];
    [loginNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
    loginNC.navigationBar.titleTextAttributes = dic;
    
}

@end
