//
//  VideoObject.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoObject : NSObject

@property (nonatomic,strong) NSMutableArray             *videoList;

@end


@interface VideoDataObject : NSObject

@property (nonatomic, strong) NSString  *videoURL;
@property (nonatomic, strong) NSString  *time;
@property (nonatomic, strong) NSString  *imageURL;
@property (nonatomic, strong) NSString  *title;

- (id) initWithDictionaryObject:(NSMutableDictionary *)data ;
@end
