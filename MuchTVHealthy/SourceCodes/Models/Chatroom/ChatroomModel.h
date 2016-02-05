//
//  ChatroomModel.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/16.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <Parse/Parse.h>

@interface ChatroomModel : BaseModel

typedef void (^UploadImageWithBlock)(NSString *imageUrl);
typedef void (^DeleteImageWithBlock)(void);
typedef void (^LoadChatroomListWithBlock)(NSArray *chatroomListArray);
typedef void (^CreateChatroomWithBlock)(void);
typedef void (^GetOwnChatroomDataWithBlock)(NSString *chatroomName, NSUInteger distance);
- (void) uploadImageWithBlock:(NSData *)imageData completeBlock:(UploadImageWithBlock )handler;
- (void) deleteImageWithBlock:(DeleteImageWithBlock )handler;
- (void) loadChatroomListWithBlock:(PFGeoPoint *)currentLocation completeBlock:(LoadChatroomListWithBlock )handler;
- (void) createChatroomWithBlock:(NSString *)chatroomName
                        distance:(NSUInteger )distance
                         creator:(PFUser *)creator
                        geoPoint:(PFGeoPoint *)geoPoint
                   completeBlock:(CreateChatroomWithBlock )handler;
- (void) setChatroomIsCreatedWithBlock:(NSString *)chatroomID completeBlock:(CreateChatroomWithBlock )handler;
- (void) getOwnChatroomDataWithBlock:(NSString *)chatroomID completeBlock:(GetOwnChatroomDataWithBlock )handler;
- (void) updateChatroomDataWithBlock:(NSString *)chatroomName
                            distance:(NSUInteger )distance
                          chatroomID:(NSString *)chatroomID
                            geoPoint:(PFGeoPoint *)geoPoint
                       completeBlock:(CreateChatroomWithBlock )handler;
- (void) deleteChatroomWithBlock:(PFUser *)creator completeBlock:(CreateChatroomWithBlock )handler;
@end
