//
//  VideoObject.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "VideoObject.h"

@implementation VideoObject



- (id) init {
    self = [super init];
    _videoList = [[NSMutableArray alloc] init];
    return self;
}

@end


@implementation VideoDataObject

- (id) initWithDictionaryObject:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        _videoURL   = isNotNullValue([data valueForKey:@"videoURL"])?[data valueForKey:@"videoURL"]:@"";
        _time       = isNotNullValue([data valueForKey:@"time"])?[data valueForKey:@"time"]:@"";
        _imageURL   = [_videoURL getYoutubeVieoMqDefaultImage];
        _title      = isNotNullValue([data valueForKey:@"title"])?[data valueForKey:@"title"]:@"";
    }
    return self;
}


@end