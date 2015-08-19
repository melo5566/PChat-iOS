//
//  RecommendTableViewCell.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/18.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnoisseurObject.h"

@interface RecommendTableViewCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray                     *recommendList;
@property (nonatomic) BOOL                                      hasMoreRecommend;
@property (nonatomic,strong) ConnoisseurRecommendDataObject    *connoisseurRecommendDataObject;

@end
