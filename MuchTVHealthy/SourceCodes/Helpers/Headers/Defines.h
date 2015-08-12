//
//  Defines.h
//  North7
//
//  Created by Weiyu Chen on 2015/2/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#ifndef IS_IOS_8
#define IS_IOS_8     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#endif

#ifndef IS_IPHONE_4
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#endif

#ifndef IS_IPHONE_5
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#endif

#ifndef IPHONE_6_SCREEN_WIDTH
#define IPHONE_6_SCREEN_WIDTH   375.0f
#endif

#ifndef kScreenWidth
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#endif

#ifndef kStatusBarHeight
#define kStatusBarHeight 20.0f
#endif

#ifndef kGroupButtonHeight
#define kGroupButtonHeight 44.0f
#endif

#ifndef kTabBarHeight
#define kTabBarHeight 49.0f
#endif

#ifndef kScreenHeight
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef kScreenOriginY
#define kScreenOriginY (IS_IOS_7 ? 0.0f : kStatusBarHeight)
#endif

#ifndef kIOSVersion
#define kIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

#ifndef kCurrentLanguage
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#endif

#ifndef kFrameWidth
#define kFrameWidth CGRectGetWidth(self.view.frame)
#endif

#ifndef kFrameHeight
#define kFrameHeight CGRectGetHeight(self.view.frame)
#endif

#ifndef kBoundsWidth
#define kBoundsWidth CGRectGetWidth(self.bounds)
#endif

#ifndef kBoundsHeight
#define kBoundsHeight CGRectGetHeight(self.bounds)
#endif

#ifndef kNavigationBarHeight
#define kNavigationBarHeight (IS_IOS_7 ? kNavigationBarExtendHeight : kNavigationBarDefaultHeight)
#endif

#ifndef kNavigationBarDefaultHeight
#define kNavigationBarDefaultHeight 44.0f
#endif

#ifndef kNavigationBarExtendHeight
#define kNavigationBarExtendHeight kNavigationBarDefaultHeight + kStatusBarHeight
#endif

#ifndef kUserDefault
#define kUserDefault [NSUserDefaults standardUserDefaults]
#endif

#ifndef kImageNamed
#define kImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]
#endif

#ifndef kRGBColor
#define kRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif

#ifndef kRGBAColor
#define kRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#endif

#ifndef DLog
#define DLog(fmt, ...) NSLog((@"\n************************ debug start ************************\n %s [Line %d] \n" fmt "\n************************ debug end ************************"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

#ifndef ON
#define ON   YES
#endif

#ifndef OFF
#define OFF  NO
#endif

#pragma mark - MBProgressHUD custom view
//#define kMBProgressHUDSuccessView                [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hud_checkmark"]]
#define kMBProgressHUDSuccessView   [MBProgressHUD fanxinCustomView]

#ifndef isNullValue
#define isNullValue(object) (object == nil || [object isKindOfClass:[NSNull class]])
#endif

#ifndef isNotNullValue
#define isNotNullValue(object) !isNullValue(object)
#endif

#ifndef toIntegerValue
#define toIntegerValue(object) (isNotNullValue(object) ? [object integerValue] : 0)
#endif

#ifndef toNumberValue
#define toNumberValue(object) (isNotNullValue(object) ? object : @0)
#endif

#ifndef toStringValue
#define toStringValue(object) (isNotNullValue(object) ? object : @"")
#endif

#ifndef kFacebookID
#define kFacebookID [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]][@"FacebookAppID"]
#endif
