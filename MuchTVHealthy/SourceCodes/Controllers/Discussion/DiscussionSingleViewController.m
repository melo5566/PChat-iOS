//
//  DiscussionSingleViewController.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DiscussionSingleViewController.h"
#import "DiscussionAuthorAndContentTableViewCell.h"
#import "DiscussionCommentTableViewCell.h"
#import "PostNewDiscussionReplyViewController.h"


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
@property (nonatomic) NSUInteger                                numberOfImage;
@end

@implementation DiscussionSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    self.navigationItem.title = @"Title";
    
    _totalCommentDataArray = @[].mutableCopy;
    for (int i = 0; i < 6; i ++) {
        [_totalCommentDataArray addObject:@"abc"];
    }
    for (int i = 0; i < 10; i ++) {
        [_totalCommentDataArray addObject:@"abcdefghi"];
    }
    _content = @"ContentContentContentContentContentContentContentContentCont";
    _numberOfImage = 5;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self firstLoadReply];
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
- (void) firstLoadReply {
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
    return kDiscussionReplyTopAndBottomPadding + kDiscussionReplyContentPadding * 2 + kDiscussionReplyAuthorNameFontSize + 0.5f + replyContentHeight + kDiscussionReplyTimeFontSize + 0.5f;
}

- (CGFloat) heightOfTotalReplyCell {
    CGFloat heightOfReplyCell = kDiscussionReplyButtonTopPadding + (kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH) + kDiscussionReplyButtonBottomPadding;
    if ([_commentDataArray isNotEmpty]) {
        for (NSString *content in _commentDataArray) {
            heightOfReplyCell += ([self heightOfReplyCellWithReplyContent:content]);
        }
        
        heightOfReplyCell += _hasMoreCommentData ? kLoadMoreCellHeight : 0;
    }
    return heightOfReplyCell;
}

- (CGFloat) heightForText:(NSString *)text {
    CGFloat heightForTextView = [text sizeOfStringWithFont:[UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionContentFontSize] andMaxLength:kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionContentLeftPadding*2 ].height;
    return heightForTextView;
}

- (CGFloat) heightOfAuthorAndContentCell {
    if (_numberOfImage != 0) {
        return kDiscussionCardTopPadding + kDiscussionAvatarTopPadding + (kScreenWidth*kDiscussionAvatarHeightInIphone6/IPHONE_6_SCREEN_WIDTH) + kDiscussionContentTopPadding + [self heightForText:_content] + kDiscussionImageSlideViewTopPadding + kImageSlideViewHeight + kScreenHeight/10;
    } else {
        return kDiscussionCardTopPadding + kDiscussionAvatarTopPadding + (kScreenWidth*kDiscussionAvatarHeightInIphone6/IPHONE_6_SCREEN_WIDTH) + kDiscussionContentTopPadding + [self heightForText:_content] + kScreenHeight/10 + 10;
    }
    
}


#pragma mark - tableView datasource and delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 2;
    } else {
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    else {
        return 10 + kLogoWidth * 15.0f / 48.0f + 15;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self heightOfAuthorAndContentCell];
        } else {
            return [self heightOfTotalReplyCell];
        }
    } else {
        return kScreenHeight*80/630;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view         = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _fanzytvLogo         = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_fanzytv"]];
        _fanzytvLogo.frame   = CGRectMake((kScreenWidth - kLogoWidth) / 2, 10, kLogoWidth, kLogoWidth * 15.0f / 48.0f);
        [view addSubview:_fanzytvLogo];
        return view;
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
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
            cell.content        = _content;
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
- (void) shareButtonClicked {
    NSLog(@"shareButtonClicked");
}

- (void) goPostReply {
    PostNewDiscussionReplyViewController *postReplyViewController = [PostNewDiscussionReplyViewController new];
    [self.navigationController pushViewController:postReplyViewController animated:YES];
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
