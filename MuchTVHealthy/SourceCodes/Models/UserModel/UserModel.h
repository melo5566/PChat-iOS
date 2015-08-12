//
//  UserModel.h
//  North7
//
//  Created by Weiyu Chen on 2015/6/28.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseModel.h"

@protocol UserModelDelegate <BaseModelDelegate>

@optional
- (void) didUpdateUserAvatarWithImageData:(NSData *)imageData;
- (void) didUpdateUserAvatar;
- (void) didUpdateUserName;
@end



@interface UserModel : BaseModel
@property (nonatomic, weak) id <UserModelDelegate> delegate;
- (void) uploadAvatar:(NSData *)avatarImageData ForUser:(KiiUser *)user;
- (void) updateUsername:(NSString *)username ForUser:(KiiUser *)user;
@end
