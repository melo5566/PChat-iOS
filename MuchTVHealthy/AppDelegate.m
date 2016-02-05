//
//  AppDelegate.m
//  MuchTVHealthy
//
//  Created by Weiyu Chen on 2015/7/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "AppDelegate.h"
#import "SignUpAndSignInModel.h"
#import "ChatroomViewController.h"
#import "DiscussionListViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate () <SignUpAndSignInModelDelegate>
@property UINavigationController *navController;
@property (nonatomic, strong) SignUpAndSignInModel              *signUpAndSignInModel;
@property (nonatomic, strong) DiscussionListViewController      *discussionListViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.backgroundColor = [UIColor clearColor];
    
    [Parse setApplicationId:kParseApplicationID
                  clientKey:kParseClientKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults stringForKey:@"firstLaunch"]) {
        [defaults setObject:@"YES" forKey:@"firstLaunch"];
        [defaults synchronize];
    }
    if ([[defaults stringForKey:@"autoLogin"] isEqualToString:@"YES"]) {
        [self loginWithUserDefault];
    }
    [self setFrontpageForRootViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) setFrontpageForRootViewController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _discussionListViewController = [DiscussionListViewController new];
    self.navController = [[UINavigationController alloc] initWithRootViewController:_discussionListViewController];
    [self.navController.navigationBar setTranslucent:NO];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
}

- (void) loginWithUserDefault {
    if (!_signUpAndSignInModel) {
        _signUpAndSignInModel = [SignUpAndSignInModel new];
        _signUpAndSignInModel.delegate = self;
    }
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [_signUpAndSignInModel kiiUserLogIn:[defaults stringForKey:@"account"] password:[defaults stringForKey:@"password"] CompleteBlock:^(KiiUser *user, NSError *error) {
    //        if (error != nil) {
    //            NSLog(@"Error");
    //            return;
    //        }
    //        
    //    }];
}

@end
