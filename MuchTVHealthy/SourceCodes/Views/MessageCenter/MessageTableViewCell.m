//
//  MessageTableViewCell.m
//  North7
//
//  Created by Weiyu Chen on 2015/5/8.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()
@property (nonatomic, strong) UIImageView    *avatarImageView;
@property (nonatomic, strong) UILabel        *senderLabel;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) UILabel        *timeLabel;
@property (nonatomic, strong) UIImageView    *timeImageView;
@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMessgae:(NSString *)messgae {
    _messgae = messgae;
    [self initAvatarImageView];
    [self initSenderLabel];
    [self initTimeImageView];
    [self initTimeLabel];
    [self initTitleLabel];
}

//- (void) setMessageObject:(MessageObject *)messageObject {
//    _messageObject = messageObject;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (_messageObject.isRead) {
//        self.backgroundColor = [UIColor colorWithR:255 G:255 B:255];
//    } else {
//        self.backgroundColor = [UIColor colorWithR:232 G:240 B:250];
//    }
//    
//    [self initAvatarImageView];
//    [self initSenderLabel];
//    [self initTimeLabel];
//    [self initTitleLabel];
//}

- (void) initAvatarImageView {
    if (!_avatarImageView) {
        _avatarImageView                     = [[UIImageView alloc] initForAutolayout];
        _avatarImageView.layer.borderWidth   = 0.5f;
        _avatarImageView.layer.borderColor   = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.cornerRadius  = (_frameHeight * 11/60 - 20)/2;
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
                                                                         multiplier:1.0f constant: 10.0f]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:-10.0f]];
        [avatarImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatarImageView
                                                                          attribute:NSLayoutAttributeHeight
                                                                         multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:avatarImageViewConstraint];

    }
    _avatarImageView.image = [UIImage imageNamed:@"image_preset_avatar"];
//    if ([_messageObject.type isEqualToString:@"official"]) {
//        [_avatarImageView setImage:[UIImage imageNamed:kImageNamePresetOfficail]];
//    } else {
//        [_avatarImageView setImageWithURL:[NSURL URLWithString:_messageObject.senderAvatar]
//                     withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
//                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//                                    if (image) {
//                                        _avatarImageView.alpha = 0;
//                                        [UIView animateWithDuration:0.3 animations:^(){
//                                            _avatarImageView.alpha = 1;
//                                        }];
//                                    }
//                                    else {
//                                        [_avatarImageView setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
//                                    }
//                                }
//              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//
//    }
}

- (void) initSenderLabel {
    if (!_senderLabel) {
        _senderLabel                = [[UILabel alloc] initForAutolayout];
        _senderLabel.textColor      = [UIColor blackColor];
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
    _senderLabel.text = @"Sender";
   
}

- (void) initTitleLabel {
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc] initForAutolayout];
        _titleLabel.lineBreakMode   = UILineBreakModeWordWrap;
        _titleLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines   = 2;
        _titleLabel.textColor       = [UIColor colorWithHexString:@"#6d6d6d"];
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
                                                                        multiplier:1.0f constant:_frameHeight * 7.5/600]];
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
                                                                        multiplier:1.0f constant:-_frameHeight * 6/600]];
        
        [self addConstraints:titleLabelViewConstraint];
    }
    _titleLabel.text = @"title";
}

- (void) initTimeImageView {
    if (!_timeImageView) {
        _timeImageView       = [[UIImageView alloc] initForAutolayout];
        _timeImageView.image = [UIImage imageNamed:@"icon_time"];
        [self.contentView addSubview:_timeImageView];
        NSMutableArray *timeImageViewViewConstraint = [[NSMutableArray alloc] init];
        
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_avatarImageView
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:15.0f]];
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:15.5f]];
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:15.5f]];
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_avatarImageView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:timeImageViewViewConstraint];
    }
    
}


- (void) initTimeLabel {
    if (!_timeLabel) {
        _timeLabel              = [[UILabel alloc] initForAutolayout];
        _timeLabel.textColor    = [UIColor colorWithHexString:@"#ffa200"];
        _timeLabel.font         = [UIFont fontWithName:@"Arial" size:15.0];
        [self.contentView addSubview:_timeLabel];
        NSMutableArray *timeLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_timeImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:5.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:15.5f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-77.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_avatarImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:timeLabelViewConstraint];

    }
    _timeLabel.text = @"2015/08/20";
}

@end
