//
//  UIImage+Utils.m
//  FanXinUltimate
//
//  Created by Eddie Kao on 13/7/26.
//  Copyright (c) 2013年 FanzyTV. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

/**
 *  檢查 image 是否為橫向
 */
- (BOOL) isLandscape
{
    if (self.size.height > self.size.width) {
        return NO;
    }
    else {
        return YES;
    }
}

/**
 *  檢查 image 是否為直向
 */
- (BOOL) isProtrait
{
    return ![self isLandscape];
}

/**
 *  get image via image path
 */
+ (UIImage *) nonCachedImageNamed:(NSString *)imageName
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}

/**
 *  resize
 */
- (UIImage *) scaledWithMaxLength:(CGFloat)maxLength
{
    // 先找出長、寬最大者
    CGFloat longestLength = MAX(self.size.width, self.size.height);
    
    // 若最大邊超過720，則進行縮圖的動作
    if (longestLength > maxLength) {
        maxLength = maxLength / 2;  // 上傳後size會自動被放大成2倍(server端特別處理?)，所以先將size減半
        CGFloat ratio = maxLength / longestLength;
        CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    return self;
}

/**
 *  將圖片切成正方形
 */
+ (UIImage *)cutImageToSquare:(UIImage *)image
{
    CGFloat min = MIN(image.size.height, image.size.width);
    CGRect rect = CGRectMake((image.size.width - min)/2, (image.size.height - min)/2, min, min);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef
                                       scale:1
                                 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return img;
}

@end
