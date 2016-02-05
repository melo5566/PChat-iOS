//
//  SignUpAndSignInModel.h
//  493_Project
//
//  Created by Peter on 2015/10/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseModel.h"
#import <Parse/Parse.h>

@protocol SignUpAndSignInModelDelegate <BaseModelDelegate>
@optional
@end


typedef enum facebookLogInStatus : NSUInteger {
    facebookLogInStatusUserCanceled = 0,
    facebookLogInStatusNewUser,
    facebookLogInStatusLoggedIn,
    facebookLogInStatusFailedToGetUserFacebookData,
    facebookLogInStatusFailedToLoggIn
} facebookLogInStatus;

@interface SignUpAndSignInModel : BaseModel
typedef void (^SignUpAndSignInHandler)(PFUser *user, NSError *error);
//typedef void (^SignUpAndSignInHandler)(KiiUser *user, NSError *error);
typedef void (^CheckUserAvatarHandler)(BOOL hasAvatar, NSError *error);
typedef void (^GetAvatarAndNameHandler)(BOOL finished, NSError *error);
typedef void (^GetResetPassswordCodeHandler)(NSError *error);

@property (nonatomic, weak) id <SignUpAndSignInModelDelegate> delegate;

- (void) parseUserSignUp:(NSString *)displayName
               account:(NSString *)account
              password:(NSString *)password
         CompleteBlock:(SignUpAndSignInHandler)handler;

@end
