//
//  SignUpAndSignInModel.m
//  North7
//
//  Created by Weiyu Chen on 2015/4/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "SignUpAndSignInModel.h"
#import "AppDelegate.h"


@interface SignUpAndSignInModel ()
@property (nonatomic, strong) FBSDKGraphRequest             *graphRequest;
@property (nonatomic, strong) FBSDKGraphRequestConnection   *graphRequestConnection;
@property (nonatomic, strong) AppDelegate                   *appDelegate;
@end

@implementation SignUpAndSignInModel
@dynamic delegate;

- (id) init {
    self = [super init];
    if (self) {
        _appDelegate = [UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void) kiiUserLogIn:(NSString *)account
             password:(NSString *)password
        CompleteBlock:(SignUpAndSignInHandler)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        [KiiUser authenticate:account
                 withPassword:password
                     andBlock:^(KiiUser *user, NSError *error) {
                         handler(user, error);
                     }];

    }];
}

- (void) kiiUserSignUp:(NSString *)displayName
               account:(NSString *)account
              password:(NSString *)password
         CompleteBlock:(SignUpAndSignInHandler)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        KiiUser *user = [KiiUser userWithUsername:account
                                      andPassword:password];
        [user setDisplayName:displayName];
        [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
            handler(user, error);
        }];
    }];

}

- (void) signUpWithPhoneNumber:(NSString *)displayName
                   phoneNumber:(NSString *)phoneNumber
                      password:(NSString *)password
                 CompleteBlock:(PhoneNumberSignUpAndSignInHandler)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        NSString *phoneNumberWithCode = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"+886"];
        
        KiiUser *user = [KiiUser userWithUsername:phoneNumber
                                   andPhoneNumber:phoneNumberWithCode
                                      andPassword:password];
        [user setDisplayName:displayName];
        [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
            handler(user, error);
        }];
    }];
}

- (void) verifyPhoneNumberWithCode:(NSString *)code
                 WithCompleteBlock:(PhoneNumberSignUpAndSignInHandler)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        KiiUser *user = [KiiUser currentUser];
        [user verifyPhoneNumber:code
                      withBlock:^(KiiUser *verifiedUser, NSError *error) {
                          if (error != nil) {
                              // Error handling
                              handler(verifiedUser, error);
                              return;
                          }
                          handler(verifiedUser, error);
                      }];
    }];
}

- (void) resendPhoneVerificationCodeWithCompleteBlock:(PhoneNumberSignUpAndSignInHandler)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        KiiUser *currentUser = [KiiUser currentUser];
        [currentUser resendPhoneNumberVerificationWithBlock:^(KiiUser *user, NSError *error) {
            handler(user, error);
        }];
    }];
}

- (void) getResetPasswordCodeByPhoneNumber:(NSString *)phoneNumber CompleteBlock:(GetResetPassswordCodeHandler)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        NSString *phoneNumberWithCode = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"+886"];
        [KiiUser resetPassword:phoneNumberWithCode
            notificationMethod:KiiSMS
                         block:^(NSError *error) {
                             handler(error);
                         }];
    }];
}

- (void) updatePassword:(NSString *)prePassword
                    New:(NSString *)newPassword
          CompleteBlock:(PhoneNumberSignUpAndSignInHandler)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        KiiUser *currentUser = [KiiUser currentUser];
        [currentUser updatePassword:prePassword to:newPassword withBlock:^(KiiUser *user, NSError *error) {
            handler(user, error);
        }];
    }];
}


- (void) facebookLogInInWithReadPermissions:(NSArray *)permissionsArray
                              completeBlock:(FacebookLogInHandler)handler {
    [KiiSocialConnect setupNetwork:kiiSCNFacebook
                           withKey:kFacebookID
                         andSecret:nil
                        andOptions:nil];
    
    // Setting the permission for fetching email address from Facebook using iOS native FB account
    NSDictionary *options = @{@"permissions": @[@"email"],
                              @"use_acaccount": @NO };
    
    // Login with the Facebook Account.
    [KiiSocialConnect logIn:kiiSCNFacebook
               usingOptions:options
                   andBlock:^(KiiUser *retUser, KiiSocialNetworkName retNetwork, NSError *retError) {
                       if (!retError && retUser) {
                           [kUserDefault setObject:retUser.accessToken forKey:kKiiUserAccessTokenUserDefaultKey];
                           
                           BOOL isNewUser = [[retUser getObjectForKey:@"new_user_created"] boolValue];
                           if (isNewUser) {
                               NSLog(@"# New User");
                               [self GetUsernameAndAvatarOfUser:retUser completeBlock:^(BOOL finished, NSError *error) {
                                   handler(facebookLogInStatusNewUser, retUser);
                               }];
                           }
                           else {
                               NSLog(@"# Not New User");
                               handler(facebookLogInStatusLoggedIn, retUser);
                           }
                           
                       }
                       else {
                           NSLog(@"ERROR CODE : %ld", (long)retError.code);
                           
                       }
                   }];
}

- (void) facebookLogInInBackgroundWithReadPermissions:(NSArray *)permissionsArray
                                        completeBlock:(FacebookLogInHandler)handler {

// NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    // Login PFUser using Facebook
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        if (!error) {
//            if (!user) {
//                NSLog(@"Uh oh. The user cancelled the Facebook login.");
//                handler(facebookLogInStatusUserCanceled, user);
//            } else if (user.isNew) {
//                NSLog(@"User signed up and logged in through Facebook!");
//                [self GetUsernameAndAvatarOfUser:user completeBlock:^(BOOL finished, NSError *error) {
//                    if (finished && !error) {
//                        [_appDelegate addUserToCurrentInstallation];
//                        [self setBadgeAndReadMessageForNewUser:user];
//                        handler(facebookLogInStatusNewUser, user);
//                    }
//                    else {
//                        handler(facebookLogInStatusFailedToGetUserFacebookData, user);
//                    }
//                }];
//            } else {
//                NSLog(@"User logged in through Facebook!");
//                [_appDelegate addUserToCurrentInstallation];
//                [_appDelegate saveLocalBadgeNumer:[user[@"badge"] integerValue]];
//                [_appDelegate saveParseInstallationBadge:[user[@"badge"] integerValue]];
//                [self checkNoDataUser:user];
//                handler(facebookLogInStatusLoggedIn, user);
//            }
//        }
//        else {
//            handler(facebookLogInStatusFailedToLoggIn, user);
//        }
//    }];
    
    
    
//    if ([KiiUser currentUser]) {
//        [KiiUser logOut];
//        NSLog(@"# LOG OUT");
//    }
    
    [KiiSocialConnect setupNetwork:kiiSCNFacebook
                           withKey:kFacebookID
                         andSecret:nil
                        andOptions:nil];

    // Setting the permission for fetching email address from Facebook using iOS native FB account
    NSDictionary *options = @{@"permissions": @[@"email"],
                              @"use_acaccount": @NO };
    
    // Login with the Facebook Account.
    [KiiSocialConnect logIn:kiiSCNFacebook
               usingOptions:options
                   andBlock:^(KiiUser *retUser, KiiSocialNetworkName retNetwork, NSError *retError) {
                       if (!retError && retUser) {
                           [kUserDefault setObject:retUser.accessToken forKey:kKiiUserAccessTokenUserDefaultKey];
                           
                           BOOL isNewUser = [[retUser getObjectForKey:@"new_user_created"] boolValue];
                           if (isNewUser) {
                               NSLog(@"# New User");
                               [self GetUsernameAndAvatarOfUser:retUser completeBlock:^(BOOL finished, NSError *error) {
                                   
                               }];
                           }
                           else {
                               NSLog(@"# Not New User");
                           }

                       }
                       else {
                           NSLog(@"ERROR CODE : %ld", (long)retError.code);

                       }
                   }];
}

- (void) checkUserAvatar:(KiiUser *)user withBlock:(CheckUserAvatarHandler)handler {
    KiiBucket *userPhotoBucket = [user bucketWithName:@"photoUser"];
    // Build "all" query
    KiiQuery *allQuery = [KiiQuery queryWithClause:nil];
    // Get an array of KiiObjects by querying the bucket
    [userPhotoBucket executeQuery:allQuery
                        withBlock:^(KiiQuery *query, KiiBucket *bucket, NSArray *results, KiiQuery *nextQuery, NSError *error) {
                            if (!error && isNotNullValue(results)) {
                                if (results.count == 0) {
                                    handler(NO, error);
                                }
                                else {
                                    handler(YES, error);
                                }
                            }
                            else {
                                NSLog(@"# fail to checkUserAvatar");
                            }
                        }];
}

- (void) GetUsernameAndAvatarOfUser:(KiiUser *)user completeBlock:(GetAvatarAndNameHandler)handler{
    // Get username and avatar
    _graphRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                      parameters:@{@"fields": @"id, name, picture.height(200).width(200), email"}];
    [_graphRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (result && !error) {
            NSLog(@"RESULT:%@",result);
            KiiIdentityDataBuilder *builder = [[KiiIdentityDataBuilder alloc] init];
            builder.email = result[@"email"];
            NSError *error = nil;
            KiiIdentityData *identityData = [builder buildWithError:&error];
            
            KiiUserFields *userFields = [[KiiUserFields alloc] init];
            
            // facebook頭像不是預設頭像才存
            if (![result[@"picture"][@"data"][@"is_silhouette"] boolValue]) {
                [userFields setObject:result[@"picture"][@"data"][@"url"] forKey:@"avatar"];
            }
            else {
                [userFields setObject:@"" forKey:@"avatar"];
            }
            
            [user updateWithIdentityData:identityData userFields:userFields block:^(KiiUser *user, NSError *error) {
                if (error != nil) {
                    // Error handling
                    return;
                }
            }];
        }
        else {
            handler(NO, error);
        }
    }];
    
    
//    _graphRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
//                                                      parameters:@{@"fields": @"name,picture.height(200).width(200),id"}];
//    _graphRequestConnection = [[FBSDKGraphRequestConnection alloc] init];
//    
//    [_graphRequestConnection addRequest:_graphRequest
//                      completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                          if (result && !error) {
//                              NSLog(@"RESULT:%@",result);
//                              KiiUserFields *userFields = [[KiiUserFields alloc] init];
//                              
//                              // facebook頭像不是預設頭像才存
//                              if (![result[@"picture"][@"data"][@"is_silhouette"] boolValue]) {
//                                  [userFields setObject:result[@"picture"][@"data"][@"url"] forKey:@"avatar"];
//                              }
//                              else {
//                                  [userFields setObject:@"" forKey:@"avatar"];
//                              }
//                              
//                              [user updateWithUserFields:userFields block:^(KiiUser *user, NSError *error) {
//                                  if (error != nil) {
//                                      // Error handling
//                                      return;
//                                  }
//                              }];
//                          }
//                          else {
//                              handler(NO, error);
//                          }
//                      }];
//    [_graphRequestConnection start];
}


@end
