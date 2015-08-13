//
//  ConnoisseurModel.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/12.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ConnoisseurModel.h"

@implementation ConnoisseurModel

- (void) loadConnoisseurDataWithBlock :(ConnoissuerDataLoadingHandler)handler{
    // fake Kii data instead load kii data
    _connoisseurFakeKiiArray  = @[].mutableCopy;
    for (int i=0;i<3;i++) {
        NSMutableDictionary   *connoisseurFakeData = [[NSMutableDictionary alloc]init];
        [connoisseurFakeData setValue:@"王天實" forKey:@"ConnoisseurName"];
        [connoisseurFakeData setValue:@"冬粉達人" forKey:@"ConnoisseurSubtitle"];
        [connoisseurFakeData setValue:@"http://static.ettoday.net/images/904/d904439.jpg" forKey:@"ConnoisseurImage"];
        [_connoisseurFakeKiiArray addObject:connoisseurFakeData];
    }
    if(!_connoisseurObject) {
        _connoisseurObject = [[ConnoisseurObject alloc]init];
    }
    for (NSMutableDictionary* object in _connoisseurFakeKiiArray) {
        ConnoisseurDataObject    *connoisseurDataObject = [[ConnoisseurDataObject alloc]initWithDictionaryobject:object];
        [_connoisseurObject.dataArray    addObject:connoisseurDataObject];
    }
    BOOL hasMore;
    hasMore = NO;
    handler(_connoisseurObject,hasMore);
}

- (void) loadNextConnoisseur{

}

@end
