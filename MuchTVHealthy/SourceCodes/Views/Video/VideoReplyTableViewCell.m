//
//  VideoReplyTableViewCell.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/21.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "VideoReplyTableViewCell.h"
#import "YoutubeVideoPlayerView.h"

@interface VideoReplyTableViewCell()
@property (nonatomic, strong) YoutubeVideoPlayerView            *playerView;
@property (nonatomic, strong) UITableView                       *videoAndReplyTableView;
@property (nonatomic, strong) UIImageView                       *avatarImageView;
@property (nonatomic, strong) UIButton                          *replyButton;
@property (nonatomic, strong) UILabel                           *authorLabel;
@property (nonatomic, strong) UILabel                           *contentLabel;
@property (nonatomic, strong) UIImageView                       *timeIcon;
@property (nonatomic, strong) UILabel                           *timeLabel;
@property (nonatomic, strong) UIButton                          *shareButton;
@property (nonatomic, strong) UILabel                           *shareLabel;
@property (nonatomic, strong) UIImageView                       *shareButtonImageView;
@property (nonatomic, strong) UIImageView                       *loadMoreImageView;
@end

@implementation VideoReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentString:(NSString *)commentString {
    _commentString = commentString;
    [self initAvatarImageView];
    [self initAuthorLabel];
    [self initContentLabel];
    [self initTimeIcon];
    [self initTimeLabel];
}

- (void) setVideoDataObject:(VideoDataObject *)videoDataObject {
    _videoDataObject = videoDataObject;
    [self initVideoView];
}

- (void) initShareButtonLayout {
    [self initShareButton];
    [self initShareLabel];
    [self initShareButtonImageView];
}

- (void) initVideoView {
    if (!_playerView) {
        _playerView = [[YoutubeVideoPlayerView alloc] initForAutolayout];
        _playerView.clipsToBounds = YES;
        _playerView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_playerView];
        
        NSMutableArray *videoPlayerViewConstaint = @[].mutableCopy;
        
        [videoPlayerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_playerView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:kkGlobalDefaultPadding]];
        [videoPlayerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_playerView
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:kkGlobalDefaultPadding]];
        [videoPlayerViewConstaint addObject: [NSLayoutConstraint constraintWithItem:_playerView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:-kkGlobalDefaultPadding]];
        [videoPlayerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_playerView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-kkGlobalDefaultPadding]];
        [self.contentView addConstraints:videoPlayerViewConstaint];
        
        _playerView.youtubeID = [@"https://www.youtube.com/watch?v=c3iL8u0Dz0A" getYoutubeVieoCode];
    }

}

- (void)initShareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _shareButton.backgroundColor   = [UIColor colorWithHexString:kDiscussionSinglePageReplyButtonBackgroundColorHexString];
        _shareButton.layer.borderWidth = 1.0f;
        _shareButton.layer.borderColor = [UIColor colorWithHexString:kDiscussionSinglePageReplyButtonBorderColorHexString].CGColor;
        [_shareButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_shareButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_shareButton];
        
        NSMutableArray *replyButtonConstraint = [[NSMutableArray alloc] init];
        
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:0.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:0.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:replyButtonConstraint];
    }
}

- (void) initShareButtonImageView {
    if (!_shareButtonImageView) {
        _shareButtonImageView = [[UIImageView alloc] initForAutolayout];
        _shareButtonImageView.image = [UIImage imageNamed:@"icon_share"];
        [_shareButton addSubview:_shareButtonImageView];
        
        NSMutableArray *replyButtonConstraint = [[NSMutableArray alloc] init];
        
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareButtonImageView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_shareLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:-10.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareButtonImageView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f constant:30.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareButtonImageView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f constant:30.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareButtonImageView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_shareButton
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:replyButtonConstraint];
        
    }
}

- (void) initShareLabel {
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] initForAutolayout];
        _shareLabel.textColor = [UIColor colorWithHexString:kDiscussionSinglePageReplyButtonTitleColorHexString];
        _shareLabel.text = @"分 享";
        [_shareButton addSubview:_shareLabel];
        
        NSMutableArray *replyButtonConstraint = [[NSMutableArray alloc] init];
        
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_shareButton
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0f constant:0.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_shareButton
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:0.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareLabel
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f constant:50.0f]];
        [replyButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_shareLabel
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_shareButton
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:replyButtonConstraint];
    }
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
        [_replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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

- (void) initTimeIcon {
    if (!_timeIcon) {
        _timeIcon = [[UIImageView alloc] initForAutolayout];
        _timeIcon.image = [UIImage imageNamed:@"icon_time"];
        [self.contentView addSubview:_timeIcon];
        
        NSMutableArray *timeIconConstraint = [[NSMutableArray alloc] init];
        
        [timeIconConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeIcon
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_avatarImageView
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f constant:kDiscussionTimeIconLeftPadding]];
        [timeIconConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeIcon
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_contentLabel
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:5.0f]];
        [timeIconConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeIcon
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:15.0f]];
        [timeIconConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeIcon
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:15.0f]];
        
        [self addConstraints:timeIconConstraint];
        
    }
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
                                                                           toItem:_timeIcon
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:kDiscussionTimeLeftPadding]];
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

- (void) initLoadMoreImageView {
    if (!_loadMoreImageView) {
        _loadMoreImageView = [[UIImageView alloc] initForAutolayout];
        _loadMoreImageView.backgroundColor = [UIColor clearColor];
        [_loadMoreImageView setImage:[UIImage imageNamed:@"icon_more"]];
        [self.contentView addSubview:_loadMoreImageView];
        
        NSMutableArray *loadMoreConstraint = [[NSMutableArray alloc] init];
        
        [loadMoreConstraint addObject:[NSLayoutConstraint constraintWithItem:_loadMoreImageView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0f constant:0.0f]];
        [loadMoreConstraint addObject:[NSLayoutConstraint constraintWithItem:_loadMoreImageView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0f constant:0.0f]];
        [loadMoreConstraint addObject:[NSLayoutConstraint constraintWithItem:_loadMoreImageView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:20.0f]];
        [loadMoreConstraint addObject:[NSLayoutConstraint constraintWithItem:_loadMoreImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:15.0f]];
        [self addConstraints:loadMoreConstraint];
    }
}

#pragma mark - button clicked
- (void) replyButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goPostReply)]) {
        [self.delegate goPostReply];
    }
}

- (void) shareButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goShare)]) {
        [self.delegate goShare];
    }
}

@end
