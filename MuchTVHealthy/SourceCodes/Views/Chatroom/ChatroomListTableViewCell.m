//
//  ChatroomListTableViewCell.m
//  493_Project
//
//  Created by Wu Peter on 2015/12/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ChatroomListTableViewCell.h"
#import <Parse/Parse.h>


@interface ChatroomListTableViewCell()
@property (nonatomic, strong) UIImageView    *avatarImageView;
@property (nonatomic, strong) UILabel        *senderLabel;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) UILabel        *timeLabel;
@property (nonatomic, strong) UIImageView    *timeIcon;
@property (nonatomic, strong) UILabel        *distanceLabel;
@end

@implementation ChatroomListTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setChatroomListObject:(ChatroomListObject *)chatroomListObject {
    _chatroomListObject = chatroomListObject;
    if ([[PFUser currentUser].objectId isEqualToString:_chatroomListObject.creatorID])
        self.backgroundColor = [UIColor colorWithR:230 G:240 B:250];
    UIGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    [self.contentView addGestureRecognizer:longPress];
    [self initAvatarImageView];
    [self initSenderLabel];
    [self initTitleLabel];
    [self initDistanceLabel];
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
    [_avatarImageView setImageWithURL:[NSURL URLWithString:_chatroomListObject.creatorPhoto]
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
    _senderLabel.text = _chatroomListObject.creatorName;
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
                                                                        multiplier:1.0f constant:5.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-21.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_avatarImageView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:titleLabelViewConstraint];
    }
    _titleLabel.text = _chatroomListObject.chatroomName;
}

- (void) initDistanceLabel {
    if (!_distanceLabel) {
        _distanceLabel                 = [[UILabel alloc] initForAutolayout];
        _distanceLabel.textAlignment   = UITextAlignmentRight;
        _distanceLabel.textColor       = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _distanceLabel.font            = [UIFont fontWithName:@"Arial" size:18.0];
        [self.contentView addSubview:_distanceLabel];
        NSMutableArray *titleLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-10.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceLabel
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0f constant:0.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceLabel
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:100.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:30.0f]];
        
        [self addConstraints:titleLabelViewConstraint];
    }
    if (_chatroomListObject.range > 100)
        _distanceLabel.text = [NSString stringWithFormat:@"%.f km",_chatroomListObject.range];
    else if (_chatroomListObject.range < 1)
        _distanceLabel.text = [NSString stringWithFormat:@"%.f m",_chatroomListObject.range*1000];
    else
        _distanceLabel.text = [NSString stringWithFormat:@"%.2f km",_chatroomListObject.range];
}


- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(handleLongPressD:)]) {
        [self.delegate handleLongPressD:_chatroomListObject.creatorID];
    }
}

@end
