//
//  VideoModel.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseModel.h"
#import "VideoObject.h"

@interface VideoModel : BaseModel
typedef void (^VideoDataLoadingHandler)(VideoObject *connoissuerObject, BOOL hasMore);

@property (nonatomic,strong) NSMutableArray             *videoFakeKiiArray;
@property (nonatomic,strong) VideoObject                *videoObject;

- (void) loadVideoDataWithBlock:(VideoDataLoadingHandler)handler;

@end
