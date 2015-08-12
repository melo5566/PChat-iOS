//
//  UIImageView+ActivityIndicator.m
//  Community
//
//  Created by Weiyu Chen on 2015/2/11.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "UIImageView+ActivityIndicator.h"

@interface UIImageView (Private)

-(void)addActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle) activityStyle;

@end

@implementation UIImageView (ActivityIndicator)

@dynamic activityIndicator;
- (void)addActivityIndicatorWithActivityStyle:(UIActivityIndicatorViewStyle) activityStyle {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityStyle];
        [self.activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:self.activityIndicator];
        
        NSMutableArray *activityIndicatorConstraint = @[].mutableCopy;
        
        [activityIndicatorConstraint addObject:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:self.activityIndicator.bounds.size.width]];
        [activityIndicatorConstraint addObject:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:self.activityIndicator.bounds.size.height]];
        [activityIndicatorConstraint addObject:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1.0f constant:0.0f]];
        [activityIndicatorConstraint addObject:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeCenterX
                                                                           multiplier:1.0f constant:0.0f]];
        [self addConstraints:activityIndicatorConstraint];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.activityIndicator startAnimating];
    });
    
}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

- (void)setImageWithURL:(NSURL *)url withPlaceholderImage:(UIImage *)placeholder usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStye {
    [self setImageWithURL:url withPlaceholderImage:placeholder options:0 progress:nil completed:nil usingActivityIndicatorStyle:activityStye];
}

- (void)setImageWithURL:(NSURL *)url withPlaceholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStye {
    [self setImageWithURL:url withPlaceholderImage:placeholder options:0 progress:nil completed:completedBlock usingActivityIndicatorStyle:activityStye];
}

- (void)setImageWithURL:(NSURL *)url withPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle {
    
    [self addActivityIndicatorWithActivityStyle:activityStyle];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                    progress:progressBlock
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (completedBlock) {
                           completedBlock(image, error, cacheType, imageURL);
                       }
                       [weakSelf removeActivityIndicator];
                   }
     ];
}

@end
