//
//  DiscussionObject.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/25.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DiscussionObject.h"

@implementation DiscussionObject
- (id)initWithPFObject:(PFObject *)object {
    if (self) {
        @try {
            PFUser *user = object[@"Author"];
            PFFile *file = user[@"imageFile"];
            _authorName    = user[@"displayName"];
            _title         = object[@"Title"];
            _content       = object[@"Content"];
            _imageArray    = object[@"ImageArray"];
            _authorPhoto   = file.url;
            _objectID      = object.objectId;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"TZ"]];
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:object.createdAt];
            _createTime = strDate;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;
}
@end

@implementation ReplyObject
- (id)initWithPFObject:(PFObject *)object {
    if (self) {
        @try {
            PFUser *user = object[@"Author"];
            PFFile *file = user[@"imageFile"];
            _authorName    = user[@"displayName"];
            _content       = object[@"Content"];
            _authorPhoto   = file.url;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"TZ"]];
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:object.createdAt];
            _createTime = strDate;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;
}
@end

@implementation WorkloadObject

- (id)initWithPFObject:(PFObject *)object {
    if (self) {
        @try {
            _course         = object[@"Course"];
            _department     = object[@"Department"];
            _season         = object[@"Season"];
            _year           = object[@"Year"];
            _courseID       = object.objectId;
            _light          = [object[@"Light"] integerValue];
            _moderate       = [object[@"Moderate"] integerValue];
            _heavy          = [object[@"Heavy"] integerValue];
            _exHeavy        = [object[@"Extremely_Heavy"] integerValue];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;

}

@end

@implementation CategoryObject

- (id)initWithPFObject:(PFObject *)object {
    if (self) {
        @try {
            PFFile *file = object[@"Image"];
            _category       = object[@"Category"];
            _name           = object[@"Name"];
            _imageUrl       = file.url;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;
    
}

@end
