//
//  CustomizedSettingPageButton.h
//  FaceNews
//
//  Created by Weiyu Chen on 2015/7/8.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SettingPageButtonType : NSUInteger {
    SettingPageButtonTypeFacebookLogin = 0,
    SettingPageButtonTypeGoogleplusLogin,
    SettingPageButtonTypePhoneLogin,
    SettingPageButtonTypeLogout,
    SettingPageButtonTypeSignUp,
    SettingPageButtonTypePhoneSignUp,
    SettingPageButtonTypeSignIn,
    SettingPageButtonTypeConfirm,
} SettingPageButtonType;


@protocol CustomizedSettingPageButtonDelegate <NSObject>

@optional
- (void) settingPageButtonPressed:(id)sender;
@end

@interface CustomizedSettingPageButton : UIButton
@property (nonatomic) enum SettingPageButtonType settingPageButtonType;
@property (nonatomic, weak) id <CustomizedSettingPageButtonDelegate> delegate;
@end
