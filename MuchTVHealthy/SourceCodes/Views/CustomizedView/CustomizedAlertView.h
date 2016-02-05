//
//  CustomizedAlertView.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/13.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomizedAlertViewButtonType) {
    CustomizedAlertViewButtonTypeDefaultPink = 0,
    CustomizedAlertViewButtonTypeDefaultBlue,
    CustomizedAlertViewButtonTypeCancel,
    CustomizedAlertViewButtonTypeDefaultGreen,
    CustomizedAlertViewButtonTypeDefaultLightGreen
};

@class CustomizedAlertView;
typedef void(^CustomizedAlertViewHandler)(CustomizedAlertView *alertView);

//@interface AlertViewButton : UIButton
//- (id) initWithTitle:(NSString *)title buttonColorHexString:(NSString *)hexString handler:(CustomizedAlertViewHandler)buttonHandler;
//@end


@interface CustomizedAlertView : UIWindow

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)addButtonWithTitle:(NSString *)title type:(CustomizedAlertViewButtonType)type handler:(CustomizedAlertViewHandler)handler;


//- (id) initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message buttonNumber:(NSUInteger)buttonNumber;
//- (void) addButtonWithTitle:(NSString *)buttonTitle buttonColorHexString:(NSString *)hexString handler:(CustomizedAlertViewHandler)buttonHandler;
- (void) show;
@end
