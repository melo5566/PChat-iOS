//
//  AboutTableViewCell.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/18.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnoisseurObject.h"

@interface AboutTableViewCell : UITableViewCell

@property (nonatomic,strong) ConnoisseurAboutDataObject     *connoisseurAboutDataObject;
@property (nonatomic,strong) NSMutableArray                 *aboutList;

@end
