//
//  ConnoisseurSingleViewController.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/14.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseViewController.h"
#import "ConnoisseurObject.h"
#import "ConnoisseurModel.h"
#import "ConnoisseurImageTableViewCell.h"
#import "RelativeDiscussionTableViewCell.h"
#import "AboutTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "FacebookTableViewCell.h"

@interface ConnoisseurSingleViewController : BaseViewController
@property (nonatomic,strong)ConnoisseurDataObject       *connoisseurDataObject;
@end
