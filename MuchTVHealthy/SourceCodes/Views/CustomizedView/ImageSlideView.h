//
//  ImageSlideView.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/17.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSlideView : UIView
- (id) initWithImageFileNameArray:(NSArray *)imageArray;
- (id) initWithImageUrlArray:(NSArray *)imageArray;

- (void) initLayout;
@end
