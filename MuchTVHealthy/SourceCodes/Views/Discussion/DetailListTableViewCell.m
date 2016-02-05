//
//  DetailListTableViewCell.m
//  493_Project
//
//  Created by Wu Peter on 2015/12/2.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DetailListTableViewCell.h"

@interface DetailListTableViewCell()
@property (nonatomic, strong) UIImageView    *avatarImageView;
@property (nonatomic, strong) UILabel        *senderLabel;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) UILabel        *timeLabel;
@property (nonatomic, strong) UIImageView    *timeIcon;
@end

@implementation DetailListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDiscussionObject:(DiscussionObject *)discussionObject {
    _discussionObject = discussionObject;
    [self initAvatarImageView];
    [self initSenderLabel];
    [self initTimeIcon];
    [self initTimeLabel];
    [self initTitleLabel];
}

- (void) initAvatarImageView {
    if (!_avatarImageView) {
        _avatarImageView                     = [[UIImageView alloc] initForAutolayout];
        _avatarImageView.layer.borderWidth   = 0.5f;
        _avatarImageView.layer.borderColor   = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.cornerRadius  = 10;
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        
        NSMutableArray *avatarImageViewConstraint = [[NSMutableArray alloc] init];
        
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:15.0f]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:10.0f]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:-10.0]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeHeight
                                                                         multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:avatarImageViewConstraint];
        
    }
    __block __typeof (UIImageView *) avatarImageView = _avatarImageView;
    [_avatarImageView setImageWithURL:[NSURL URLWithString:_discussionObject.authorPhoto]
                 withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                if (image) {
                                }
                                else {
                                    [avatarImageView setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                                }
                            }
          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void) initSenderLabel {
    if (!_senderLabel) {
        _senderLabel                = [[UILabel alloc] initForAutolayout];
        _senderLabel.textColor      = [UIColor colorWithHexString:kColorHexStringLightGray];
        _senderLabel.font           = [UIFont fontWithName:@"Arial" size:15.0];
        [self.contentView addSubview:_senderLabel];
        NSMutableArray *senderLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [senderLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_senderLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:15.0f]];
        [senderLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_senderLabel
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:0.0f]];
        [senderLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_senderLabel
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-15.0f]];
        [senderLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_senderLabel
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:15.5f]];
        
        [self addConstraints:senderLabelViewConstraint];
        
    }
    _senderLabel.text = _discussionObject.authorName;
}

- (void) initTitleLabel {
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc] initForAutolayout];
        _titleLabel.lineBreakMode   = UILineBreakModeWordWrap;
        _titleLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines   = 2;
        _titleLabel.textColor       = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _titleLabel.font            = [UIFont fontWithName:@"Arial" size:18.0];
        [self.contentView addSubview:_titleLabel];
        NSMutableArray *titleLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_avatarImageView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:15.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_senderLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:10.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-21.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_timeLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:-10.0f]];
        
        [self addConstraints:titleLabelViewConstraint];
    }
    _titleLabel.text = _discussionObject.title;
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
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_avatarImageView
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:0.0f]];
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
        [self.contentView addSubview:_timeLabel];
        NSMutableArray *timeLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_timeIcon
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:kDiscussionTimeLeftPadding]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_avatarImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0.0f]];
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


@end
