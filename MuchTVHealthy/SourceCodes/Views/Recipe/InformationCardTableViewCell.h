//
//  InformationCardTableViewCell.h
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/8/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeObject.h"

@interface InformationCardTableViewCell : UITableViewCell
@property (nonatomic, strong) RecipeVideoObject     *recipeVideoObject;
@property (nonatomic, strong) NSString              *imageURL;
@property (nonatomic, strong) NSString              *videourl;
@property (nonatomic, strong) NSString              *title;
@property (nonatomic, strong) NSString              *createTime;
- (void) initVideoLayout;

@end
