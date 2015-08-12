//
//  SignUpAndSignInModel.h
//  North7
//
//  Created by Weiyu Chen on 2015/4/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseModel.h"

@protocol SignUpAndSignInModelDelegate <BaseModelDelegate>
@optional
- (void) didLogin;
- (void) didSignUp;
@end


typedef enum facebookLogInStatus : NSUInteger {
    facebookLogInStatusUserCanceled = 0,
    facebookLogInStatusNewUser,
    facebookLogInStatusLoggedIn,
    facebookLogInStatusFailedToGetUserFacebookData,
    facebookLogInStatusFailedToLoggIn
} facebookLogInStatus;

@interface SignUpAndSignInModel : BaseModel
typedef void (^FacebookLogInHandler)(facebookLogInStatus logInStatus, KiiUser *user);
typedef void (^CheckUserAvatarHandler)(BOOL hasAvatar, NSError *error);
typedef void (^GetAvatarAndNameHandler)(BOOL finished, NSError *error);

@property (nonatomic, weak) id <SignUpAndSignInModelDelegate> delegate;
- (void) kiiUserLogIn:(NSString *)account password:(NSString *)password;
- (void) kiiUserSignUp:(NSString *)displayName account:(NSString *)account password:(NSString *)password;
- (void) facebookLogInInWithReadPermissions:(NSArray *)permissionsArray
                              completeBlock:(FacebookLogInHandler)handler;

//- (void) facebookLogInInBackgroundWithReadPermissions:(NSArray *)permissionsArray
//                                        completeBlock:(LogInHandler)handler;
- (void) GetUsernameAndAvatarOfUser:(KiiUser *)user
                      completeBlock:(GetAvatarAndNameHandler)handler;
@end
