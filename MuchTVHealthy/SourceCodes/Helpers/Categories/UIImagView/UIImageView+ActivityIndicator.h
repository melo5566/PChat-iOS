//
//  UIImageView+ActivityIndicator.h
//  Community
//
//  Created by Weiyu Chen on 2015/2/11.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface UIImageView (ActivityIndicator)

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
- (void)addActivityIndicatorWithActivityStyle:(UIActivityIndicatorViewStyle) activityStyle;
- (void)setImageWithURL:(NSURL *)url withPlaceholderImage:(UIImage *)placeholder usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;
- (void)setImageWithURL:(NSURL *)url withPlaceholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStye;

@end
