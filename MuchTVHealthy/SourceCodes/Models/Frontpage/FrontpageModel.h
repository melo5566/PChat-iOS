//
//  FrontpageModel.h
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrontpageObject.h"
#import "BaseModel.h"

@protocol FrontpageModelDelegate <BaseModelDelegate>
- (void) didLoadFrontpageData:(NSArray *)data;
@end






@interface FrontpageModel : BaseModel
@property (nonatomic, weak) id <FrontpageModelDelegate> delegate;
- (void) loadFrontpageData;
- (void) executeMoreFrontpageData;
@end
