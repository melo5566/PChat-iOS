//
//  UserModel.m
//  North7
//
//  Created by Weiyu Chen on 2015/6/28.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@dynamic delegate;

- (void) uploadAvatar:(NSData *)avatarImageData ForUser:(KiiUser *)user {
    [self checkNetworkReachabilityAndDoNext:^{
        // Create User Scope Bucket
        KiiBucket *userbucket = [user bucketWithName:@"photoUser"];
        KiiObject *object = [userbucket createObject];
        
        // Save KiiObject
        [object saveWithBlock:^(KiiObject *createdObject, NSError *error) {
            if (error != nil) {
                if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
                    [self.delegate hasNoNetworkConnection];
                }
                return;
            }
            
            // Upload object body
            [createdObject uploadBodyWithData:avatarImageData
                               andContentType:@"image/jpeg"
                                andCompletion:^(KiiObject *bodyUploadedObject, NSError *error) {
                                    if (error != nil) {
                                        if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
                                            [self.delegate hasNoNetworkConnection];
                                        }
                                        return;
                                    }
                                    
                                    // publish and get url
                                    [bodyUploadedObject publishBodyWithBlock:^(KiiObject *obj, NSString *url, NSError *error) {
                                        if (error != nil) {
                                            if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
                                                [self.delegate hasNoNetworkConnection];
                                            }
                                            return;
                                        }
                                        
                                        KiiUserFields *userFields = [[KiiUserFields alloc] init];
                                        [userFields setObject:url forKey:@"avatar"];
                                        
                                        [user updateWithUserFields:userFields block:^(KiiUser *user, NSError *error) {
                                            if (error != nil) {
                                                if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
                                                    [self.delegate hasNoNetworkConnection];
                                                }
                                                return;
                                            }
                                            if ([self.delegate respondsToSelector:@selector(didUpdateUserAvatarWithImageData:)]) {
                                                [self.delegate didUpdateUserAvatarWithImageData:avatarImageData];
                                            }
                                        }];
                                    }];
                                }];
        }];
    }];
}

- (void) updateUsername:(NSString *)username ForUser:(KiiUser *)user {
    [self checkNetworkReachabilityAndDoNext:^{
        KiiUserFields *userFields = [[KiiUserFields alloc] init];
        [userFields setDisplayName:username];
        
        [user updateWithUserFields:userFields block:^(KiiUser *user, NSError *error) {
            if (error != nil) {
                if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
                    [self.delegate hasNoNetworkConnection];
                }
                return;
            }
            
            if ([self.delegate respondsToSelector:@selector(didUpdateUserName)]) {
                [self.delegate didUpdateUserName];
            }
        }];
    }];
}
@end
