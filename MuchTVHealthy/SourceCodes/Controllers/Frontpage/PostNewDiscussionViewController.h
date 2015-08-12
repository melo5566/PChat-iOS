//
//  PostNewDiscussionViewController.h
//  FaceNews
//
//  Created by Weiyu Chen on 2015/7/15.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseViewController.h"

@interface PostNewDiscussionViewController : BaseViewController
- (id) initForProgramDiscussion;
- (id) initForCelebrityDiscussionWithUri:(NSURL *)uri;
@end
