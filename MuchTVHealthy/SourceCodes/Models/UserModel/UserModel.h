//
//  UserModel.h
//  493_Project
//
//  Created by Peter on 2015/10/28.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseModel.h"
#import <Parse/Parse.h>

@protocol UserModelDelegate <BaseModelDelegate>

@optional
- (void) didUpdateUserAvatarWithImageData:(NSData *)imageData;
@end



@interface UserModel : BaseModel

typedef void (^UploadAvatarWithBlock)(NSString *userAvatarUrl);
typedef void (^UpdateUserNameWithBlock)(void);
typedef void (^UpdateFavoritesWithBlock)(BOOL isExist);
typedef void (^LoadFavoriteWithBlock)(NSArray *array);
typedef void (^QueryUserWithBlock)(PFObject *object);
typedef void (^DeleteFromMyFavoriteWithBlock)(void);

@property (nonatomic, weak) id <UserModelDelegate> delegate;


- (void) uploadAvatarWithBlock:(NSData *)avatarImageData ForUser:(PFUser *)user completeBlock:(UploadAvatarWithBlock )handler;
- (void) updateUsername:(NSString *)username ForUser:(PFUser *)user completeBlock:(UpdateUserNameWithBlock )handler;
- (void) updateFavorites:(NSString *)category ForUser:(PFUser *)user completeBlock:(UpdateFavoritesWithBlock )handler;
- (void) loadFavoriteWithBlock:(PFUser *)user completeBlock:(LoadFavoriteWithBlock )handler;
- (void) queryUserWithBlock:(NSString *)userID completeBlock:(QueryUserWithBlock )handler;
- (void) deleteFromMyFavorite:(PFUser *)user category:(NSString *)category completeBlock:(DeleteFromMyFavoriteWithBlock )handler;
@end
