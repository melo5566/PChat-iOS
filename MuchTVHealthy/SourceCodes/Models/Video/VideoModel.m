//
//  VideoModel.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "VideoModel.h"


@implementation VideoModel

- (void) loadVideoDataWithBlock :(VideoDataLoadingHandler)handler{
    // fake Kii data instead load kii data
    _videoFakeKiiArray  = @[].mutableCopy;
    for (int i=0;i<5;i++) {
        NSMutableDictionary   *videoFakeData = [[NSMutableDictionary alloc]init];
        [videoFakeData setValue:@"https://www.youtube.com/watch?v=ace-TXcX6GY" forKey:@"videoURL"];
        [videoFakeData setValue:@"2015/08/18 14:12" forKey:@"time"];
        [videoFakeData setValue:@"titleitleitletitletitleitleitletitletitleitleitletitle" forKey:@"title"];
        [_videoFakeKiiArray addObject:videoFakeData];
    }
    if(!_videoObject) {
        _videoObject = [[VideoObject alloc]init];
    }
    for (int i=0;i<3;i++) {
        VideoDataObject    *videoDataObject = [[VideoDataObject alloc]initWithDictionaryObject:_videoFakeKiiArray[i]];
        [_videoObject.videoList    addObject:videoDataObject];
    }
    BOOL hasMore;
    hasMore = NO;
    handler(_videoObject,hasMore);
}


@end
