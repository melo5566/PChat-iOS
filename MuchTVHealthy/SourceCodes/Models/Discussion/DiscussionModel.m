//
//  DiscussionModel.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/25.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DiscussionModel.h"
#import "DiscussionObject.h"
#import <Parse/Parse.h>

@implementation DiscussionModel
- (void)loadDiscussionListWithBlock:(NSString *)category completeBlock:(LoadDiscussionListWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        NSString *class = [category stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        PFQuery *query = [PFQuery queryWithClassName:@"Discussion"];
        [query whereKey:@"Category" equalTo:class];
        [query includeKey:@"Author"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSMutableArray *array = @[].mutableCopy;
                for (PFObject *object in objects) {
                    DiscussionObject *discussionObject = [[DiscussionObject alloc] initWithPFObject:object];
                    [array addObject:discussionObject];
                }
                handler(array);
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    }];
}

- (void)postNewDiscussionWithBlock:(NSString *)category
                       currentUser:(PFUser *)currentUser
                             title:(NSString *)title
                           content:(NSString *)content
                        imageArray:(NSArray *)imageArray
                     completeBlock:(PostNewDiscussionWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        NSString *class = [category stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        PFObject *object = [PFObject objectWithClassName:@"Discussion"];
        object[@"Category"]     = class;
        object[@"Author"]       = currentUser;
        object[@"Title"]        = title;
        object[@"Content"]      = content;
        object[@"ImageArray"]   = imageArray;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                handler();
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    }];
}


- (void)postReplyWithBlock:(NSString *)content
                      user:(PFUser *)user
                  targetID:(NSString *)targetID
             completeBlock:(PostReplyWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFObject *object = [PFObject objectWithClassName:@"Comment"];
        object[@"Author"]     = user;
        object[@"TargetID"]   = targetID;
        object[@"Content"]    = content;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                handler();
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }];
}

- (void)loadReplyWithBlock:(NSString *)targetID completeBlock:(LoadReplyWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
        [query whereKey:@"TargetID" equalTo:targetID];
        [query includeKey:@"Author"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSMutableArray *array = @[].mutableCopy;
                for (PFObject *object in objects) {
                    ReplyObject *replyObject = [[ReplyObject alloc] initWithPFObject:object];
                    [array addObject:replyObject];
                }
                handler(array);
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];
}

- (void)loadWorkloadListWithBlock:(NSString *)department course:(NSString *)course completeBlock:(LoadWorkloadWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Workload"];
        [query whereKey:@"Department" equalTo:department];
        [query whereKey:@"Course" equalTo:course];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSMutableArray *array = @[].mutableCopy;
                for (PFObject *object in objects) {
                    WorkloadObject *workloadObject = [[WorkloadObject alloc] initWithPFObject:object];
                    [array addObject:workloadObject];
                }
                handler(array);
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];
}

- (void)uploadVoteDataWithBlock:(NSString *)courseID
                        voterID:(NSString *)voterID
                         choice:(NSString *)choice
                  completeBlock:(PostReplyWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Workload"];
        [query whereKey:@"objectId" equalTo:courseID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *object in objects) {
                if ([choice containsString:@" "])
                    [object incrementKey:[choice stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
                else
                    [object incrementKey:choice];
                [object saveInBackground];
            }
        }];
        
        PFObject *object = [PFObject objectWithClassName:@"Vote"];
        object[@"CourseID"]   = courseID;
        object[@"VoterID"]  = voterID;
        object[@"Choice"]     = choice;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                handler();
            } else {
                NSLog(@"Error!");
            }
        }];
    }];
}

- (void)checkIfVotedWithBlock:(NSString *)voterID courseID:(NSString *)courseID completeBlock:(CheckIfVotedWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Vote"];
        [query whereKey:@"CourseID" equalTo:courseID];
        [query whereKey:@"VoterID" equalTo:voterID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count == 0)
                handler(NO, @"");
            else {
                for (PFObject *object in objects) {
                    handler(YES, object[@"Choice"]);
                }
            }
        }];

    }];
}

- (void)loadWorkloadDataWithBlock:(NSString *)department course:(NSString *)course season:(NSString *)season year:(NSString *)year completeBlock:(LoadWorkloadDataWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Workload"];
        [query whereKey:@"Department" equalTo:department];
        [query whereKey:@"Course" equalTo:course];
        [query whereKey:@"Season" equalTo:season];
        [query whereKey:@"Year" equalTo:year];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *object in objects) {
                WorkloadObject *workloadObject = [[WorkloadObject alloc] initWithPFObject:object];
                handler(workloadObject);
            }
        }];

    }];
}

- (void)loadAcademicListWithBlock:(LoadDiscussionListWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Academic"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSMutableArray *array = @[].mutableCopy;
                for (PFObject *object in objects) {
                    [array addObject:[NSString stringWithFormat:@"%@_%@",object[@"School"],object[@"Department"]]];
                }
                handler(array);
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];
}

- (void)loadCourseListWithBlock:(NSString *)department completeBlock:(LoadDiscussionListWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Academic"];
        [query whereKey:@"Department" equalTo:department];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    handler(object[@"Course"]);
                }
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];
}

- (void)loadCategoryWihtBlock:(LoadReplyWithBlock)handler {
    [self checkNetworkReachabilityAndDoNext:^() {
        PFQuery *query = [PFQuery queryWithClassName:@"Category"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSMutableArray *array = @[].mutableCopy;
                for (PFObject *object in objects) {
                    CategoryObject *categoryObject = [[CategoryObject alloc] initWithPFObject:object];
                    [array addObject:categoryObject];
                }
                handler(array);
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];
}

@end
