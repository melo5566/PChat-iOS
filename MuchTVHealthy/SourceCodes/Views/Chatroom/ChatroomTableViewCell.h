//
//  ChatroomTableViewCell.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/1.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"

@protocol chatroomTableViewCellDelegate <NSObject>

- (void) viewPhoto:(MessageObject *)messageObject type:(NSString *)type;

@end

@interface ChatroomTableViewCell : UITableViewCell
@property (nonatomic, strong) MessageObject     *messageObject;
@property (nonatomic, weak) id <chatroomTableViewCellDelegate>delegate;
@end
