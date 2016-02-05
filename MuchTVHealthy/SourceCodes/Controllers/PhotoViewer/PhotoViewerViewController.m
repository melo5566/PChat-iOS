//
//  PhotoViewerViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/5.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "PhotoViewerViewController.h"

@interface PhotoViewerViewController ()
@property (nonatomic, strong) UIImageView           *imageView;
@end

@implementation PhotoViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    if ([_type isEqualToString:@"avatar"])
        self.title = _messageObject.senderName;
    else
        self.title = @"Image";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initForAutolayout];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.layer.borderWidth = 1;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.layer.cornerRadius = 5;
        [self.view addSubview:_imageView];
        
        NSMutableArray *imageViewConstaint = @[].mutableCopy;
        
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:0.0f]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0f constant:0.0f]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:0.0f]];
        [imageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f constant:300.0f]];
        
        [self.view addConstraints:imageViewConstaint];
    }
    if ([_type isEqualToString:@"avatar"]) {
        __block __typeof (UIImageView *) avatar = _imageView;
        [_imageView setImageWithURL:[NSURL URLWithString:_messageObject.senderPhoto]
               withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                              if (image) {
                                  avatar.alpha = 0;
                                  [UIView animateWithDuration:0.3 animations:^(){
                                      avatar.alpha = 1;
                                  }];
                              }
                              else {
                                  [avatar setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                              }
                          }
        usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    } else {
        __block __typeof (UIImageView *) avatar = _imageView;
        [_imageView setImageWithURL:[NSURL URLWithString:_messageObject.content]
               withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                              if (image) {
                                  avatar.alpha = 0;
                                  [UIView animateWithDuration:0.3 animations:^(){
                                      avatar.alpha = 1;
                                  }];
                              }
                              else {
                                  [avatar setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                              }
                          }
        usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
}

@end
