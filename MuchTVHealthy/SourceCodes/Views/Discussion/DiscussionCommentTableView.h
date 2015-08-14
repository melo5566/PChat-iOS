//
//  DiscussionCommentTableView.h
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/14.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscussionCommentTableViewDelegate <UITableViewDelegate>
@optional
- (void) goPostReply;

@end

@interface DiscussionCommentTableView : UITableView
@property (nonatomic, weak) id <DiscussionCommentTableViewDelegate> delegate;
@end
