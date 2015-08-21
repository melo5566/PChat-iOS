//
//  InformationIntroductionViewCell.h
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/8/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeObject.h"
@protocol InformationIntroductionViewDelegate<NSObject>
@optional
- (void)likeClicked:(id) sender;
- (void)shareClicked:(id) sender;
@end

@interface InformationIntroductionView : UIView
@property (nonatomic) CGFloat                                   labelHeight;
@property (nonatomic, strong) NSString                          *pictureurl;
@property (nonatomic, strong) NSString                          *titleContent;
@property (nonatomic, strong) NSString                          *title;
@property (nonatomic, strong) RecipeIntroductionObject *introductionObject;
@property (nonatomic, strong) RecipePictureObject *recipePictureObject;
@property (nonatomic, weak) id <InformationIntroductionViewDelegate> delegate;

- (void) initLayoutWithPictureAndButtons;
- (void) initLayout;
@end
