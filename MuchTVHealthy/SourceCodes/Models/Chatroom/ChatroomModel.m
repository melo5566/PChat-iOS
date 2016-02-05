//
//  ChatroomModel.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/16.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ChatroomModel.h"
#import "MessageObject.h"
#import <Parse/Parse.h>
#import "UserModel.h"


@implementation ChatroomModel

- (void)uploadImageWithBlock:(NSData *)imageData completeBlock:(UploadImageWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        PFObject *object = [PFObject objectWithClassName:@"Image"];
        object[@"imageFile"] = imageFile;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                PFFile *file = object[@"imageFile"];
                handler(file.url);
            } else {
                NSLog(@"Error!");
            }
        }];
    }];
}

- (void)deleteImageWithBlock:(DeleteImageWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        PFObject *image = [PFObject objectWithClassName:@"Image"];
        [image removeObjectForKey:@"imageFile"];
        [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                handler();
            } else {
                NSLog(@"%@",[error userInfo]);
            }
        }];
    }];
}

- (void)loadChatroomListWithBlock:(PFGeoPoint *)currentLocation completeBlock:(LoadChatroomListWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^ {
        PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
        [query includeKey:@"Creator"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSMutableArray *array = @[].mutableCopy;
                for (PFObject *object in objects) {
                    ChatroomListObject *chatroomObject = [[ChatroomListObject alloc] initWithPFobject:object currentLocation:currentLocation];
                    if ([[PFUser currentUser].objectId isEqualToString:chatroomObject.creatorID])
                        [array addObject:chatroomObject];
                    else {
                        if ([currentLocation distanceInKilometersTo:chatroomObject.geoPoint]*1000 < chatroomObject.distance)
                            [array addObject:chatroomObject];
                    }
                }
                handler(array);
            } else {
                NSLog(@"%@",[error userInfo]);
            }
        }];
        
    }];
}

- (void)createChatroomWithBlock:(NSString *)chatroomName
                       distance:(NSUInteger)distance
                        creator:(PFUser *)creator
                       geoPoint:(PFGeoPoint *)geoPoint
                  completeBlock:(CreateChatroomWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        PFObject *object = [PFObject objectWithClassName:@"Chatroom"];
        object[@"Name"] = chatroomName;
        object[@"Creator"] = creator;
        object[@"Location"] = geoPoint;
        object[@"Distance"] = @(distance);
        object[@"isCreated"] = @NO;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                creator[@"chatroomID"] = object.objectId;
                [creator saveInBackground];
                handler();
            } else {
                NSLog(@"%@",[error userInfo]);
            }
        }];
    }];
}

- (void)setChatroomIsCreatedWithBlock:(NSString *)chatroomID completeBlock:(CreateChatroomWithBlock )handler {
    [self checkNetworkReachabilityAndDoNext:^{
        PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
        [query getObjectInBackgroundWithId:chatroomID
                                     block:^(PFObject *object, NSError *error) {
                                         object[@"isCreated"] = @YES;
                                         [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                             if (succeeded) {
                                                 handler();
                                             } else {
                                                 NSLog(@"%@",[error userInfo]);
                                             }
                                         }];
        }];
    }];
}

- (void)getOwnChatroomDataWithBlock:(NSString *)chatroomID completeBlock:(GetOwnChatroomDataWithBlock )handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
        [query getObjectInBackgroundWithId:chatroomID block:^(PFObject *object, NSError *error) {
            if (!error) {
                handler([NSString stringWithFormat:object[@"Name"]], [object[@"Distance"] integerValue]);
            } else {
                NSLog(@"%@",[error userInfo]);
            }
        }];
    }];
}

- (void)updateChatroomDataWithBlock:(NSString *)chatroomName
                           distance:(NSUInteger)distance
                         chatroomID:(NSString *)chatroomID
                           geoPoint:(PFGeoPoint *)geoPoint
                      completeBlock:(CreateChatroomWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
        [query getObjectInBackgroundWithId:chatroomID block:^(PFObject *object, NSError *error) {
            if (!error) {
                object[@"Name"] = chatroomName;
                object[@"Distance"] = @(distance);
                object[@"Location"] = geoPoint;
                [object saveInBackground];
                handler();
            } else {
                NSLog(@"%@",[error userInfo]);
            }
        }];
    }];
}

- (void)deleteChatroomWithBlock:(PFUser *)creator completeBlock:(CreateChatroomWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
        [query whereKey:@"Creator" equalTo:creator];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    creator[@"chatroomID"] = @"";
                    [creator saveInBackground];
                    [object deleteInBackground];
                    handler();
                }
            } else {
                NSLog(@"%@",[error userInfo]);
            }
        }];
    }];
}

@end
