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
@end


typedef enum facebookLogInStatus : NSUInteger {
    facebookLogInStatusUserCanceled = 0,
    facebookLogInStatusNewUser,
    facebookLogInStatusLoggedIn,
    facebookLogInStatusFailedToGetUserFacebookData,
    facebookLogInStatusFailedToLoggIn
} facebookLogInStatus;

@interface SignUpAndSignInModel : BaseModel
typedef void (^PhoneNumberSignUpAndSignInHandler)(KiiUser *user, NSError *error);
typedef void (^SignUpAndSignInHandler)(KiiUser *user, NSError *error);
typedef void (^FacebookLogInHandler)(facebookLogInStatus logInStatus, KiiUser *user);
typedef void (^CheckUserAvatarHandler)(BOOL hasAvatar, NSError *error);
typedef void (^GetAvatarAndNameHandler)(BOOL finished, NSError *error);
typedef void (^GetResetPassswordCodeHandler)(NSError *error);

@property (nonatomic, weak) id <SignUpAndSignInModelDelegate> delegate;
- (void) kiiUserLogIn:(NSString *)account password:(NSString *)password;

- (void) kiiUserLogIn:(NSString *)account
             password:(NSString *)password
        CompleteBlock:(SignUpAndSignInHandler)handler;

- (void) kiiUserSignUp:(NSString *)displayName
               account:(NSString *)account
              password:(NSString *)password
         CompleteBlock:(SignUpAndSignInHandler)handler;

- (void) verifyPhoneNumberWithCode:(NSString *)code
                 WithCompleteBlock:(PhoneNumberSignUpAndSignInHandler)handler;

- (void) resendPhoneVerificationCodeWithCompleteBlock:(PhoneNumberSignUpAndSignInHandler)handler;

- (void) facebookLogInInWithReadPermissions:(NSArray *)permissionsArray
                              completeBlock:(FacebookLogInHandler)handler;

- (void) signUpWithPhoneNumber:(NSString *)displayName
                       phoneNumber:(NSString *)phoneNumber
                      password:(NSString *)password
                 CompleteBlock:(PhoneNumberSignUpAndSignInHandler)handler;

- (void) getResetPasswordCodeByPhoneNumber:(NSString *)phoneNumber CompleteBlock:(GetResetPassswordCodeHandler)handler;

- (void) updatePassword:(NSString *)prePassword
                    New:(NSString *)newPassword
                    CompleteBlock:(PhoneNumberSignUpAndSignInHandler)handler;

//- (void) facebookLogInInBackgroundWithReadPermissions:(NSArray *)permissionsArray
//                                        completeBlock:(LogInHandler)handler;
- (void) GetUsernameAndAvatarOfUser:(KiiUser *)user
                      completeBlock:(GetAvatarAndNameHandler)handler;
@end
