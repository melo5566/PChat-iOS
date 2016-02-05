//
//  GameTableViewCell.h
//  493_Project
//
//  Created by Wu Peter on 2015/12/9.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussionObject.h"

@protocol GameTableViewCellDelegate <NSObject>

@optional
- (void) handleLongPress:(NSString *)category;
@end


@interface GameTableViewCell : UITableViewCell
@property (nonatomic, strong) CategoryObject    *categoryObject;
@property (nonatomic, strong) NSString          *category;
@property (nonatomic, weak) id <GameTableViewCellDelegate> delegate;
@end
