//
//  DiscussionSingleViewController.m
//  493_Project
//
//  Created by Peter on 2015/11/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DiscussionSingleViewController.h"
#import "DiscussionAuthorAndContentTableViewCell.h"
#import "DiscussionCommentTableViewCell.h"
#import "PostNewDiscussionReplyViewController.h"
#import "DiscussionModel.h"
#import "CustomizedAlertView.h"
#import "PersonalSettingViewController.h"


#define kLogoWidth kScreenWidth * 211.0f / IPHONE_6_SCREEN_WIDTH
#define kImageSlideViewHeight (kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionImageSlideViewInsideImagePadding) * (3.0f/4.0f)

@interface DiscussionSingleViewController () <UITableViewDataSource, UITableViewDelegate, DiscussionCommentTableViewCellDelegate, DiscussionAuthorAndContentTableViewCellDelegate>
@property (nonatomic, strong) UITableView                       *discussionTableView;
@property (nonatomic, strong) UIImageView                       *fanzytvLogo;
@property (nonatomic, strong) NSMutableArray                    *commentDataArray;
@property (nonatomic, strong) NSMutableArray                    *totalCommentDataArray;
@property (nonatomic, strong) NSString                          *content;
@property (nonatomic) BOOL                                      hasMoreCommentData;
@property (nonatomic) NSUInteger                                commentStartIndex;
@property (nonatomic) BOOL                                      isFirstLoad;
@property (nonatomic, strong) DiscussionModel                   *discussionModel;
@property (nonatomic, strong) CustomizedAlertView               *loginAlertView;
@end

@implementation DiscussionSingleViewController

- (void)setDisscusionObject:(DiscussionObject *)discussionObject {
    _discussionObject = discussionObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    self.navigationItem.title = _discussionObject.title;
    _isFirstLoad = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_discussionModel)
        _discussionModel = [DiscussionModel new];
    _totalCommentDataArray = @[].mutableCopy;
    [self loadAllReply];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (void)initDiscussionTableView {
    if (!_discussionTableView) {
        _discussionTableView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_discussionTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _discussionTableView.delegate        = self;
        _discussionTableView.dataSource      = self;
        _discussionTableView.backgroundColor = [UIColor clearColor];
        _discussionTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_discussionTableView];
        
        NSMutableArray *discussionTableViewConstraint = [[NSMutableArray alloc] init];
        
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionTableView
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionTableView
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f constant:5.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionTableView
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionTableView
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:discussionTableViewConstraint];
    }
    
    [_discussionTableView reloadData];
    
}

#pragma mark - method
- (void) loadAllReply {
    [_discussionModel loadReplyWithBlock:_discussionObject.objectID completeBlock:^(NSArray *replyArray) {
        [_totalCommentDataArray addObjectsFromArray:replyArray];
        [self firstLoadReply];
    }];
}

- (void) firstLoadReply {
    _isFirstLoad = NO;
    _commentDataArray = @[].mutableCopy;
    if (_totalCommentDataArray.count > 3) {
        _hasMoreCommentData = YES;
        [_commentDataArray addObjectsFromArray:[_totalCommentDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_commentStartIndex, 3)]]];
        _commentStartIndex = 3;
    } else {
        _hasMoreCommentData = NO;
        [_commentDataArray addObjectsFromArray:_totalCommentDataArray];
    }
    [self initDiscussionTableView];
}

- (void) loadMoreReply {
    NSUInteger length;
    NSUInteger commentLast = _totalCommentDataArray.count - _commentDataArray.count;
    if (commentLast >= 10) {
        length = 10;
        _hasMoreCommentData = commentLast == 10 ? NO : YES;
    }
    else {
        length = commentLast;
        _hasMoreCommentData = NO;
    }
    
    [_commentDataArray addObjectsFromArray:[_totalCommentDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_commentStartIndex, length)]]];
    _commentStartIndex += length;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            [_discussionTableView reloadData];
        }];
    });
}

#pragma mark - height for row
- (CGFloat) heightOfReplyCellWithReplyContent:(NSString *)content {
    CGFloat replyContentHeight = [content sizeOfStringWithFont:[UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionReplyContentFontSize] andMaxLength:kScreenWidth - kDiscussionCardLeftAndRightPadding - kDiscussionReplyLeftAndRightPadding * 2 - (kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH)].height;
    return kDiscussionReplyTopAndBottomPadding + kDiscussionReplyContentPadding * 2 + kDiscussionReplyAuthorNameFontSize + 0.5f + replyContentHeight + kDiscussionReplyTimeFontSize + kDiscussionTimeBottomPadding + 0.5f;
}

- (CGFloat) heightOfTotalReplyCell {
    CGFloat heightOfReplyCell = kDiscussionReplyButtonTopPadding * 2 + (kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH);
    if ([_commentDataArray isNotEmpty]) {
        for (ReplyObject *replyObject in _commentDataArray) {
            NSString *content = replyObject.content;
            heightOfReplyCell += ([self heightOfReplyCellWithReplyContent:content]);
        }
        
        heightOfReplyCell += _hasMoreCommentData ? kLoadMoreCellHeight: 0;
    }
    return heightOfReplyCell;
}

- (CGFloat) heightForText:(NSString *)text {
    CGFloat heightForTextView = [text sizeOfStringWithFont:[UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionContentFontSize] andMaxLength:kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionContentLeftPadding*2 ].height;
    return heightForTextView;
}

- (CGFloat) heightOfAuthorAndContentCell {
    if (_discussionObject.imageArray.count != 0) {
        return kDiscussionCardTopPadding + kDiscussionAvatarTopPadding + (kScreenWidth*kDiscussionAvatarHeightInIphone6/IPHONE_6_SCREEN_WIDTH) + kDiscussionContentTopPadding + [self heightForText:_discussionObject.content] + kDiscussionImageSlideViewTopPadding + kImageSlideViewHeight
        + kScreenHeight/40;
    } else {
        return kDiscussionCardTopPadding + kDiscussionAvatarTopPadding + (kScreenWidth*kDiscussionAvatarHeightInIphone6/IPHONE_6_SCREEN_WIDTH) + kDiscussionContentTopPadding + [self heightForText:_discussionObject.content] + kScreenHeight/10 + 10;
    }
}


#pragma mark - tableView datasource and delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self heightOfAuthorAndContentCell];
    } else {
        return [self heightOfTotalReplyCell];
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellID = @"DiscussionAuthorAndContentTableViewCell";
            DiscussionAuthorAndContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[DiscussionAuthorAndContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate       = self;
            cell.contentHeight  = [self heightForText:_content];
            cell.discussionObject = _discussionObject;
            return cell;
            
        } else {
            static NSString *cellID = @"DiscussionCommentTableViewCell";
            DiscussionCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[DiscussionCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.delegate           = self;
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
            cell.hasMoreCommentData =  _hasMoreCommentData ? YES : NO;
            cell.commentDataArray = @[].mutableCopy;
            cell.commentDataArray = _commentDataArray;
            return cell;
        }
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Author and Content delegate
- (void) goPostReply {
    if ([PFUser currentUser]) {
        PostNewDiscussionReplyViewController *postReplyViewController = [PostNewDiscussionReplyViewController new];
        postReplyViewController.discussionObject = _discussionObject;
        [self.navigationController pushViewController:postReplyViewController animated:YES];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
