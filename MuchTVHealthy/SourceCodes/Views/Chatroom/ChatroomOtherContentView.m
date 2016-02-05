//
//  ChatroomOtherContentView.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ChatroomOtherContentView.h"

#define kStickerWidth                   kScreenWidth / 3 - 10
#define kMaxNameLabelWidthOfCelebrity   kScreenWidth - kGlobalDefaultPadding - kChatroomAvatarWidth - 5.0f - kChatroomBubbleTriangleGapPadding - 4.0f - (kChatroomUsernameFontSize + 2) - kGlobalDefaultPadding
#define kMaxNameLabelWidth              kScreenWidth - kGlobalDefaultPadding - kChatroomAvatarWidth - 5.0f - kChatroomBubbleTriangleGapPadding - kGlobalDefaultPadding

@interface ChatroomOtherContentView ()
@property (nonatomic, strong) UIImageView   *avatar;
@property (nonatomic, strong) UIImageView   *officialIcon;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *contentLabel;
@property (nonatomic, strong) UILabel       *timeLabel;
@property (nonatomic, strong) UIImageView   *stickerView;
@property (nonatomic, strong) UIImageView   *imageView;
@end

@implementation ChatroomOtherContentView

- (void) setMessageObject:(MessageObject *)messageObject {
    _messageObject = messageObject;
    if (_messageObject.messageType == 0) {
        [self initAvatar];
        [self initNameLabel];
        [self initContentLabel];
    } else if (_messageObject.messageType == 1) {
        [self initAvatar];
        [self initNameLabel];
        [self initStickerView];
    } else {
        [self initAvatar];
        [self initNameLabel];
        [self initImageView];
    }
}

- (void) initTimeLabel {
    if (!_timeLabel) {
        _timeLabel               = [[UILabel alloc] initForAutolayout];
        _timeLabel.textAlignment = UITextAlignmentRight;
        _timeLabel.textColor     = [UIColor colorWithHexString:kChatroomTimeLabelColor];
        _timeLabel.font          = [UIFont fontWithName:@"Arial" size:kChatroomTimeFontSize];
        [self addSubview:_timeLabel];
        NSMutableArray *timeLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_imageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:15.5f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_imageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:10.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kChatroomTimeLabelMinimumWidth]];
        
        [self addConstraints:timeLabelViewConstraint];
        
    }
    _timeLabel.text = _messageObject.sendTime;
}


- (void) initAvatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initForAutolayout];
        _avatar.backgroundColor = [UIColor clearColor];
        _avatar.clipsToBounds = YES;
        _avatar.userInteractionEnabled = YES;
        _avatar.layer.borderWidth = 1;
        _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatar.layer.cornerRadius = 5;
        [self addSubview:_avatar];
        NSMutableArray *avatarConstaint = @[].mutableCopy;
        [avatarConstaint addObject:[NSLayoutConstraint constraintWithItem:_avatar
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:0.0f]];
        [avatarConstaint addObject:[NSLayoutConstraint constraintWithItem:_avatar
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f constant:0.0f]];
        [avatarConstaint addObject:[NSLayoutConstraint constraintWithItem:_avatar
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f constant:kChatroomAvatarWidth]];
        [avatarConstaint addObject:[NSLayoutConstraint constraintWithItem:_avatar
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f constant:kChatroomAvatarHeight]];
        [self addConstraints:avatarConstaint];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAvatar:)];
        tap.numberOfTapsRequired = 1;
        [_avatar addGestureRecognizer:tap];
        

    }
    
    __block __typeof (UIImageView *) avatar = _avatar;
    [_avatar setImageWithURL:[NSURL URLWithString:_messageObject.senderPhoto]
        withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                       if (image) {
                           avatar.alpha = 0;
                           [UIView animateWithDuration:0.3 animations:^(){
                               avatar.alpha = 1;
                           }];
                       }
                       else {
                           [avatar setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                       }
                   }
usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void) initImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initForAutolayout];
        _imageView.backgroundColor = [UIColor clearColor];
        [_imageView setUserInteractionEnabled:YES];
        [self addSubview:_imageView];
        
        NSMutableArray *imageViewConstaint = @[].mutableCopy;
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_nameLabel
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0f constant:0.0f]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_nameLabel
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:5.0f]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kStickerWidth]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kStickerWidth]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f constant:0.0f]];
        [self addConstraints:imageViewConstaint];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewImage:)];
        tap.numberOfTapsRequired = 1;
        [_imageView addGestureRecognizer:tap];

    }
    __block __typeof (UIImageView *) imageView = _imageView;
    [_imageView setImageWithURL:[NSURL URLWithString:_messageObject.content]
        withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
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

- (void) initNameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initForAutolayout];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:kChatroomUsernameFontSize];
        _nameLabel.textColor = [UIColor colorWithHexString:kChatroomNameLabelColor];
        [self addSubview:_nameLabel];
        NSMutableArray *nameLabelConstaint = @[].mutableCopy;
        
        [nameLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_avatar
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f constant:kChatroomContentPadding]];
        [nameLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f constant:0.0f]];
        [nameLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kMaxNameLabelWidth]];
//        [nameLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
//                                                                   attribute:NSLayoutAttributeWidth
//                                                                   relatedBy:NSLayoutRelationLessThanOrEqual
//                                                                      toItem:nil
//                                                                   attribute:NSLayoutAttributeNotAnAttribute
//                                                                  multiplier:1.0f constant:![_chatroomMessageObject.user_type isEqual: @(0)] ? kMaxNameLabelWidthOfCelebrity : kMaxNameLabelWidth]];
        [nameLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kChatroomUsernameFontSize + 2]];
        [self addConstraints:nameLabelConstaint];
    }
    
    _nameLabel.text = _messageObject.senderName;
    _nameLabel.numberOfLines = 1;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_nameLabel sizeToFit];
}

- (void) initContentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initForAutolayout];
        _contentLabel.backgroundColor = [UIColor redColor];
        _contentLabel.font = [UIFont systemFontOfSize:kChatroomContentFontSize];
        _contentLabel.textColor = [UIColor whiteColor];
        [self addSubview:_contentLabel];
        NSMutableArray *contentLabelConstaint = @[].mutableCopy;
        
        
        [contentLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_avatar
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:kChatroomContentPadding + kChatroomBubbleTriangleGapPadding + kChatroomContentPadding]];
        [contentLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_nameLabel
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:5.0f + kChatroomContentPadding]];
        [contentLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:-kChatroomContentPadding]];
        NSLayoutConstraint *labelHeightConstraint = [NSLayoutConstraint constraintWithItem:_contentLabel
                                                                                 attribute:NSLayoutAttributeHeight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:nil
                                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                                multiplier:1.0f constant:kChatroomContentFontSize + 2];
        labelHeightConstraint.priority = 250;
        [self addConstraint:labelHeightConstraint];
        [self addConstraints:contentLabelConstaint];
    }
    _contentLabel.text = _messageObject.content;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentLabel sizeToFit];
}

- (void) initStickerView {
    if (!_stickerView) {
        _stickerView = [[UIImageView alloc] initForAutolayout];
        _stickerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_stickerView];
        NSMutableArray *stickerViewConstaint = @[].mutableCopy;
        
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_nameLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_nameLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:kStickerWidth]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:kStickerWidth]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        [self addConstraints:stickerViewConstaint];
    }
    [_stickerView setImage:[UIImage imageNamed:_messageObject.content]];
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_messageObject.messageType == 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,
                                       [UIColor redColor].CGColor);

//        CGContextSetFillColorWithColor(context,
//                                       [UIColor colorWithHexString:kChatroomOthersContentBubbleColor].CGColor);
        CGContextSetStrokeColorWithColor(context,
                                         [UIColor colorWithHexString:kChatroomOthersContentBubbleColor].CGColor);
        CGContextSetLineWidth(context, 0.8f);
        
        CGFloat radius = 8;
        CGFloat leftPointX = kChatroomAvatarWidth + kChatroomContentPadding;
        CGFloat topPointY = kChatroomUsernameFontSize + 2 + 5.0f;
        
        CGContextMoveToPoint(context, leftPointX, topPointY);
        CGContextAddLineToPoint(context, leftPointX + kChatroomBubbleTriangleGapPadding, topPointY + 7);
        CGContextAddLineToPoint(context, leftPointX + kChatroomBubbleTriangleGapPadding, CGRectGetHeight(self.bounds) - 10); // 左border
        CGContextAddArcToPoint(context, leftPointX  + kChatroomBubbleTriangleGapPadding, CGRectGetHeight(self.bounds), leftPointX  + kChatroomBubbleTriangleGapPadding + 10, CGRectGetHeight(self.bounds), radius); // 左下弧
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds) - 10, CGRectGetHeight(self.bounds)); // 下border
        CGContextAddArcToPoint(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 10, radius);//右下弧
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), topPointY + 10); // 右border
        CGContextAddArcToPoint(context, CGRectGetWidth(self.bounds), topPointY, CGRectGetWidth(self.bounds) - 10, topPointY, radius);//右上弧
        CGContextAddLineToPoint(context, leftPointX, topPointY); // 上border
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

- (void) viewImage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(viewPhoto:type:)]) {
        [self.delegate viewPhoto:_messageObject type:@"image"];
    }
}

- (void) viewAvatar:(id)sender {
    if ([self.delegate respondsToSelector:@selector(viewPhoto:type:)]) {
        [self.delegate viewPhoto:_messageObject type:@"avatar"];
    }
}

@end
