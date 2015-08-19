//
//  RelativeDiscussionTableViewCell.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/14.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnoisseurObject.h"


@protocol RelativeDiscussionDelegate <NSObject>

- (void) postDiscussionButtonClickedDelegateToCell;
- (void) postDiscussionButtonClickedDelegateToController;
- (void) discussionCellPressedDelegate;

@end

@interface RelativeDiscussionTableViewCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray                     *relativeDiscussionList;
@property (nonatomic) BOOL                                      hasMoreDicussion;
@property (nonatomic,strong) ConnoisseurDiscussionDataObject    *connoisseurDiscussionDataObject;
@property (nonatomic, weak) id <RelativeDiscussionDelegate>     delegate;
@end
