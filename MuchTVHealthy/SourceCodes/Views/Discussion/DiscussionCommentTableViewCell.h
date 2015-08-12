//
//  DiscussionCommentTableViewCell.h
//  FaceNews
//
//  Created by Peter on 2015/7/17.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscussionCommentTableViewCellDelegate <NSObject>

@optional
- (void) goPostReply;
- (void) loadMoreReply;
@end

@interface DiscussionCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString                  *string;
@property (nonatomic, strong) NSString                  *commentString;
@property (nonatomic, strong) NSMutableArray            *commentDataArray;
@property (nonatomic) BOOL                              *hasMoreCommentData;
@property (nonatomic) BOOL                              hasMoreReply;
@property (nonatomic, weak) id <DiscussionCommentTableViewCellDelegate> delegate;
@end
