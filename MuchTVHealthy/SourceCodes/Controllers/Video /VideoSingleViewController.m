//
//  VideoSingleViewController.m
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/8/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "VideoSingleViewController.h"
#import "YoutubeVideoPlayerView.h"
#import "VideoReplyTableViewCell.h"
#import "PostNewDiscussionReplyViewController.h"
//#import "InformationCardTableViewCell.h"

#define kLogoWidth kScreenWidth * 211.0f / IPHONE_6_SCREEN_WIDTH

@interface VideoSingleViewController ()<UITableViewDataSource, UITableViewDelegate, VideoReplyTableViewCellDelegate>
@property (nonatomic, strong) UITableView                               *videoTableView;
@property (nonatomic, strong) NSString                                  *pictureurl;
@property (nonatomic, strong) YoutubeVideoPlayerView                    *playerView;
@property (nonatomic, strong) UIImageView                               *mainImageView;
@property (nonatomic, strong) UIButton                                  *shareButton;
@property (nonatomic, strong) UIButton                                  *replyaButton;
@property (nonatomic, strong) NSAttributedString                        *attachmentString;
@property (nonatomic, strong) UIImageView                               *fanzytvLogo;
@property (nonatomic, strong) NSMutableArray                            *commentDataArray;
@property (nonatomic, strong) NSMutableArray                            *totalCommentDataArray;
@property (nonatomic) BOOL                                              hasMoreCommentData;
@property (nonatomic) NSUInteger                                        commentStartIndex;
@property (nonatomic) BOOL                                              isFirstLoad;
@end

@implementation VideoSingleViewController
static CGFloat const widthPadding      = 2*kkGlobalDefaultPadding+3;


- (void)setVideoDataObject:(VideoDataObject *)videoDataObject {
    _videoDataObject = videoDataObject;
 
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    self.title = _videoDataObject.title;
    self.view.backgroundColor = [UIColor colorWithHexString:kVideoBackGroundColorHexString];
    _totalCommentDataArray = @[].mutableCopy;
    for (int i = 0; i < 15; i ++) {
        [_totalCommentDataArray addObject:@"abcabcabcabcabcabcabcabcabcabcabcabcabcabca"];
    }
    _isFirstLoad = YES;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _commentStartIndex = 0;
    if (_isFirstLoad) {
        [self firstLoadReply];
        _isFirstLoad = NO;
    }
    
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initVideoTableView{
    if (!_videoTableView) {
        _videoTableView             = [[UITableView alloc]initForAutolayout];
        _videoTableView.delegate    = self;
        _videoTableView.dataSource  = self;
        [_videoTableView.layer setShadowColor:[UIColor blackColor].CGColor];
        [_videoTableView.layer setShadowOpacity:0.5];
        [_videoTableView.layer setShadowOffset:CGSizeMake(0, 0.5)];
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_videoTableView setLayoutMargins:UIEdgeInsetsZero];
        _videoTableView.separatorColor = [UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
        _videoTableView.showsVerticalScrollIndicator = YES;
        _videoTableView.clipsToBounds = NO;
        _videoTableView.layer.masksToBounds = NO;

        [self.view addSubview:_videoTableView];
        NSMutableArray *Constraint = [[NSMutableArray alloc] init];
        
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_videoTableView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0f constant:kkGlobalDefaultPadding]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_videoTableView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0f constant:widthPadding]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_videoTableView
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0f constant:-widthPadding]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_videoTableView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0f constant:-kkGlobalDefaultPadding]];
        
        [self.view addConstraints:Constraint];
    }
    [_videoTableView reloadData];
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
    [self initVideoTableView];
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
            [_videoTableView reloadData];
        }];
    });
}


#pragma mark - height for row
- (CGFloat) heightOfReplyCellWithReplyContent:(NSString *)content {
    CGFloat replyContentHeight = [content sizeOfStringWithFont:[UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionContentFontSize] andMaxLength:kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionContentLeftPadding*2 - widthPadding * 2 - (kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH)].height;
    
    return kDiscussionReplyTopAndBottomPadding + kDiscussionReplyContentPadding * 2 + kDiscussionReplyAuthorNameFontSize + 0.5f + replyContentHeight + kDiscussionReplyTimeFontSize + kDiscussionTimeBottomPadding + 0.5f;
}


#pragma mark tableview delegates
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        if (_hasMoreCommentData) {
            return _commentDataArray.count + 4;
        } else {
            return _commentDataArray.count + 3;
        }
    } else {
        return 0;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            return 250;
        else if (indexPath.row == 1)
            return 50;
        else if (indexPath.row == 2)
            return kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH + 2 * kDiscussionReplyButtonTopPadding;
        else if (indexPath.row == _commentDataArray.count + 3)
            return kLoadMoreCellHeight;
        else {
            return [self heightOfReplyCellWithReplyContent:_commentDataArray[indexPath.row - 3]];
        }
    } else {
        return kScreenHeight * 80 / 630;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellID = @"VideoReplyTableViewCell";
            VideoReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[VideoReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.delegate = self;
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.videoDataObject = _videoDataObject;
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *cellID = @"ShareButtonTableViewCell";
            VideoReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[VideoReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.delegate = self;
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell initShareButtonLayout];
            return cell;
        } else if (indexPath.row == 2) {
            static NSString *cellID = @"ReplyButtonTableViewCell";
            VideoReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[VideoReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.delegate = self;
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell initReplyButtonLayout];
            return cell;
        } else if (indexPath.row == _commentDataArray.count + 3) {
            static NSString *cellID = @"VideoLoadMoreButton";
            VideoReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[VideoReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.contentMode = UIViewContentModeCenter;
            [cell initLoadMoreImageView];
            return cell;
        } else {
            static NSString *cellID = @"ReplyTableViewCell";
            VideoReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[VideoReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.delegate = self;
            [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setLayoutMargins:UIEdgeInsetsZero];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.commentString = _commentDataArray[indexPath.row - 3];
            return cell;
        }
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.selectionStyle   = UITableViewCellSelectionStyleNone;
        cell.backgroundColor  = [UIColor clearColor];
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (!_hasMoreCommentData) {
            UIView *bottomLine             = [UIView new];
            bottomLine.backgroundColor     = [UIColor lightGrayColor];
            return bottomLine;
        } else {
            UIView *bottomLine             = [UIView new];
            bottomLine.backgroundColor     = [UIColor clearColor];
            return bottomLine;
        }
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 1.0;
    } else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view         = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#ecf8f7"];
        _fanzytvLogo         = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_fanzytv"]];
        _fanzytvLogo.frame   = CGRectMake((kScreenWidth - 30 - kLogoWidth) / 2, 10, kLogoWidth, kLogoWidth * 15.0f / 48.0f);
        [view addSubview:_fanzytvLogo];
        return view;
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    } else {
        return 10 + kLogoWidth * 15.0f / 48.0f + 15;
    }
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _commentDataArray.count + 3) {
        [self loadMoreReply];
    }
}

#pragma mark - action
- (void) goPostReply {
    PostNewDiscussionReplyViewController *controller = [PostNewDiscussionReplyViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) goShare{
    NSLog(@"share");
}
@end
