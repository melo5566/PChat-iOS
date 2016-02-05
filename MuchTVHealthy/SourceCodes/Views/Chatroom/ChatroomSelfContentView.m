//
//  ChatroomSelfContentView.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/1.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ChatroomSelfContentView.h"

#define kStickerWidth           kScreenWidth / 3 - 10

@interface ChatroomSelfContentView ()
@property (nonatomic, strong) UIView        *bubbleView;
@property (nonatomic, strong) UILabel       *contentLabel;
@property (nonatomic, strong) UIImageView   *stickerView;
@property (nonatomic, strong) UILabel       *timeLabel;
@property (nonatomic, strong) UIImageView   *stickerImageView;
@property (nonatomic, strong) UIImageView   *imageView;
@end

@implementation ChatroomSelfContentView

//- (void) setChatroomMessageObject:(ChatroomMessageObject *)chatroomMessageObject {
//    _chatroomMessageObject = chatroomMessageObject;
//    if (_chatroomMessageObject.chatroomMessageType == kChatroomMessageTypeText) {
//        [self initContentLabel];
//    }
//    else if (_chatroomMessageObject.chatroomMessageType == kChatroomMessageTypeStiker) {
//        [self initStickerView];
//    }
//}


- (void) setMessageObject:(MessageObject *)messageObject {
    _messageObject = messageObject;
    if (_messageObject.messageType == 1) {
        [self initStickerView];
    } else if (_messageObject.messageType == 2) {
        [self initImageView];
    } else {
        [self initContentLabel];
    }
}

- (void) initContentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initForAutolayout];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:kChatroomContentFontSize];
        [self addSubview:_contentLabel];
        NSMutableArray *contentLabelConstaint = @[].mutableCopy;
        [contentLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:kChatroomContentPadding]];
        [contentLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:kChatroomContentPadding]];
        [contentLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:-18.0f]];
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
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:-kChatroomBubbleTriangleGapPadding]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:0.0f]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:kStickerWidth]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [self addConstraints:stickerViewConstaint];
    }
    [_stickerView setImage:[UIImage imageNamed:_messageObject.content]];
    
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
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0f constant:0.0f]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f constant:0.0f]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kStickerWidth]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:0.0f]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f constant:0.0f]];
        [self addConstraints:imageViewConstaint];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPhoto:)];
        tap.numberOfTapsRequired = 1;
        [_imageView addGestureRecognizer:tap];
        
    }
    __block __typeof (UIImageView *) imageView = _imageView;
    [_imageView setImageWithURL:[NSURL URLWithString:_messageObject.content]
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


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_messageObject.messageType == 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context,
//                                       [UIColor colorWithHexString:kChatroomSelfContentBubbleColor].CGColor);
        CGContextSetFillColorWithColor(context,
                                       [UIColor blueColor].CGColor);
        CGContextSetStrokeColorWithColor(context,
                                         [UIColor colorWithHexString:kChatroomSelfContentBubbleBorderColor].CGColor);
        CGContextSetLineWidth(context, 0.8f);
        
        CGFloat radius = 8;
        
        CGContextMoveToPoint(context, 10, 0);
        CGContextAddArcToPoint(context, 0, 0, 0, 10, radius); // 左上弧
        CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.bounds) - 10); // 左border
        CGContextAddArcToPoint(context, 0, CGRectGetHeight(self.bounds), 10, CGRectGetHeight(self.bounds), radius);//左下弧
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds) - 18, CGRectGetHeight(self.bounds)); // 下border
        CGContextAddArcToPoint(context, CGRectGetWidth(self.bounds) - 8, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds) - 8, CGRectGetHeight(self.bounds) - 10, radius);//右下弧
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds) - 8, 7); // 右border
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), 0);
        CGContextAddLineToPoint(context, 10, 0); // 上border
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
    }
}

- (void) viewPhoto:(id)sender {
    if ([self.delegate respondsToSelector:@selector(viewPhoto:type:)]) {
        [self.delegate viewPhoto:_messageObject type:@"image"];
    }
}

@end
