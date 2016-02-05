//
//  DiscussionLDetailListViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/25.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DiscussionLDetailListViewController.h"
#import "DiscussionModel.h"
#import "DiscussionSingleViewController.h"
#import "PostNewDiscussionViewController.h"
#import "WorkloadViewController.h"
#import "DetailListTableViewCell.h"
#import "CustomizedAlertView.h"
#import "PersonalSettingViewController.h"

@interface DiscussionLDetailListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView           *detailListTableView;
@property (nonatomic, strong) NSMutableArray        *detailListArray;
@property (nonatomic, strong) NSMutableArray        *workloadListArray;
@property (nonatomic, strong) DiscussionModel       *discussionModel;
@property (nonatomic) BOOL                          isShownWorkloadList;
@property (nonatomic, strong) CustomizedAlertView   *loginAlertView;
@end

@implementation DiscussionLDetailListViewController

- (void)setCategory:(NSString *)category {
    _category = category;
    if (!_discussionModel) {
        _discussionModel = [DiscussionModel new];
        _discussionModel.delegate = self;
    }
    [self setTitle:_category];
    _isShownWorkloadList = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];

    UIButton *customizedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame = CGRectMake(0, 0, 20, 20);
    UIImage *iconImage = [UIImage imageNamed:@"icon_create"];
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDetailList];
}

- (void)initDetailListTableView {
    if (!_detailListTableView) {
        _detailListTableView = [[UITableView alloc] initForAutolayout];
        _detailListTableView.delegate        = self;
        _detailListTableView.dataSource      = self;
        _detailListTableView.backgroundColor = [UIColor clearColor];
        _detailListTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_detailListTableView];
        
        NSMutableArray *discussionTableViewConstraint = [[NSMutableArray alloc] init];
        
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_detailListTableView
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_detailListTableView
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_detailListTableView
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_detailListTableView
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:discussionTableViewConstraint];
        
    }
    [_detailListTableView reloadData];
}

- (void)loadDetailList {
    _detailListArray = @[].mutableCopy;
    if ([_category containsString:@"_"]) {
        DiscussionObject *object = [DiscussionObject new];
        object.title = @"Workload";
        [_detailListArray addObject:object];
        [self loadWorkloadList];
    }
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Loading..." delayToHide:-1];
    [_discussionModel loadDiscussionListWithBlock:_category completeBlock:^(NSArray *listArray) {
        [self.hud hide:YES];
        if (listArray.count > 0) {
            [_detailListArray addObjectsFromArray:listArray];
        } else
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"No discussion data available..." delayToHide:1];
        [self initDetailListTableView];
    }];
}

- (void)loadWorkloadList {
    NSRange range = [_category rangeOfString:@"_"];
    NSString *department = [_category substringToIndex:range.location];
    NSString *course = [_category substringFromIndex:range.location+1];
    _workloadListArray = @[].mutableCopy;
    [_discussionModel loadWorkloadListWithBlock:department course:course completeBlock:^(NSArray *listArray) {
        [_workloadListArray addObjectsFromArray:listArray];
        if (_isShownWorkloadList) {
            [_detailListArray insertObjects:_workloadListArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _workloadListArray.count)]];
            [_detailListTableView reloadData];
        }
    }];
}

#pragma mark - UITableView data source and delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _detailListArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_category containsString:@"_"]) {
        if (indexPath.row == 0 || [_detailListArray[indexPath.row] isKindOfClass:[WorkloadObject class]]) {
            return 60;
        } else {
            return 100;
        }
    } else {
        return 100;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"DiscussionTableViewCell";
    DetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[DetailListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_detailListArray[indexPath.row] isKindOfClass:[DiscussionObject class]]) {
        if (indexPath.row == 0 && [_category containsString:@"_"]) {
            [cell.textLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
            cell.textLabel.text = @"Workload";
            return cell;
        } else {
            DiscussionObject *object = _detailListArray[indexPath.row];
            cell.discussionObject = object;
            return cell;
        }
    } else {
        WorkloadObject *object = _detailListArray[indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        cell.textLabel.text = [NSString stringWithFormat:@"    -%@ %@",object.season,object.year];
        return cell;
    }
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_category containsString:@"_"] && indexPath.row == 0) {
        if (_workloadListArray.count == 0)
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"No workload data available..." delayToHide:1];
        else {
            if (_isShownWorkloadList) {
                [_detailListArray removeObjectsInRange:NSMakeRange(indexPath.row+1, _workloadListArray.count)];
                [UIView transitionWithView:_detailListTableView
                                  duration:0.35f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^(void) {
                                    [_detailListTableView  reloadData];
                                } completion:nil];
                _isShownWorkloadList = NO;
            } else {
                [_detailListArray insertObjects:_workloadListArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, _workloadListArray.count)]];
                [UIView transitionWithView:_detailListTableView
                                  duration:0.35f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^(void) {
                                    [_detailListTableView  reloadData];
                                } completion:nil];
                _isShownWorkloadList = YES;
            }
        }
    } else if ([_detailListArray[indexPath.row] isKindOfClass:[WorkloadObject class]]) {
        WorkloadViewController *controller = [WorkloadViewController new];
        controller.workloadObject = _detailListArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        DiscussionSingleViewController *controller = [DiscussionSingleViewController new];
        controller.discussionObject = _detailListArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createButtonPressed:(id)sender {
    if ([PFUser currentUser]) {
        PostNewDiscussionViewController *controller = [PostNewDiscussionViewController new];
        controller.category = _category;
        _isShownWorkloadList = NO;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self askToLogIn];
    }
}

- (void) askToLogIn {
    _loginAlertView = [[CustomizedAlertView alloc] initWithTitle:@"Warning" andMessage:@"Please login first..."];
    [_loginAlertView addButtonWithTitle:@"No Thanks"
                                     type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                  handler:nil];
    
    [_loginAlertView addButtonWithTitle:@"Login"
                                     type:CustomizedAlertViewButtonTypeDefaultGreen
                                  handler:^(CustomizedAlertView *alertView) {
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
                                                             [_detailListTableView reloadData];
                                                             
                                                         }];
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.hud hide:YES];
                                                              [self loadDetailList];
                                                          }];
    [alert addAction:cancelAction];
    [alert addAction:refreshAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
