//
//  UIColor+HexColor.h
//  Community
//
//  Created by Weiyu Chen on 2015/2/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *) hex;
+ (UIColor *)colorWithHexString:(NSString *) hex withAlpha:(CGFloat) alpha;
+ (UIColor *)colorWithR:(CGFloat)RedValue G:(CGFloat)GreenValue B:(CGFloat)BlueValue;
+ (UIColor *)colorWithR:(CGFloat)RedValue G:(CGFloat)GreenValue B:(CGFloat)BlueValue andAlpha:(CGFloat)alpha;

@end
