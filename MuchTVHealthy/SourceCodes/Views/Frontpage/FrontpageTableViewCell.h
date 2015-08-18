//
//  FrontpageTableViewCell.h
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontpageObject.h"

@interface FrontpageTableViewCell : UITableViewCell
@property (nonatomic, strong) FrontpageObject                   *frontpageObject;
@property (nonatomic, strong) NSString                          *string;
@end
