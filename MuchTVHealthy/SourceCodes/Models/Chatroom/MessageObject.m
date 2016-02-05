//
//  MessageObject.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "MessageObject.h"

@implementation MessageObject

- (id) initWithCurrentUser:(PFUser *)currentUser Content:(NSString *)content MessageType:(NSUInteger)messageType {
    if (self) {
        @try {
            NSDate *currentTime = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm";
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            NSString *sendTime = [dateFormatter stringFromDate:currentTime];
            
            _userId                 = currentUser.objectId;
            _content                = [content trimmedString];
            _sendTime               = sendTime;
            _messageType            = messageType;
        }
        @catch (NSException *exception) {
        }
        @finally {

        }
    }
    return self;
}


- (id) initWithReceivedMessage:(NSDictionary *)messageDictionary {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:messageDictionary[@"userID"]];
    NSArray *array = [query findObjects];
    for (PFObject *object in array) {
        PFFile *file = object[@"imageFile"];
        _senderName = object[@"displayName"];
        _senderPhoto = file.url;
    }
    if (self) {
        @try {
            _userId             = messageDictionary[@"userID"];
            _content            = messageDictionary[@"content"];
            _sendTime           = messageDictionary[@"sendTime"];
            _messageType        = [messageDictionary[@"messageType"] integerValue];
            _contentIndexPath   = [messageDictionary[@"messageID"] doubleValue];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;
}


@end


@implementation ChatroomListObject

- (id) initWithPFobject:(PFObject *)object currentLocation:(PFGeoPoint *)currentLocation {
    if (self) {
        @try {
            _chatroomID     = object.objectId;
            _chatroomName   = object[@"Name"];
            _distance       = [object[@"Distance"] integerValue];
            PFUser *creator = object[@"Creator"];
            PFFile *file    = creator[@"imageFile"];
            _creatorName    = creator[@"displayName"];
            _creatorPhoto   = file.url;
            _creatorID      = creator.objectId;
            _geoPoint       = object[@"Location"];
            _isCreated      = [object[@"isCreated"] boolValue];
            _range          = [currentLocation distanceInKilometersTo:_geoPoint];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;
}

@end
