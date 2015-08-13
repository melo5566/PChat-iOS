//
//  ConnoisseurModel.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/12.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseModel.h"
#import "ConnoisseurObject.h"

@interface ConnoisseurModel : BaseModel

@property (nonatomic,strong) NSMutableArray          *connoisseurFakeKiiArray;
@property (nonatomic,strong) ConnoisseurObject       *connoisseurObject;
typedef void (^ConnoissuerDataLoadingHandler)(ConnoisseurObject *connoissuerObject, BOOL hasMore);
- (void) loadConnoisseurDataWithBlock:(ConnoissuerDataLoadingHandler)handler;
- (void) loadNextConnoisseur;

@end
