//
//  DiscussionCommentTableViewCell.m
//  FaceNews
//
//  Created by Peter on 2015/7/17.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DiscussionCommentTableViewCell.h"
#import <KiiSDK/Kii.h>
//#import "DiscussionObject.h"

@interface DiscussionCommentTableViewCell() <UITableViewDataSource, UITableViewDelegate, DiscussionCommentTableViewCellDelegate>
//@property (nonatomic, strong) DiscussionCommentView     *discussionCommentView;
@property (nonatomic, strong) UITableView               *commentTableView;
@property (nonatomic, strong) UIImageView               *avatarImageView;
@property (nonatomic, strong) UIButton                  *replyButton;
@property (nonatomic, strong) UILabel                   *contentLabel;
@property (nonatomic, strong) UILabel                   *authorLabel;
@property (nonatomic, strong) UILabel                   *timeLabel;
@property (nonatomic, strong) UITextField               *commentTextField;
@property (nonatomic, strong) UITableView               *discussionCommentTableView;
@end

@implementation DiscussionCommentTableViewCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) setCommentDataArray:(NSMutableArray *)commentDataArray {
    _commentDataArray = commentDataArray;
    [self initCommentTableView];
}

- (void)setCommentString:(NSString *)commentString {
    _commentString = commentString;
    [self initAvatarImageView];
    [self initAuthorLabel];
    [self initContentLabel];
    [self initTimeLabel];
}

- (void) initCommentTableView {
    if (!_discussionCommentTableView) {
        _discussionCommentTableView                 = [[UITableView alloc] initForAutolayout];
        _discussionCommentTableView.dataSource      = self;
        _discussionCommentTableView.delegate        = self;
        _discussionCommentTableView.scrollEnabled   = NO;
        _discussionCommentTableView.backgroundColor = [UIColor whiteColor];
        _discussionCommentTableView.clipsToBounds   = NO;
        [_discussionCommentTableView setLayoutMargins:UIEdgeInsetsZero];
        [self.contentView addSubview:_discussionCommentTableView];
        NSMutableArray *discussionCommentViewConstraint = [[NSMutableArray alloc] init];
        
        [discussionCommentViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionCommentTableView
                                                                                attribute:NSLayoutAttributeLeft
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.contentView
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:1.0f constant:0.0f]];
        [discussionCommentViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionCommentTableView
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.contentView
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.0f constant:0.0f]];
        [discussionCommentViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionCommentTableView
                                                                                attribute:NSLayoutAttributeRight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.contentView
                                                                                attribute:NSLayoutAttributeRight
                                                                               multiplier:1.0f constant:0.0f]];
        [discussionCommentViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionCommentTableView
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.contentView
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:discussionCommentViewConstraint];
    }
    [_discussionCommentTableView reloadData];
}

- (void) initReplyButtonLayout {
    if (!_avatarImageView) {
        _avatarImageView                    = [[UIImageView alloc] initForAutolayout];
        _avatarImageView.layer.borderWidth  = 0.5f;
        _avatarImageView.layer.borderColor  = [UIColor colorWithHexString:kDiscussionSinglePageImageBorderColorHexString].CGColor;
        _avatarImageView.layer.cornerRadius = kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH/2;
        _avatarImageView.contentMode        = UIViewContentModeScaleAspectFill;
        _avatarImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:_avatarImageView];
        
        
        NSMutableArray *avatarImageViewConstraint = [[NSMutableArray alloc] init];
        
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:kDiscussionReplyLeftAndRightPadding]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:kDiscussionReplyButtonTopPadding]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH]];
        
        [self addConstraints:avatarImageViewConstraint];
    }
    
    if ([KiiUser currentUser]) {
        __block __typeof (UIImageView *) avatar = _avatarImageView;
        [_avatarImageView setImageWithURL:[NSURL URLWithString:[[KiiUser currentUser] getObjectForKey:@"avatar"]]
                     withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    if (!image) {
                                        [avatar setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                                    }
                                }
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    } else {
        [_avatarImageView setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
    }
    
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _replyButton.backgroundColor    = [UIColor colorWithHexString:kDiscussionSinglePageReplyButtonBackgroundColorHexString];
        _replyButton.layer.borderWidth  = 1.0f;
        _replyButton.layer.borderColor  = [UIColor colorWithR:0 G:125 B:125].CGColor;
        _replyButton.layer.cornerRadius = 10.0f;
        [_replyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_replyButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_replyButton setTitleColor:[UIColor colorWithR:0 G:125 B:125] forState:UIControlStateNormal];
        [_replyButton setTitle:@"我要回覆..." forState:UIControlStateNormal];
        [_replyButton addTarget:self action:@selector(goPostReply) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_replyButton];
        
        NSMutableArray *replyButtonConstraint = [[NSMutableArray alloc] init];
        
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_replyButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_avatarImageView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:kDiscussionReplyButtonLeftPadding]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_replyButton
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:kDiscussionReplyButtonTopPadding]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_replyButton
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:-kDiscussionReplyLeftAndRightPadding]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_replyButton
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f constant:kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH]];
        
        [self addConstraints:replyButtonConstraint];
    }
}


- (void) initAvatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initForAutolayout];
        _avatarImageView.layer.borderWidth   = 0.5f;
        _avatarImageView.layer.borderColor   = [UIColor colorWithHexString:kDiscussionSinglePageImageBorderColorHexString].CGColor;
        _avatarImageView.layer.cornerRadius  = kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH/2;
        _avatarImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_avatarImageView];
        
        NSMutableArray *avatarImageViewConstraint = [[NSMutableArray alloc] init];
        
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:kDiscussionReplyLeftAndRightPadding]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:kDiscussionReplyTopAndBottomPadding]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kScreenWidth * kDiscussionReplyAvatarHeightInIphone6 / IPHONE_6_SCREEN_WIDTH]];
        
        [self addConstraints:avatarImageViewConstraint];
    }
    __block __typeof (UIImageView *) avatar = _avatarImageView;
    [_avatarImageView setImageWithURL:[NSURL URLWithString:@""]
                 withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                if (!image) {
                                    [avatar setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                                }
                            }
          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
}

- (void) initAuthorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] initForAutolayout];
        _authorLabel.backgroundColor = [UIColor clearColor];
        _authorLabel.textColor = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _authorLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionReplyAuthorNameFontSize];
        [self.contentView addSubview:_authorLabel];
        NSMutableArray *authorLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [authorLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:kDiscussionReplyButtonLeftPadding]];
        [authorLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:kDiscussionReplyTopAndBottomPadding]];
        [authorLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-kDiscussionReplyLeftAndRightPadding]];
        [authorLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kDiscussionReplyAuthorNameFontSize + 0.5f]];
        
        [self addConstraints:authorLabelViewConstraint];
        
    }
    //    _authorLabel.text = _discussionReplyObject.authorName;
    _authorLabel.text          = @"Author";
    _authorLabel.numberOfLines = 1;
    _authorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void) initContentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initForAutolayout];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _contentLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionReplyContentFontSize];
        [self.contentView addSubview:_contentLabel];
        NSMutableArray *contentLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [contentLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_avatarImageView
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0f constant:kDiscussionReplyButtonLeftPadding]];
        [contentLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_authorLabel
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0f constant:kDiscussionReplyContentPadding]];
        [contentLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.contentView
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0f constant:-kDiscussionReplyLeftAndRightPadding]];
        NSLayoutConstraint *contentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_authorLabel
                                                                                        attribute:NSLayoutAttributeHeight
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:nil
                                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                                       multiplier:1.0f constant:kDiscussionReplyContentFontSize];
        contentLabelHeightConstraint.priority = 250;
        [contentLabelViewConstraint addObject:contentLabelHeightConstraint];
        
        [self addConstraints:contentLabelViewConstraint];
    }
    _contentLabel.text          = _commentString;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentLabel sizeThatFits:CGSizeMake(kScreenWidth - kDiscussionCardLeftAndRightPadding * 2 - kDiscussionReplyLeftAndRightPadding * 2 - kDiscussionReplyButtonLeftPadding, kDiscussionReplyAuthorNameFontSize)];
}


- (void) initTimeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initForAutolayout];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithHexString:kListTableViewTimeColorHexString];
        _timeLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionReplyTimeFontSize];
        [self.contentView addSubview:_timeLabel];
        NSMutableArray *timeLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_avatarImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:kDiscussionReplyButtonLeftPadding]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_contentLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:5.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:150.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kDiscussionReplyTimeFontSize + 0.5f]];
        
        [self addConstraints:timeLabelViewConstraint];
        
    }
    
    //    _timeLabel.text = _discussionReplyObject.createdAt;
    _timeLabel.text = @"2015/08/06";
    
}

#pragma mark - reply content height
- (CGFloat) heightOfReplyCellWithReplyContent:(NSString *)content {
    CGFloat replyContentHeight = [content sizeOfStringWithFont:[UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionContentFontSize] andMaxLength:kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionContentLeftPadding*2 ].height;
    
    return kDiscussionReplyTopAndBottomPadding + kDiscussionReplyContentPadding * 2 + kDiscussionReplyAuthorNameFontSize + 0.5f + replyContentHeight + kDiscussionReplyTimeFontSize + 0.5f;
}

#pragma mark - button clicked
- (void) replyButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goPostReply)]) {
        [self.delegate goPostReply];
    }
}


#pragma mark - tableView datasource and delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (_hasMoreCommentData) {
        return _commentDataArray.count + 2;
    } else {
        return _commentDataArray.count + 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 60;
    else if (indexPath.row == _commentDataArray.count + 1)
        return kLoadMoreButtonHeight;
    else {
        return [self heightOfReplyCellWithReplyContent:_commentDataArray[indexPath.row - 1]];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"DiscussionCommentTableViewCell";
    DiscussionCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[DiscussionCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row == 0) {
        [cell initReplyButtonLayout];
    } else if (indexPath.row == _commentDataArray.count + 1) {
        static NSString *cellID = @"DiscussionLoadMoreButton";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.contentMode = UIViewContentModeCenter;
        UIImageView *loadMoreImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kDiscussionCardLeftAndRightPadding * 2 - 20) / 2, 10, 20, 15)];
        loadMoreImage.backgroundColor = [UIColor clearColor];
        [loadMoreImage setImage:[UIImage imageNamed:@"icon_more"]];
        [cell.contentView addSubview:loadMoreImage];
        return cell;
    } else {
        cell.commentString = _commentDataArray[indexPath.row - 1];
    }
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _commentDataArray.count + 1) {
        if ([self.delegate respondsToSelector:@selector(loadMoreReply)]) {
            [self.delegate loadMoreReply];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
