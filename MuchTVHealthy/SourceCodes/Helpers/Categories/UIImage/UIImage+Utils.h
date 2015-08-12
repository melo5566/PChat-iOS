//
//  UIImage+Utils.h
//  FanXinUltimate
//
//  Created by Eddie Kao on 13/7/26.
//  Copyright (c) 2013年 FanzyTV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

- (BOOL) isProtrait;
- (BOOL) isLandscape;
- (UIImage *) scaledWithMaxLength:(CGFloat)maxLength;
+ (UIImage *) nonCachedImageNamed:(NSString *)imageName;
+ (UIImage *) cutImageToSquare:(UIImage *)image;
@end
