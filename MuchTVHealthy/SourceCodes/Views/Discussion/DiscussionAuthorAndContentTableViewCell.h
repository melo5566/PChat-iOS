//
//  DiscussionAuthorAndContentTableViewCell.h
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscussionAuthorAndContentTableViewCellDelegate <NSObject>

@optional
- (void) shareButtonClicked;
@end

@interface DiscussionAuthorAndContentTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString                  *content;
@property (nonatomic) float                             contentHeight;
@property (nonatomic) NSUInteger                        numberOfImage;
@property (nonatomic, weak) id <DiscussionAuthorAndContentTableViewCellDelegate> delegate;
@end