//
//  ChatroomSpeakerView.h
//  493_Project
//
//  Created by Wu Peter on 2015/10/31.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatroomSpeakerViewDelegate <NSObject>

- (void) increaseSpeakerViewHeight;
- (void) decreaseSpeakerViewHeight;
- (void) submitMessage:(NSString *)message;
- (void) openStickerView;
- (void) closeStickerView;
- (void) askToLogin;
- (void) showAddAlertView;


@end

@interface ChatroomSpeakerView : UIView
@property (nonatomic, weak) id <ChatroomSpeakerViewDelegate> delegate;
@property (nonatomic, strong) UIButton      *attachmentButton;
@property (nonatomic) BOOL                  closeStickerView;
- (void) attachmentButtonPressed:(id) sender;
- (void) initLayout;
- (void) removeLoginButton;
@end

