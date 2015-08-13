//
//  ConnoisseurListTableViewCell.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/13.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnoisseurObject.h"

@interface ConnoisseurListTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString  *ConnoisseurName;
@property (nonatomic, strong) NSString  *ConnoisseurSubtitle;
@property (nonatomic, strong) NSString  *imageURL;
@property (nonatomic, strong) ConnoisseurDataObject   *connoisseurDataObject;

@end
