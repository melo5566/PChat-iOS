//
//  FacebookTableViewCell.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/19.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnoisseurObject.h"

@interface FacebookTableViewCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray                     *facebookList;
@property (nonatomic) BOOL                                      hasMoreFacebook;
@property (nonatomic,strong) ConnoisseurFacebookDataObject      *connoisseurFacebookDataObject;

@end
