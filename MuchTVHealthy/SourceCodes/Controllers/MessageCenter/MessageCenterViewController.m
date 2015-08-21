//
//  MessageCenterViewController.m
//  North7
//
//  Created by Weiyu Chen on 2015/5/8.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageTableViewCell.h"
#import "DiscussionSingleViewController.h"

@interface MessageCenterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView               *messageTableView;
@property (nonatomic, strong) NSLayoutConstraint        *messageTableViewTopConstraint;
@property (nonatomic, strong) UIRefreshControl          *refreshControl;
@property (nonatomic, strong) NSMutableArray            *messageList;
@property (nonatomic) BOOL                              isFirstLoad;
@property (nonatomic) NSUInteger                        loadingStartIndex;
@property (nonatomic) BOOL                              hasMoreMessage;
@property (nonatomic) BOOL                              isLoadingMoreMessage;
@property (nonatomic, strong) UIActivityIndicatorView   *activityIndicator;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"訊息中心";
    [self initListButton];
    _isFirstLoad = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _messageList = @[].mutableCopy;
    for (int i = 0; i < 10; i++) {
        [_messageList addObject:@"abc"];
    }
    [self initMessageTableView];
//    if (_isFirstLoad) {
//        [self cleanBadge];
//    }
//    [self refresh];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (void) initMessageTableView {
    if (!_messageTableView) {
        _messageTableView                              = [[UITableView alloc] initForAutolayout];
        _messageTableView.delegate                     = self;
        _messageTableView.dataSource                   = self;
//        _messageTableView.separatorColor               = [UIColor colorWithHexString:@"#bedadc"];
        _messageTableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
        _messageTableView.scrollIndicatorInsets        = UIEdgeInsetsMake(0, 0, 0, -10);
        _messageTableView.clipsToBounds                = NO;
        _messageTableView.scrollIndicatorInsets        = UIEdgeInsetsMake(0,0,0,0);
        [_messageTableView setLayoutMargins:UIEdgeInsetsZero];
        [self.view addSubview:_messageTableView];
        
        NSMutableArray *messageTableViewConstraint = [[NSMutableArray alloc] init];
        
        [messageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_messageTableView
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0f constant:0.0f]];
        [messageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_messageTableView
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0f constant:0.0f]];
        [messageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_messageTableView
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0f constant:0.0f]];
        [messageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_messageTableView
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:messageTableViewConstraint];
        if (!_refreshControl) {
            _refreshControl = [[UIRefreshControl alloc] init];
            [_refreshControl addTarget:self
                                action:@selector(refreshMessage)
                      forControlEvents:UIControlEventValueChanged];
            [_messageTableView addSubview:_refreshControl];
            
        }


    }
    
    [_messageTableView reloadData];
}

#pragma mark - notification handler(overwrite)
- (void) receiveNotification:(NSNotification *)notification {
    [super receiveNotification:notification];
//    [self loadMessageListInBackground];
//    [self cleanBadge];
}

//#pragma mark - notification handlers
//- (void) refreshMainLayout: (NSNotification *)notification {
//    [UIView animateWithDuration:0.3f animations:^(){
//        if ([self.view.constraints containsObject:_messageTableViewTopConstraint]) {
//            [self.view removeConstraint:_messageTableViewTopConstraint];
//        }
//        _messageTableViewTopConstraint = [NSLayoutConstraint constraintWithItem:_messageTableView
//                                                                      attribute:NSLayoutAttributeTop
//                                                                      relatedBy:NSLayoutRelationEqual
//                                                                         toItem:self.view
//                                                                      attribute:NSLayoutAttributeTop
//                                                                     multiplier:1.0f constant:self.appdelegate.isVoteActivitiesInProgress ? kVoteActivitiesViewHeight : 0.0f];
//        [self.view addConstraint:_messageTableViewTopConstraint];
//        
//        [self.view layoutIfNeeded];
//    }];
//}
//
#pragma mark - methods
- (void) refreshMessage {
//    if ([_refreshControl isRefreshing]) {
//        [_refreshControl endRefreshing];
//    }
//    _isFirstLoad = YES;
//    [self refresh];
}
//
//- (void) resetParams {
//    if (_messageModel.privateMessageNextQuery) {
//        _messageModel.privateMessageNextQuery = nil;
//    }
//    _isLoadingMoreMessage = NO;
//    _loadingStartIndex    = 0;
//    _hasMoreMessage       = YES;
//    _messageList          = @[].mutableCopy;
//}
//
//-(void) refresh {
//    if (_isFirstLoad) {
//        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"讀取中..." delayToHide:-1];
//    }
//    [_messageModel refreshMessageWithBlock:^(NSString *returnedValue) {
//        if ([returnedValue isEqualToString:@"refresh ok"]) {
//            if (_isFirstLoad)
//                [self firstLoadMessage];
//            else {
//                [_messageModel loadPrivateMessageInBackgroundWithLimit:_messageList.count CompleteBlock:^(NSArray *messageArray, BOOL hasMore) {
//                    _messageList = @[].mutableCopy;
//                    [_messageList addObjectsFromArray:messageArray];
//                    _hasMoreMessage = hasMore;
//                    [_messageTableView reloadData];
//                }];
//            }
//        }
//    }];
//}

//- (void) firstLoadMessage {
//    [self resetParams];
//
//    if ([_refreshControl isRefreshing]) {
//        [_refreshControl endRefreshing];
//    }
//    [_messageModel loadPrivateMessageWithBlock:^(NSArray *messageArray, BOOL hasMore) {
//        [self.hud hide:YES];
//        
//        if (_isLoadingMoreMessage) {
//            _isLoadingMoreMessage = NO;
//            [_activityIndicator stopAnimating];
//        }
//        
//        _hasMoreMessage = hasMore;
//        if (messageArray.count != 0) {
//            [_messageList addObjectsFromArray:messageArray];
//            [self initMessageTableView];
//        } else {
//            if (_isFirstLoad) {
//                [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"目前沒有任何通知" delayToHide:1];
//            }
//        }
//        _isFirstLoad = NO;
//    }];
//}

//- (void) loadMoreMessage {
//    if (_isLoadingMoreMessage) {
//        _isLoadingMoreMessage = NO;
//        [_activityIndicator stopAnimating];
//    }
//    [_messageModel loadPrivateMessageWithBlock:^(NSArray *messageArray, BOOL hasMore) {
//        [self.hud hide:YES];
//        
//        if (_isLoadingMoreMessage) {
//            _isLoadingMoreMessage = NO;
//            [_activityIndicator stopAnimating];
//        }
//        
//        _hasMoreMessage = hasMore;
//        if (messageArray.count != 0) {
//            [_messageList addObjectsFromArray:messageArray];
//            [self initMessageTableView];
//        } else {
//            if (_isFirstLoad) {
//                [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"目前沒有任何通知" delayToHide:1];
//            }
//        }
//        _isFirstLoad = NO;
//    }];
//}
//
//- (void) loadMessageListInBackground {
//    if (!_messageModel) {
//        _messageModel = [[MessageModel alloc] init];
//        _messageModel.delegate = self;
//    }
//    [_messageModel loadMessageFromStartIndex:0 Length:5];
//}
//
//- (void) cleanBadge {
//    [self.appdelegate cleanBadgeNumber];
//}

#pragma mark - UITableView data source and delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _messageList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFrameHeight * 11/60 + 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
//    [cell setSeparatorInset:UIEdgeInsetsZero];
//    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *bottomLine          = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight * 11/60, kScreenWidth, 0.5)];
    bottomLine.backgroundColor  = [UIColor colorWithHexString:@"0f9bab"];
    [cell.contentView addSubview:bottomLine];

    
    cell.frameHeight = kFrameHeight;
    cell.messgae     = _messageList[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!_messageModel) {
//        _messageModel = [[MessageModel alloc] init];
//        _messageModel.delegate = self;
//    }
//    MessageObject *object = _messageList[indexPath.row];
//    if (!object.isRead) {
//        [_messageModel setMessageIsReadWithBlock:object.kiiObject.objectURI CompleteBlock:^() {
//        
//        }];
//    }
//    if ([object.type isEqualToString:@"official"]) {
//        MessageCenterSingleViewController *singleView = [MessageCenterSingleViewController new];
//        singleView.messageObject = object;
//        [self.navigationController pushViewController:singleView animated:YES];
//    } else {
//        NSURL *objectLink = [NSURL URLWithString:object.link];
//        if ([objectLink.scheme isEqualToString:@"facenews"]) {
//            id mainType = objectLink.host;
//            if (isNotNullValue(mainType) && [mainType isEqualToString:@"discussion"]) {
//                DiscussionSingleViewController *controller = [[DiscussionSingleViewController alloc] initWithDiscussionId:objectLink.lastPathComponent];
//                NSLog(@"# PATH Components: %@",objectLink.pathComponents);
//                controller.isCelebrityDiscussion = [objectLink.pathComponents containsObject:@"celebrity"] ? YES : NO;
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//        }
//        
//    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == _messageList.count - 1 && _hasMoreMessage && _messageList.count >= 5 && !_isLoadingMoreMessage) {
//        _isLoadingMoreMessage = YES;
//        
//        dispatch_async(dispatch_get_main_queue(),^{
//            NSRange range = NSMakeRange(0, 0);
//            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
//            [_messageTableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
//        });
//        [self loadMoreMessage];
//    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_isLoadingMoreMessage) {
        return 30.0f;
    }
    else {
        return 0.1f;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_isLoadingMoreMessage) {
        if (_activityIndicator) {
            [_activityIndicator stopAnimating];
            _activityIndicator = nil;
        }
        
        if (!_activityIndicator) {
            _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        [_activityIndicator startAnimating];
        return _activityIndicator;
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}



#pragma mark - messageModel delegate
- (void) noNetworkAlertRefreshButtonPressed {
//    if (_isLoadingMoreMessage) {
//        _loadingStartIndex -= kTableViewLoadMoreLimitLength;
//        [self loadMoreMessage];
//    }
//    else {
//        [self firstLoadMessage];
//    }
}

- (void) noNetworkAlertCancelButtonPressed {
    if (_isLoadingMoreMessage) {
        _isLoadingMoreMessage = NO;
        _loadingStartIndex -= kTableViewLoadMoreLimitLength;
        [_activityIndicator stopAnimating];
    }
}

// No use
- (void) failToGetMessage {
    [self.hud hide:YES];
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"讀取發生錯誤..." delayToHide:1];
    
    if (_isLoadingMoreMessage) {
        _isLoadingMoreMessage = NO;
        [_activityIndicator stopAnimating];
        [_messageTableView reloadData];
    }
}

- (void) didGetMessageInBackground:(NSArray *)messageArray {
//    if ([messageArray isNotEmpty]) {
//        NSMutableArray *newMessages = messageArray.mutableCopy;
//        for (MessageObject *messageObject in messageArray) {
//            for (MessageObject *messageInMessageList in _messageList) {
//                if ([messageObject.messagePFObject.objectId isEqualToString:messageInMessageList.messagePFObject.objectId]) {
//                    [newMessages removeObject:messageObject];
//                }
//            }
//        }
//        
//        [_messageList insertObjects:newMessages
//                          atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newMessages.count)]];
//        [_messageTableView reloadData];
//    }
}
@end
