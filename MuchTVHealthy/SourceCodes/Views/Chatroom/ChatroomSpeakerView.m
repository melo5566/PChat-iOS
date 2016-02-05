//
//  ChatroomSpeakerView.m
//  493_Project
//
//  Created by Wu Peter on 2015/10/31.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ChatroomSpeakerView.h"
#import "PersonalSettingViewController.h"
#import "ChatroomStickerView.h"
#import "CustomizedAlertView.h"
#import <Parse/Parse.h>

@interface ChatroomSpeakerView () <UITextViewDelegate, ChatroomStickerViewDelegate>
@property (nonatomic, strong) UIView                *topLine;
@property (nonatomic, strong) UIButton              *submitButton;
@property (nonatomic, strong) UIView                *speakerTextfieldView;
@property (nonatomic, strong) UITextView            *speakerTextView;
@property (nonatomic, strong) UILabel               *speakerTextPlaceholder;
@property (nonatomic, strong) UIButton              *addButton;
@property (nonatomic, strong) UIButton              *loginButton;
//@property (nonatomic, strong) NSLayoutConstraint    *speakerTextfieldViewHeightConstraint;
//@property (nonatomic, strong) NSLayoutConstraint    *speakerTextViewHeightConstraint;

@end

@implementation ChatroomSpeakerView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLayout];
    }
    return self;
}

- (void) initLayout {
    self.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [self initTopLine];
    if ([PFUser currentUser]) {
        [self initSubmitButton];
        [self initAddButton];
        [self initAttachmentButton];
        [self initSpeakerTextfieldView];
    } else {
        [self initLoginButton];
    }
}

- (void) initTopLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] initForAutolayout];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self addSubview:_topLine];
        NSMutableArray *topLineConstaint = @[].mutableCopy;
        [topLineConstaint addObject:[NSLayoutConstraint constraintWithItem:_topLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:0.0f]];
        [topLineConstaint addObject:[NSLayoutConstraint constraintWithItem:_topLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f constant:0.0f]];
        [topLineConstaint addObject:[NSLayoutConstraint constraintWithItem:_topLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:1.0f]];
        [topLineConstaint addObject:[NSLayoutConstraint constraintWithItem:_topLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0.0f]];
        [self addConstraints:topLineConstaint];
    }
}

- (void) initAttachmentButton {
    if (!_attachmentButton) {
        _attachmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attachmentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_attachmentButton addTarget:self action:@selector(attachmentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _attachmentButton.tag = 0;
        _attachmentButton.backgroundColor = [UIColor clearColor];
        [_attachmentButton setImage:[UIImage imageNamed:@"attachment"] forState:UIControlStateNormal];
        [self addSubview:_attachmentButton];
        NSMutableArray *attachmentButtonConstaint = @[].mutableCopy;
        [attachmentButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_attachmentButton
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_addButton
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:0.0f]];
        [attachmentButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_attachmentButton
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:30.0f]];
        [attachmentButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_attachmentButton
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:30.0f]];
        [attachmentButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_attachmentButton
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:-10.0f]];
        [self addConstraints:attachmentButtonConstaint];
    }
}

- (void) initAddButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.tag = 0;
        _addButton.backgroundColor = [UIColor clearColor];
        [_addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [self addSubview:_addButton];
        NSMutableArray *addButtonConstaint = @[].mutableCopy;
        [addButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_addButton
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0f constant:3.0f]];
        [addButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_addButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:30.0f]];
        [addButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_addButton
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:30.0f]];
        [addButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_addButton
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:-10.0f]];
        [self addConstraints:addButtonConstaint];
    }
}


- (void) initSpeakerTextfieldView {
    if (!_speakerTextfieldView) {
        _speakerTextfieldView = [[UIView alloc] initForAutolayout];
        _speakerTextfieldView.backgroundColor = [UIColor colorWithHexString:kChatroomSpeakerTextFieldColor];
        _speakerTextfieldView.layer.cornerRadius = 36 / 4;
        _speakerTextfieldView.layer.borderWidth = 0.5;
        _speakerTextfieldView.layer.borderColor = [UIColor colorWithHexString:kChatroomSpeakerTextFieldBorderColor].CGColor;
        [self addSubview:_speakerTextfieldView];
        
        NSMutableArray *speakerTextfieldViewConstaint = @[].mutableCopy;
        
        [speakerTextfieldViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextfieldView
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_attachmentButton
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:8]];
        [speakerTextfieldViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextfieldView
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0f constant:-8.0f]];
        [speakerTextfieldViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextfieldView
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f constant:7.0f]];
        [speakerTextfieldViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextfieldView
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_submitButton
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0f constant:-8]];
        [self addConstraints:speakerTextfieldViewConstaint];
    }
    [self initSpeakerTextView];
    [self initSpeakerTextPlaceholder];
}

- (void) initSpeakerTextView {
    if (!_speakerTextView) {
        _speakerTextView = [[UITextView alloc] initForAutolayout];
        _speakerTextView.delegate = self;
        _speakerTextView.backgroundColor = [UIColor clearColor];
        _speakerTextView.scrollEnabled = YES;
        _speakerTextView.font = [UIFont systemFontOfSize:16.0f];
        
        [self addSubview:_speakerTextView];
        NSMutableArray *speakerTextViewConstaint = @[].mutableCopy;
        [speakerTextViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextView
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_attachmentButton
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:8]];
        [speakerTextViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:-8.0f]];
        [speakerTextViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:7.0f]];
        [speakerTextViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_submitButton
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:-8]];
        [self addConstraints:speakerTextViewConstaint];
    }
}

- (void) initSpeakerTextPlaceholder {
    if (!_speakerTextPlaceholder) {
        _speakerTextPlaceholder = [[UILabel alloc] initForAutolayout];
        _speakerTextPlaceholder.backgroundColor = [UIColor clearColor];
        _speakerTextPlaceholder.textColor = [UIColor colorWithHexString:@"#717171"];
        _speakerTextPlaceholder.font = [UIFont systemFontOfSize:16.0f];
        _speakerTextPlaceholder.text = [NSString stringWithFormat:@"Max %lu",(unsigned long)kChatroomSpeakerTextLimitLength];
        [_speakerTextfieldView addSubview:_speakerTextPlaceholder];
        NSMutableArray *textPlaceholderConstaint = @[].mutableCopy;
        [textPlaceholderConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextPlaceholder
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_speakerTextfieldView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:4.0f]];
        [textPlaceholderConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextPlaceholder
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:18.0f]];
        [textPlaceholderConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextPlaceholder
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_speakerTextfieldView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0f constant:0.0f]];
        [textPlaceholderConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerTextPlaceholder
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_speakerTextfieldView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-4.0f]];
        [self addConstraints:textPlaceholderConstaint];
    }
}

- (void) initSubmitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.backgroundColor = [UIColor redColor];
        [_submitButton setTitle:@"Send" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _submitButton.layer.cornerRadius = 5;
        _submitButton.layer.borderWidth = 1;
        _submitButton.layer.borderColor = [UIColor colorWithHexString:@"#FFCF11"].CGColor;
        [self addSubview:_submitButton];
        NSMutableArray *submitButtonConstaint = @[].mutableCopy;
        [submitButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_submitButton
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:-8.0f]];
        [submitButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_submitButton
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:-8.0f]];
        [submitButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_submitButton
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f constant:35.0f]];
        [submitButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_submitButton
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f constant:45.0f]];
        [self addConstraints:submitButtonConstaint];
    }
}

- (void) initLoginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.backgroundColor = [UIColor colorWithHexString:@"#2a7372"];
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [self addSubview:_loginButton];
        NSMutableArray *loginButtonConstaint = @[].mutableCopy;
        [loginButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_loginButton
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        [loginButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_loginButton
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [loginButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_loginButton
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [loginButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_loginButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:0.0f]];
        [self addConstraints:loginButtonConstaint];
    }
}


- (void) attachmentButtonPressed:(id) sender {
    UIButton *attachmentButton = sender;
    if (attachmentButton.tag == 0) {
        attachmentButton.tag = 1;
        [self.delegate openStickerView];
    } else {
        attachmentButton.tag = 0;
        [self.delegate closeStickerView];
    }
}


- (void)addButtonPressed:(id)sender {
    [self.delegate showAddAlertView];
}

- (void) submitButtonPressed:(id) sender {
    if ([_speakerTextView.text isNotEmpty] && [self.delegate respondsToSelector:@selector(submitMessage:)]) {
        [self.delegate submitMessage:_speakerTextView.text];
        _speakerTextView.text = @"";
        _speakerTextPlaceholder.hidden = NO;
        if (_speakerTextView.contentSize.height > 36) {
            [self.delegate decreaseSpeakerViewHeight];
        }
    }
}



#pragma mark - textView delegate
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (isNullValue([textView markedTextRange])) {
        if (textView.text.length - range.length + text.length  > kChatroomSpeakerTextLimitLength) {
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        _speakerTextPlaceholder.hidden = YES;
    } else {
        _speakerTextPlaceholder.hidden = NO;
    }
    
    if (isNullValue([textView markedTextRange])) {
        if (textView.text.length > kChatroomSpeakerTextLimitLength) {
            NSRange oversteppedRange = NSMakeRange(kChatroomSpeakerTextLimitLength, textView.text.length - kChatroomSpeakerTextLimitLength);
            textView.text = [textView.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
    }
    
    if (textView.contentSize.height > 36 && textView.contentSize.height <= 55) {
        [self.delegate increaseSpeakerViewHeight];
        [_speakerTextView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (textView.contentSize.height == 36) {
        [self.delegate decreaseSpeakerViewHeight];
    }
}

- (void)loginButtonPressed:(id)sender {
    [self.delegate askToLogin];
}

- (void) removeLoginButton {
    if (_loginButton) {
        [_loginButton removeFromSuperview];
        _loginButton = nil;
    }
    [self initLayout];
}

@end
