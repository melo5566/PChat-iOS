//
//  ChatroomTableViewCell.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/1.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ChatroomTableViewCell.h"
#import "ChatroomSelfContentView.h"
#import "ChatroomOtherContentView.h"
#import <Parse/Parse.h>

@interface ChatroomTableViewCell() <chatroomOtherContentViewDelegate, chatroomSelfContentViewDelegate>
@property (nonatomic, strong) ChatroomSelfContentView       *selfContentView;
@property (nonatomic, strong) ChatroomOtherContentView      *otherContentView;
@property (nonatomic, strong) UILabel                       *timeLabel;
@property (nonatomic, strong) UIImageView                   *timeImageView;
@end


@implementation ChatroomTableViewCell

- (void) setMessageObject:(MessageObject *)messageObject {
    _messageObject = messageObject;
    self.backgroundColor = [UIColor clearColor];
    PFUser *currentLoginUser = [PFUser currentUser];
    if ([currentLoginUser.objectId isEqualToString:messageObject.userId]) {
        [self initSelfContentView];
        [self initSelfTimeLabel];
    } else {
        [self initOtherContentView];
        [self initOtherTimeLabel];
    }    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initSelfContentView {
    if (!_selfContentView) {
        _selfContentView = [[ChatroomSelfContentView alloc] initForAutolayout];
        _selfContentView.delegate = self;
        _selfContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_selfContentView];
        NSMutableArray *selfContentViewConstaint = @[].mutableCopy;
        [selfContentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_selfContentView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-(kChatroomContentPadding)]];
        [selfContentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_selfContentView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:10.0f]];
        [selfContentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_selfContentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:2 * kGlobalDefaultPadding + kChatroomTimeLabelMinimumWidth]];
        [selfContentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_selfContentView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:-10.0f]];
        [self addConstraints:selfContentViewConstaint];
    }
    _selfContentView.messageObject = _messageObject;
    [_selfContentView setNeedsDisplay];
}


-(void) initOtherContentView {
    if (!_otherContentView) {
        _otherContentView = [[ChatroomOtherContentView alloc] initForAutolayout];
        _otherContentView.backgroundColor = [UIColor clearColor];
        _otherContentView.delegate = self;
        _otherContentView.clipsToBounds = NO;
        [self.contentView addSubview:_otherContentView];
        
        NSMutableArray *selfContentViewConstaint = @[].mutableCopy;
        
        [selfContentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_otherContentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:kChatroomBubblePadding]];
        [selfContentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_otherContentView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:10.0f]];
        [selfContentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_otherContentView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-(2*kGlobalDefaultPadding + kChatroomTimeLabelMinimumWidth)]];
        [selfContentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_otherContentView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:-5.0f]];
        [self addConstraints:selfContentViewConstaint];
    }
    _otherContentView.messageObject = _messageObject;
    [_otherContentView setNeedsDisplay];
}


- (void) initSelfTimeLabel {
    if (!_timeLabel) {
        _timeLabel               = [[UILabel alloc] initForAutolayout];
        _timeLabel.textAlignment = UITextAlignmentRight;
        _timeLabel.textColor     = [UIColor colorWithHexString:kChatroomTimeLabelColor];
        _timeLabel.font          = [UIFont fontWithName:@"Arial" size:kChatroomTimeFontSize];
        [self.contentView addSubview:_timeLabel];
        NSMutableArray *timeLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_selfContentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:15.5f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_selfContentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:-10.0f]];
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

- (void) initOtherTimeLabel {
    if (!_timeLabel) {
        _timeLabel               = [[UILabel alloc] initForAutolayout];
        _timeLabel.textAlignment = UITextAlignmentLeft;
        _timeLabel.textColor     = [UIColor colorWithHexString:kChatroomTimeLabelColor];
        _timeLabel.font          = [UIFont fontWithName:@"Arial" size:kChatroomTimeFontSize];
        [self.contentView addSubview:_timeLabel];
        NSMutableArray *timeLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_otherContentView
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
                                                                           toItem:_otherContentView
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


- (void)viewPhoto:(MessageObject *)messageObject type:(NSString *)type{
    if ([self.delegate respondsToSelector:@selector(viewPhoto:type:)]) {
        [self.delegate viewPhoto:messageObject type:type];
    }
}


@end
