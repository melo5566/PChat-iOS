//
//  ImageSlideView.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/17.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ImageSlideView.h"



@interface ImageSlideView ()
@property (nonatomic, strong) NSArray           *imageArray;
@property (nonatomic, strong) UIScrollView      *backgroundScrollView;
@property (nonatomic, strong) UIView            *backgroundContentView;
@property (nonatomic) BOOL                      isUseImageUrl;
@property (nonatomic) BOOL                      isUseImageFileName;
@end

@implementation ImageSlideView

- (id) initWithImageFileNameArray:(NSArray *)imageArray {
    self = [super initForAutolayout];
    if (self) {
        self.clipsToBounds = NO;
        _imageArray = imageArray;
        _isUseImageFileName = YES;
        _isUseImageUrl = NO;
    }
    return self;
}

- (id) initWithImageUrlArray:(NSArray *)imageArray {
    self = [super initForAutolayout];
    if (self) {
        self.clipsToBounds = NO;
        _imageArray = imageArray;
        _isUseImageFileName = NO;
        _isUseImageUrl = YES;
    }
    return self;
}

- (void) initLayout {
    [self initBackgroundScrollView];
    [self initbackgroundContentView];
    [self initImageViews];
}

- (void) initBackgroundScrollView {
    _backgroundScrollView = [[UIScrollView alloc] initForAutolayout];
    _backgroundScrollView.pagingEnabled = YES;
    _backgroundScrollView.backgroundColor = [UIColor clearColor];
    _backgroundScrollView.showsHorizontalScrollIndicator = NO;
    _backgroundScrollView.showsVerticalScrollIndicator = NO;
    _backgroundScrollView.scrollsToTop = NO;
    _backgroundScrollView.clipsToBounds = NO;
    [self insertSubview:_backgroundScrollView atIndex:0];
    NSMutableArray *scrollViewConstaint = @[].mutableCopy;
    [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:0.0f]];
    [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:0.0f]];
    [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f constant:0.0f]];
    [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:0.0f]];
    
    [self addConstraints:scrollViewConstaint];
    
}

- (void) initbackgroundContentView {
    _backgroundContentView = [[UIView alloc] initForAutolayout];
    _backgroundContentView.backgroundColor = [UIColor clearColor];
    [_backgroundScrollView addSubview:_backgroundContentView];
    NSMutableArray *contentViewConstaint = @[].mutableCopy;
    [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundContentView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_backgroundScrollView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0.0f]];
    [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundContentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_backgroundScrollView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:0.0f]];
    [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundContentView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_backgroundScrollView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f constant:0.0f]];
    [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundContentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_backgroundScrollView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f constant:0.0f]];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_backgroundContentView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:_imageArray.count
                                                                        constant:0.0f];
    [contentViewConstaint addObject:widthConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_backgroundContentView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0f constant:0.0f];
    [contentViewConstaint addObject:heightConstraint];
    [self addConstraints:contentViewConstaint];
    [self layoutIfNeeded];
    
    [_backgroundScrollView setContentSize:CGSizeMake(CGRectGetWidth(_backgroundContentView.frame), CGRectGetHeight(_backgroundContentView.frame))];
}

- (void) initImageViews {
    for (NSInteger i = 0; i < _imageArray.count; i++) {
        UIImageView *imageView          = [[UIImageView alloc] initForAutolayout];
        imageView.backgroundColor       = [UIColor whiteColor];
        imageView.layer.borderWidth     = 0.5f;
        imageView.layer.borderColor     = [UIColor colorWithHexString:kDiscussionSinglePageCardBorderColorHexString].CGColor;
        imageView.layer.shadowOffset    = CGSizeMake(1.0, 1.0);
        imageView.layer.shadowOpacity   = 0.2f;
        imageView.layer.shadowRadius    = 2.0f;
        imageView.clipsToBounds         = NO;
        [_backgroundContentView addSubview:imageView];
        
        NSMutableArray *imageConstaint = @[].mutableCopy;
        [imageConstaint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_backgroundContentView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0f
                                                                constant:(kScreenWidth - kDiscussionCardLeftAndRightPadding*2)*i+kDiscussionImageSlideViewInsideImagePadding / 2]];
        [imageConstaint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_backgroundContentView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0f constant:0.0f]];
        [imageConstaint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionImageSlideViewInsideImagePadding]];
        [imageConstaint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_backgroundContentView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0f constant:0.0f]];
        [self addConstraints:imageConstaint];
        
        
        if (_isUseImageFileName) {
            // Set image with name
            [imageView setImage:[UIImage imageNamed:_imageArray[i]]];
        }
        else if (_isUseImageUrl) {
            // Set image with url
            __block __typeof (UIImageView *) thisImageView = imageView;
            [imageView setImageWithURL:[NSURL URLWithString:_imageArray[i]]
                         withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderWide]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                        if (image) {
                                            float width       = kScreenWidth - kDiscussionCardLeftAndRightPadding*2 - kDiscussionImageSlideViewInsideImagePadding;
                                            float height      = self.bounds.size.height;
                                            float imageWidth  = image.size.width;
                                            float imageHeight = image.size.height;
                                            if (width/height > imageWidth/imageHeight) {
                                                CGRect rect  = CGRectMake(0, 0, width, imageHeight * width/imageWidth);
                                                UIGraphicsBeginImageContext(rect.size);
                                                [image drawInRect:rect];
                                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                                UIGraphicsEndImageContext();
                                                CGSize scaledSize = [scaledImage size];
                                                CGRect scaledRect = CGRectMake(0, (scaledSize.height-height)/2, width ,height);
                                                CGImageRef imageRef = CGImageCreateWithImageInRect([scaledImage CGImage], scaledRect);
                                                UIImage *img = [UIImage imageWithCGImage:imageRef];
                                                [thisImageView setImage:img];
                                                thisImageView.alpha = 0;
                                                [UIView animateWithDuration:0.3 animations:^(){
                                                    [thisImageView setImage:img];
                                                    thisImageView.alpha = 1;
                                                }];

                                            } else {
                                                CGRect rect  = CGRectMake(0, 0, imageWidth * height/imageHeight, height);
                                                UIGraphicsBeginImageContext(rect.size);
                                                [image drawInRect:rect];
                                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                                UIGraphicsEndImageContext();
                                                CGSize scaledSize = [scaledImage size];
                                                CGRect scaledRect = CGRectMake((scaledSize.width-width)/2, 0, width ,height);
                                                CGImageRef imageRef = CGImageCreateWithImageInRect([scaledImage CGImage], scaledRect);
                                                UIImage *img = [UIImage imageWithCGImage:imageRef];
                                                [thisImageView setImage:img];
                                                thisImageView.alpha = 0;
                                                [UIView animateWithDuration:0.3 animations:^(){
                                                    [thisImageView setImage:img];
                                                    thisImageView.alpha = 1;
                                                }];

                                            }
                                        } else {
                                            [thisImageView setImage:[UIImage imageNamed:@"image_placeholder_4x3"]];
                                        }
                                    }
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            
        }
        
    }
    
    [_backgroundScrollView scrollRectToVisible:CGRectMake(0, 0, kBoundsWidth, kBoundsHeight) animated:NO];
}


/* 使用範例
ImageSlideView *slide = [[ImageSlideView alloc] initWithImageFileNameArray:@[@"imageName",@"imageName",@"imageName",@"imageName"]];
slide.backgroundColor = [UIColor clearColor];
[self.view addSubview:slide];
NSMutableArray *scrollViewConstaint = @[].mutableCopy;
[scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:slide
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f constant:20.0f]];
[scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:slide
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f constant:0.0f]];
[scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:slide
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0f constant:-20.0f]];
[scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:slide
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:(kScreenWidth - 40 - 20) * (3.0f/4.0f)]];
[self.view addConstraints:scrollViewConstaint];
[slide initLayout];
*/
@end
