//
//  MessageTableViewCell.h
//  North7
//
//  Created by Weiyu Chen on 2015/5/8.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MessageObject.h"

@interface MessageTableViewCell : UITableViewCell
//@property (nonatomic, strong) MessageObject     *messageObject;
@property (nonatomic) float                     frameHeight;
@property (nonatomic, strong) NSString          *messgae;
@end
