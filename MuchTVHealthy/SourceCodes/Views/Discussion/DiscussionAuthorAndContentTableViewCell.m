//
//  DiscussionAuthorAndContentTableViewCell.m
//  493_Project
//
//  Created by Peter on 2015/11/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DiscussionAuthorAndContentTableViewCell.h"
#import "ImageSlideView.h"
#import <Parse/Parse.h>

#define kImageSlideViewHeight (kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionImageSlideViewInsideImagePadding) * (3.0f/4.0f)

@interface DiscussionAuthorAndContentTableViewCell()
@property (nonatomic, strong) UIView                        *singleView;
@property (nonatomic, strong) UIImageView                   *avatarImageView;
@property (nonatomic, strong) UILabel                       *authorLabel;
@property (nonatomic, strong) UILabel                       *timeLabel;
@property (nonatomic, strong) UILabel                       *contentLabel;
@property (nonatomic, strong) ImageSlideView                *imageSlideView;
@property (nonatomic, strong) UIImageView                   *timeIcon;
@end

@implementation DiscussionAuthorAndContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setDiscussionObject:(DiscussionObject *)discussionObject {
    _discussionObject = discussionObject;
    [self initLayout];
}

- (void)initLayout {
    [self initSingleView];
    [self initAvatarImageView];
    [self initAuthorLabel];
    [self initTimeIcon];
    [self initTimeLabel];
    [self initContentLabel];
    if (_discussionObject.imageArray.count > 0)
        [self initImageSlideView];
}

- (void)initSingleView {
    if (!_singleView) {
        _singleView                     = [[UIView alloc] initForAutolayout];
        _singleView.backgroundColor     = [UIColor clearColor];
        _singleView.layer.borderWidth   = 0.5f;
        _singleView.layer.borderColor   = [UIColor colorWithHexString:kListTableViewImageBorderColorHexString].CGColor;
        
        [self.contentView addSubview:_singleView];
        NSMutableArray *singleViewConstraint = @[].mutableCopy;
        
        [singleViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_singleView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:kDiscussionSingleViewLeftPadding]];
        [singleViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_singleView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:kDiscussionSingleViewTopPadding]];
        [singleViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_singleView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:-kDiscussionSingleViewRightPadding]];
        [singleViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_singleView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:singleViewConstraint];
        
    }
}

- (void)initAvatarImageView {
    if (!_avatarImageView) {
        _avatarImageView                    = [[UIImageView alloc] initForAutolayout];
        _avatarImageView.alpha              = 1.0f;
        _avatarImageView.layer.borderColor  = [UIColor whiteColor].CGColor;
        _avatarImageView.backgroundColor    = [UIColor clearColor];
        _avatarImageView.layer.cornerRadius = kScreenWidth*kDiscussionAvatarHeightInIphone6/IPHONE_6_SCREEN_WIDTH/2;
        _avatarImageView.contentMode        = UIViewContentModeScaleAspectFill;
        _avatarImageView.clipsToBounds      = YES;
        [_singleView addSubview:_avatarImageView];
        
        
        NSMutableArray *avatarConstraint = @[].mutableCopy;
        
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_singleView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:kDiscussionAvatarTopPadding]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_singleView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:10.0f]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:kScreenWidth*kDiscussionAvatarHeightInIphone6/IPHONE_6_SCREEN_WIDTH]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:avatarConstraint];
    }
    __block __typeof (UIImageView *) imageView = _avatarImageView;
    [_avatarImageView setImageWithURL:[NSURL URLWithString:_discussionObject.authorPhoto]
           withPlaceholderImage:[UIImage imageNamed:kImageNamePresetAvatar]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                          if (image) {
                              imageView.alpha = 0;
                              [UIView animateWithDuration:0.3 animations:^(){
                                  imageView.alpha = 1;
                              }];
                          }
                          else {
                              [imageView setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                          }
                      }
    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void) initAuthorLabel {
    if (!_authorLabel) {
        _authorLabel                    = [[UILabel alloc] initForAutolayout];
        _authorLabel.backgroundColor    = [UIColor clearColor];
        _authorLabel.textColor          = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _authorLabel.font               = [UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionAuthorNameFontSize];
        [_singleView addSubview:_authorLabel];
        NSMutableArray *authorLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [authorLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:kDiscussionAuthorNameLeftPadding]];
        [authorLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0f constant:0.0f]];
        [authorLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-kDiscussionAuthorNameLeftPadding]];
        [authorLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_authorLabel
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kDiscussionAuthorNameFontSize + 0.5f]];
        
        [self addConstraints:authorLabelViewConstraint];
    }
    _authorLabel.text = _discussionObject.authorName;
}

- (void) initTimeIcon {
    if (!_timeIcon) {
        _timeIcon = [[UIImageView alloc] initForAutolayout];
        _timeIcon.image = [UIImage imageNamed:@"icon_time"];
        [_singleView addSubview:_timeIcon];
        
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
                                                                      toItem:_avatarImageView
                                                                   attribute:NSLayoutAttributeCenterY
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
        _timeLabel                  = [[UILabel alloc] initForAutolayout];
        _timeLabel.backgroundColor  = [UIColor clearColor];
        _timeLabel.textColor        = [UIColor colorWithHexString:kListTableViewTimeColorHexString];
        _timeLabel.font             = [UIFont fontWithName:@".STHeitiUIGB18030PUA-UltraLight" size:kDiscussionTimeFontSize];
        [_singleView addSubview:_timeLabel];
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
                                                                           toItem:_avatarImageView
                                                                        attribute:NSLayoutAttributeCenterY
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
                                                                       multiplier:1.0f constant:kDiscussionTimeFontSize + 0.5f]];
        
        [self addConstraints:timeLabelViewConstraint];
    }
    
    _timeLabel.text = _discussionObject.createTime;
}


- (void) initContentLabel {
    if (!_contentLabel) {
        _contentLabel                   = [[UILabel alloc] initForAutolayout];
        _contentLabel.backgroundColor   = [UIColor clearColor];
        _contentLabel.lineBreakMode     = UILineBreakModeWordWrap;
        _contentLabel.textColor         = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _contentLabel.font              = [UIFont fontWithName:@"STHeitiTC-Light" size:kDiscussionContentFontSize];
        [self addSubview:_contentLabel];
        NSMutableArray *contentLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [contentLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_singleView
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0f constant:kDiscussionContentLeftPadding]];
        [contentLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_avatarImageView
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0f constant:kDiscussionContentTopPadding]];
        [contentLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_singleView
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0f constant:-kDiscussionContentLeftPadding]];
        NSLayoutConstraint *contentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_contentLabel
                                                                                        attribute:NSLayoutAttributeHeight
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:nil
                                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                                       multiplier:1.0f constant:0.1f];
        contentLabelHeightConstraint.priority = 250;
        [contentLabelViewConstraint addObject:contentLabelHeightConstraint];
        
        [self addConstraints:contentLabelViewConstraint];
    }
    
    _contentLabel.text          = _discussionObject.content;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    [_contentLabel sizeThatFits:CGSizeMake(kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionContentLeftPadding*2, MAXFLOAT)];
}

- (void) initImageSlideView {
    if (_imageSlideView) {
        [_imageSlideView removeFromSuperview];
        _imageSlideView = nil;
    }
    _imageSlideView = [[ImageSlideView alloc] initWithImageUrlArray:_discussionObject.imageArray];
    _imageSlideView.backgroundColor = [UIColor clearColor];
    [_singleView insertSubview:_imageSlideView atIndex:99];
    
    NSMutableArray *scrollViewConstaint = @[].mutableCopy;
    
    [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageSlideView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_singleView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:0.0f]];
    [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageSlideView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_contentLabel
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:kDiscussionImageSlideViewTopPadding]];
    [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageSlideView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_singleView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:0.0f]];
    [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageSlideView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f constant:kImageSlideViewHeight]];
    [self addConstraints:scrollViewConstaint];
    [self layoutIfNeeded];
    [_imageSlideView initLayout];
}

@end
