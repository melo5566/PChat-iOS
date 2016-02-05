//
//  DiscussionModel.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/25.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "DiscussionObject.h"
#import <Parse/Parse.h>

@interface DiscussionModel : BaseModel
typedef void (^LoadDiscussionListWithBlock)(NSArray *discussionListArray);
typedef void (^PostNewDiscussionWithBlock)(void);
typedef void (^PostReplyWithBlock)(void);
typedef void (^LoadReplyWithBlock)(NSArray *replyArray);
typedef void (^LoadWorkloadWithBlock)(NSArray *workloadArray);
typedef void (^CheckIfVotedWithBlock)(BOOL isVoted, NSString *choice);
typedef void (^LoadWorkloadDataWithBlock)(WorkloadObject *workloadObject);

- (void) loadDiscussionListWithBlock:(NSString *)category completeBlock:(LoadDiscussionListWithBlock )handler;
- (void) postNewDiscussionWithBlock:(NSString *)category
                          currentUser:(PFUser *)currentUser
                                title:(NSString *)title
                              content:(NSString *)content
                           imageArray:(NSArray *)imageArray
                        completeBlock:(PostNewDiscussionWithBlock )handler;
- (void) postReplyWithBlock:(NSString *)content
                       user:(PFUser *)user
                   targetID:(NSString *)targetID
              completeBlock:(PostReplyWithBlock )handler;
- (void) loadReplyWithBlock:(NSString *)targetID completeBlock:(LoadReplyWithBlock )handler;
- (void) loadWorkloadListWithBlock:(NSString *)department course:(NSString *)course completeBlock:(LoadWorkloadWithBlock )handler;
- (void) uploadVoteDataWithBlock:(NSString *)courseID voterID:(NSString *)voterID choice:(NSString *)choice completeBlock:(PostReplyWithBlock )handler;
- (void) checkIfVotedWithBlock:(NSString *)voterID courseID:(NSString *)courseID completeBlock:(CheckIfVotedWithBlock )handler;
- (void) loadWorkloadDataWithBlock:(NSString *)department course:(NSString *)course season:(NSString *)season year:(NSString *)year completeBlock:(LoadWorkloadDataWithBlock )handler;
- (void) loadAcademicListWithBlock:(LoadDiscussionListWithBlock )handler;
- (void) loadCourseListWithBlock:(NSString *)department completeBlock:(LoadDiscussionListWithBlock )handler;
- (void) loadCategoryWihtBlock:(LoadReplyWithBlock )handler;
@end
