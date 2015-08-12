//
//  FrontpageObject.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "FrontpageObject.h"

@implementation FrontpageObject
- (id) initWithKiiObject:(KiiObject *)kiiobject {
    if (self) {
        @try {
            _imageUrl = isNotNullValue([kiiobject getObjectForKey:@"image"]) ? [kiiobject getObjectForKey:@"image"] : @"";
            _title    = isNotNullValue([kiiobject getObjectForKey:@"content"]) ? [kiiobject getObjectForKey:@"content"] : @"";
            _link     = isNotNullValue([kiiobject getObjectForKey:@"link"]) ? [kiiobject getObjectForKey:@"link"] : @"";
            
            NSTimeInterval _interval = [[kiiobject getObjectForKey:@"date"] doubleValue]/1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"TZ"]];
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:date]; // to string
            _time = strDate;
            
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
    return self;
}
@end
