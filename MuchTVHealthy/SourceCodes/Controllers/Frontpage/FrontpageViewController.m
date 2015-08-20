//
//  FrontpageViewController.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "FrontpageViewController.h"
#import "FrontpageTableViewCell.h"
#import "FrontpageModel.h"
#import "FrontpageObject.h"
#import "PersonalSettingViewController.h"
#import "PostNewDiscussionViewController.h"
#import "SignUpAndSignInModel.h"
#import "DiscussionSingleViewController.h"
#import "BaseViewController.h"
#import "CustomizedAlertView.h"

@interface FrontpageViewController () <UITableViewDataSource, UITableViewDelegate, FrontpageModelDelegate>
@property (nonatomic, strong) UITableView                       *frontpageTableView;
@property (nonatomic, strong) NSMutableArray                    *frontpageDataArray;
@property (nonatomic, strong) FrontpageModel                    *frontpageModel;
@property (nonatomic, strong) UIRefreshControl                  *refreshControl;
@property (nonatomic) NSUInteger                                loadingStartIndex;
@property (nonatomic) BOOL                                      hasMoreFrontpageData;
@property (nonatomic) BOOL                                      isLoadingMoreFrontpageData;
@property (nonatomic, strong) CustomizedAlertView               *notFinishedAlert;
@property (nonatomic, strong) KiiUser                           *currentUser;
@property (nonatomic) BOOL                                      isFirstLoad;
@end


@implementation FrontpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"首頁"];
    [self initListButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"讀取中..." delayToHide:-1];
//    _frontpageTableView.hidden  = YES;
    _frontpageDataArray = @[].mutableCopy;
    for (int i = 0; i < 5; i ++) {
        [_frontpageDataArray addObject:@"a"];
    }
    [self resetParams];
    if (!_isFirstLoad)
        [self initFrontpageTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initMenuLayout];
    [self initGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dismissMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - inits
- (void) initFrontpageTableView {
    if (!_frontpageTableView) {
        _frontpageTableView                         = [[UITableView alloc] initForAutolayout];
        _frontpageTableView.delegate                = self;
        _frontpageTableView.dataSource              = self;
        _frontpageTableView.backgroundColor         = [UIColor clearColor];
        _frontpageTableView.separatorStyle          = UITableViewCellSeparatorStyleNone;
        _frontpageTableView.scrollIndicatorInsets   = UIEdgeInsetsMake(0, 0, 0, -10);
        _frontpageTableView.clipsToBounds           = NO;
        
        [self.view insertSubview:_frontpageTableView atIndex:0];
        
        NSMutableArray *frontpageTableViewConstraint = [[NSMutableArray alloc] init];
        
        [frontpageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageTableView
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0f constant:10.0f]];
        [frontpageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageTableView
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0f constant:-10.0f]];
        [frontpageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageTableView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0f constant:15.0f]];
        [frontpageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageTableView
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f constant:-15.0f]];
        
        [self.view addConstraints:frontpageTableViewConstraint];
        if (!_refreshControl) {
            _refreshControl = [[UIRefreshControl alloc] init];
            [_refreshControl addTarget:self
                                action:@selector(refreshFrontpage)
                      forControlEvents:UIControlEventValueChanged];
            [_frontpageTableView addSubview:_refreshControl];
            
        }
        
    }
    [_frontpageTableView reloadData];
    
}

#pragma mark - methods
- (void) firstLoadFrontpageData {
    _isFirstLoad = NO;
    if (!_frontpageModel) {
        _frontpageModel = [[FrontpageModel alloc] init];
        _frontpageModel.delegate = self;
    }
    
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    
    if (_loadingStartIndex != 0) {
        _loadingStartIndex = 0;
    }
    [self initMenuLayout];
    [self initFrontpageTableView];

//    [_frontpageModel loadFrontpageData];
    //    [_frontpageTableView reloadData];
}

- (void)loadMoreFrontpageData {
    if (!_frontpageModel) {
        _frontpageModel = [[FrontpageModel alloc] init];
        _frontpageModel.delegate = self;
    }
    _loadingStartIndex += 1;
    [_frontpageModel executeMoreFrontpageData];
}

- (void) resetParams {
    _isLoadingMoreFrontpageData = NO;
    _loadingStartIndex = 0;
    _hasMoreFrontpageData = YES;
//    _frontpageDataArray = @[].mutableCopy;
}



- (void) refreshFrontpage {
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    
    [self firstLoadFrontpageData];
}

#pragma mark - button action
- (void)postDiscussionButtonClicked:(id)sender {
    PostNewDiscussionViewController *controller = [PostNewDiscussionViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - frontpage model delegate
- (void)didLoadFrontpageData:(NSArray *)data {
    [self.hud hide:YES];
    self.navigationItem.leftBarButtonItem.enabled  = YES;
//    [_frontpageDataArray addObjectsFromArray:data];
    
    
    if (_loadingStartIndex == 0) {
        [self resetParams];
        [_frontpageDataArray addObjectsFromArray:data];
        [self initFrontpageTableView];
        _frontpageTableView.hidden = NO;
        [_frontpageTableView reloadData];
    } else {
        [_frontpageDataArray addObjectsFromArray:data];
        [_frontpageTableView reloadData];
    }
}


#pragma mark - UITableView data source and delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _frontpageDataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 15 + (kScreenWidth-30-5)*3.0f/4.0f + 7.8f + 43.0f + 5.0f + 21.5f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FrontpageTableViewCell";
    FrontpageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[FrontpageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
//    cell.frontpageObject = _frontpageDataArray[indexPath.row];
    cell.string = _frontpageDataArray[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _frontpageDataArray.count - 1 && _hasMoreFrontpageData && _frontpageDataArray.count >= 5 && !_isLoadingMoreFrontpageData) {
        _isLoadingMoreFrontpageData = YES;
        
        dispatch_async(dispatch_get_main_queue(),^{
            NSRange range = NSMakeRange(0, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [_frontpageTableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
        });
        
        [self loadMoreFrontpageData];
        
    }
    
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
