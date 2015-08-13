//
//  BaseViewController.h
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BaseModel.h"

@protocol NoNetworkAlertDelegate <NSObject>

@optional
- (void) noNetworkAlertRefreshButtonPressed;
- (void) noNetworkAlertCancelButtonPressed;

@end

@interface BaseViewController : UIViewController <NoNetworkAlertDelegate, BaseModelDelegate, UIAlertViewDelegate>

- (void) initMenuLayout;
- (void) initWholeButton;
- (void) dismissMenu;

- (void) initNavigationBarCloseButtonAtLeft;
- (void) initNavigationBarCloseButtonAtRight;
- (void) initNavigationBarBackButtonAtLeft;
- (void) initNavigationBarBackButtonAtRight;
- (BOOL) isModal;
- (void) backButtonPressed:(id) sender;
- (void) receiveNotification:(NSNotification *)notification;
- (void) showHUDAddedTo:(UIView *)view
               animated:(BOOL)animated
                HUDMode:(MBProgressHUDMode)mode
                   text:(NSString *)text
            delayToHide:(CGFloat)delayToHide;
- (void) askToLogIn;

@property (nonatomic, strong) AppDelegate       *appdelegate;
@property (nonatomic, strong) MBProgressHUD     *hud;

@property (weak) id <NoNetworkAlertDelegate>  noNetworkAlertDelegate;

@end

