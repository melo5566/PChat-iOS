//
//  SignUpAndSignInModel.m
//  493_Project
//
//  Created by Peter on 2015/10/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "SignUpAndSignInModel.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>


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


@end
