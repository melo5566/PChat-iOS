//
//  VideoListViewController.h
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/8/5.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoModel.h"
#import "VideoObject.h"

@interface VideoListViewController : BaseViewController
@property (nonatomic,strong) VideoModel         *videoModel;
@property (nonatomic,strong) VideoObject        *videoObject;

@end
