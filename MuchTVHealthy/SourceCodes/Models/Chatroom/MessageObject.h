//
//  MessageObject.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MessageObject : NSObject
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, strong) NSString          *sendTime;
@property (nonatomic, strong) NSString          *senderName;
@property (nonatomic, strong) NSString          *senderPhoto;
@property (nonatomic) NSUInteger                contentIndexPath;
@property (nonatomic, strong) NSString          *userId;
@property (nonatomic) NSUInteger                messageType;
- (id)initWithReceivedMessage:(NSDictionary *)messageDictionary;
- (id)initWithCurrentUser:(PFUser *)currentUser Content:(NSString *)content MessageType:(NSUInteger)messageType;
@end


@interface ChatroomListObject : NSObject
@property (nonatomic, strong) NSString      *chatroomID;
@property (nonatomic, strong) NSString      *chatroomName;
@property (nonatomic) NSUInteger            distance;
@property (nonatomic, strong) NSString      *creatorName;
@property (nonatomic, strong) NSString      *creatorPhoto;
@property (nonatomic, strong) NSString      *creatorID;
@property (nonatomic) BOOL                  isCreated;
@property (nonatomic, strong) PFGeoPoint    *geoPoint;
@property (nonatomic) float            range;
- (id)initWithPFobject:(PFObject *)object currentLocation:(PFGeoPoint *)currentLocation;
@end