//
//  UserModel.m
//  493_Project
//
//  Created by Peter on 2015/10/28.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@dynamic delegate;


- (void) uploadAvatarWithBlock:(NSData *)avatarImageData ForUser:(PFUser *)user completeBlock:(UploadAvatarWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:avatarImageData];
        user[@"imageName"] = @"Test";
        user[@"imageFile"] = imageFile;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                PFFile *imageFile = user[@"imageFile"];
                handler(imageFile.url);
            } else {
                NSLog(@"Error!");
            }
        }];
    }];

}

- (void) updateUsername:(NSString *)username ForUser:(PFUser *)user completeBlock:(UpdateUserNameWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^{
        user[@"displayName"] = username;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                handler();
            } else {
                NSLog(@"Error!");
            }
        }];

    }];
}

- (void)updateFavorites:(NSString *)category ForUser:(PFUser *)user completeBlock:(UpdateFavoritesWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        if (isNotNullValue(user[@"Favorites"])) {
            NSMutableArray *array = user[@"Favorites"];
            if (![array containsObject:category]) {
                [array addObject:category];
                user[@"Favorites"] = array;
                [user saveInBackground];
                handler(NO);
            } else {
                handler(YES);
            }
        } else {
            user[@"Favorites"] = @[category];
            [user saveInBackground];
            handler(NO);
        }
    }];
}

- (void)loadFavoriteWithBlock:(PFUser *)user completeBlock:(LoadFavoriteWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        NSMutableArray *array = user[@"Favorites"];
        handler(array);
    }];
}

- (void)queryUserWithBlock:(NSString *)userID completeBlock:(QueryUserWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query getObjectInBackgroundWithId:userID
                                     block:^(PFObject *object, NSError *error) {
                                         if(!error) {
                                             handler(object);
                                         } else {
                                             NSLog(@"Error");
                                         }
                                     }];
    }];
}

- (void)deleteFromMyFavorite:(PFUser *)user category:(NSString *)category completeBlock:(DeleteFromMyFavoriteWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        NSMutableArray *array = user[@"Favorites"];
        for(int i = 0; i < array.count; i ++) {
            if ([array[i] isEqualToString:category]) {
                [array removeObjectAtIndex:i];
            }
        }
        user[@"Favorites"] = array;
        [user saveInBackground];
        handler();
    }];
}

@end
