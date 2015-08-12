//
//  ImageSlideView.h
//  FaceNews
//
//  Created by Weiyu Chen on 2015/7/17.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSlideView : UIView
- (id) initWithImageFileNameArray:(NSArray *)imageArray;
- (id) initWithImageUrlArray:(NSArray *)imageArray;

- (void) initLayout;
@end
