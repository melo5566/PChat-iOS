//
//  RecipeTableViewCell.h
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/18.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeObject.h"

@interface RecipeTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString              *string;
@property (nonatomic, strong) RecipeDataObject      *recipeDataObject;
@end
