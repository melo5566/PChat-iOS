//
//  CustomizedSettingPageButton.m
//  FaceNews
//
//  Created by Weiyu Chen on 2015/7/8.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "CustomizedSettingPageButton.h"

@implementation CustomizedSettingPageButton

- (id) init {
    self = [CustomizedSettingPageButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

- (void) setSettingPageButtonType:(enum SettingPageButtonType)settingPageButtonType {
    _settingPageButtonType = settingPageButtonType;
    switch (_settingPageButtonType) {
        case SettingPageButtonTypeFacebookLogin: {
            self.backgroundColor = [UIColor colorWithHexString:kFacebookButtonColorHexString];
            [self setTitle:@"facebook 登入" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case SettingPageButtonTypeGoogleplusLogin: {
            self.backgroundColor = [UIColor colorWithHexString:kGooglePlusButtonColorHexString];
            [self setTitle:@"google+ 登入" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case SettingPageButtonTypePhoneLogin: {
            self.backgroundColor = [UIColor colorWithHexString:kPhoneButtonColorHexString];
            [self setTitle:@"電話登入" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case SettingPageButtonTypeLogout: {
            self.backgroundColor    = [UIColor colorWithR:0 G:139 B:139];
            self.layer.borderWidth  = 1.0f;
            self.layer.borderColor  = [UIColor colorWithR:0 G:139 B:139].CGColor;
            [self setTitle:@"登出" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            break;
        }
        case SettingPageButtonTypeSignUp: {
            self.backgroundColor = [UIColor colorWithHexString:kPhoneButtonColorHexString];
            [self setTitle:@"註冊" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case SettingPageButtonTypePhoneSignUp: {
            self.backgroundColor = [UIColor colorWithHexString:@"438a8a"];
            [self setTitle:@"電話註冊" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }

        case SettingPageButtonTypeSignIn: {
            self.backgroundColor = [UIColor colorWithHexString:kGooglePlusButtonColorHexString];
            [self setTitle:@"登入" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
        case SettingPageButtonTypeConfirm: {
            self.backgroundColor = [UIColor colorWithHexString:kGooglePlusButtonColorHexString];
            [self setTitle:@"確認" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;

        }
        default:
            break;
    }
    
    self.layer.cornerRadius = 10.0f;
    self.titleLabel.font = [UIFont systemFontOfSize:24.0f];
    [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) buttonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(settingPageButtonPressed:)]) {
        [self.delegate settingPageButtonPressed:sender];
    }
}

@end
