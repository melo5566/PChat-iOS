//
//  ChatroomListTableViewCell.h
//  493_Project
//
//  Created by Wu Peter on 2015/12/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"

@protocol ChatroomListTableViewCellDelegate <NSObject>

@optional
- (void) handleLongPressD:(NSString *)creatorID;
@end

@interface ChatroomListTableViewCell : UITableViewCell
@property (nonatomic, strong) ChatroomListObject        *chatroomListObject;
@property (nonatomic, weak) id <ChatroomListTableViewCellDelegate> delegate;
@end
