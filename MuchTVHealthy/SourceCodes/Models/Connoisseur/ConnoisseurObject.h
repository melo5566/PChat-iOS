//
//  ConnoiseurObject.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/12.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnoisseurDataObject : NSObject
@property (nonatomic, strong) NSString          *connoisseurName;
@property (nonatomic, strong) NSString          *connoisseurSubtitle;
@property (nonatomic, strong) NSString          *imageUrl;
- (id) initWithDictionaryobject:(NSMutableDictionary *)data;


@end

@interface ConnoisseurObject : NSObject
@property (nonatomic, strong) NSMutableArray    *dataArray;
@end