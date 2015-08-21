//
//  VideoReplyTableViewCell.h
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/21.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObject.h"

@protocol VideoReplyTableViewCellDelegate <NSObject>

@optional
- (void) goPostReply;
- (void) loadMoreReply;
- (void) goShare;
@end

@interface VideoReplyTableViewCell : UITableViewCell
@property (nonatomic, weak) id <VideoReplyTableViewCellDelegate> delegate;
@property (nonatomic, strong) VideoDataObject               *videoDataObject;
@property (nonatomic, strong) NSMutableArray                *commentDataArray;
@property (nonatomic, strong) NSString                      *commentString;
@property (nonatomic) BOOL                                  *hasMoreCommentData;
- (void) initShareButtonLayout;
- (void) initReplyButtonLayout;
- (void) initLoadMoreImageView;
@end
