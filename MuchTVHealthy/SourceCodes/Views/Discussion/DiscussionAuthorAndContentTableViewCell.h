//
//  DiscussionAuthorAndContentTableViewCell.h
//  493_Project
//
//  Created by Peter on 2015/11/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussionObject.h"

@protocol DiscussionAuthorAndContentTableViewCellDelegate <NSObject>

@optional
- (void) shareButtonClicked;
@end

@interface DiscussionAuthorAndContentTableViewCell : UITableViewCell
@property (nonatomic, strong) DiscussionObject          *discussionObject;
@property (nonatomic) float                             contentHeight;
@property (nonatomic) NSUInteger                        numberOfImage;
@property (nonatomic, weak) id <DiscussionAuthorAndContentTableViewCellDelegate> delegate;
@end