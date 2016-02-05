//
//  CourseListViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "CourseListViewController.h"
#import "DiscussionLDetailListViewController.h"
#import "CustomizedAlertView.h"
#import "UserModel.h"
#import <Parse/Parse.h>
#import "CustomizedAlertView.h"
#import "PersonalSettingViewController.h"
#import "GameTableViewCell.h"
#import "DiscussionModel.h"


@interface CourseListViewController () <UITableViewDataSource, UITableViewDelegate, GameTableViewCellDelegate>
@property (nonatomic, strong) UITableView           *courseTableView;
@property (nonatomic, strong) CustomizedAlertView   *alertView;
@property (nonatomic) BOOL                          isAdding;
@property (nonatomic, strong) UserModel             *userModel;
@property (nonatomic, strong) PFUser                *currentUser;
@property (nonatomic, strong) CustomizedAlertView   *loginAlertView;
@property (nonatomic, strong) DiscussionModel       *discussionModel;
@property (nonatomic, strong) NSMutableArray        *courseListArray;
@end

@implementation CourseListViewController

- (void)setDepartment:(NSString *)department {
    _department = [department substringFromIndex:5];
    _courseListArray = @[].mutableCopy;
    [self loadCourseList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    self.title = _department;
    _userModel = [UserModel new];
    _userModel.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _currentUser = [PFUser currentUser];
}

- (void) loadCourseList {
    _discussionModel = [DiscussionModel new];
    [_discussionModel loadCourseListWithBlock:_department completeBlock:^(NSArray *array) {
        [_courseListArray addObjectsFromArray:array];
        [self initCourseTableView];
    }];
}

- (void)initCourseTableView {
    if (!_courseTableView) {
        _courseTableView = [[UITableView alloc] initForAutolayout];
        _courseTableView.delegate        = self;
        _courseTableView.dataSource      = self;
        _courseTableView.backgroundColor = [UIColor clearColor];
        _courseTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_courseTableView];
        
        NSMutableArray *discussionTableViewConstraint = [[NSMutableArray alloc] init];
        
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_courseTableView
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_courseTableView
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_courseTableView
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_courseTableView
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:discussionTableViewConstraint];
    }
    [_courseTableView reloadData];
}

#pragma mark - UITableView data source and delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _courseListArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"GameTableViewCell";
    GameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[GameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.category = [NSString stringWithFormat:@"%@_%@",_department, _courseListArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussionLDetailListViewController *controller = [DiscussionLDetailListViewController new];
    controller.category = [NSString stringWithFormat:@"%@_%@",_department, _courseListArray[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)handleLongPress:(NSString *)category {
    if (!_isAdding) {
        if ([PFUser currentUser]) {
            _isAdding = YES;
            _alertView = [[CustomizedAlertView alloc] initWithTitle:@"Add to my favorites" andMessage:@"Are you sure?"];
            [_alertView addButtonWithTitle:@"NO"
                                      type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                   handler:^(CustomizedAlertView *alertView) {
                                       _isAdding = NO;
                                   }];
            [_alertView addButtonWithTitle:@"YES"
                                      type:CustomizedAlertViewButtonTypeDefaultGreen
                                   handler:^(CustomizedAlertView *alertView) {
                                       _isAdding = NO;
                                       [_userModel updateFavorites:category ForUser:_currentUser completeBlock:^(BOOL isExist) {
                                           if (isExist) {
                                               [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Already on favorites..." delayToHide:1];
                                           } else {
                                               [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Successfully add to my favorites..." delayToHide:1];
                                           }
                                       }];
                                   }];
            [_alertView show];

        } else {
            _isAdding = YES;
            [self askToLogIn];
        }
    }
}

- (void) askToLogIn {
    _loginAlertView = [[CustomizedAlertView alloc] initWithTitle:@"Warning" andMessage:@"Please login first..."];
    [_loginAlertView addButtonWithTitle:@"No Thanks"
                                   type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                handler:^(CustomizedAlertView *alertView) {
                                    _isAdding = NO;
                                }];
    
    [_loginAlertView addButtonWithTitle:@"Login"
                                   type:CustomizedAlertViewButtonTypeDefaultGreen
                                handler:^(CustomizedAlertView *alertView) {
                                    _isAdding = NO;
                                    PersonalSettingViewController *controller = [[PersonalSettingViewController alloc] init];
                                    [self.navigationController pushViewController:controller animated:YES];
                                }];
    [_loginAlertView show];
}

- (void)hasNoNetworkConnection {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can not connect to the Internet. Please check the connection. "
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [self.hud hide:YES];
                                                             [_courseTableView reloadData];
                                                             
                                                         }];
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.hud hide:YES];
                                                          }];
    [alert addAction:cancelAction];
    [alert addAction:refreshAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
