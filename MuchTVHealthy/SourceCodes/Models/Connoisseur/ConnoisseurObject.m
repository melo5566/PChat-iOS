//
//  ConnoiseurObject.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/12.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ConnoisseurObject.h"

@implementation ConnoisseurDataObject

- (id) initWithDictionaryobject:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
     _connoisseurName     = isNotNullValue([data valueForKey:@"ConnoisseurName"])?[data valueForKey:@"ConnoisseurName"]:@"";
     _connoisseurSubtitle = isNotNullValue([data valueForKey:@"ConnoisseurSubtitle"])?[data valueForKey:@"ConnoisseurSubtitle"]:@"";
     _imageUrl            = isNotNullValue([data valueForKey:@"ConnoisseurImage"])?[data valueForKey:@"ConnoisseurImage"]:@"";
    }
    return self;
}


@end

@implementation ConnoisseurObject

- (id) init {
    self = [super init];
    _dataArray = [[NSMutableArray alloc] init];
    return self;
}
@end