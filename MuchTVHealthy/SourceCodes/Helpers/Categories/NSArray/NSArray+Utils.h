//
//  NSArray+Utils.h
//  Community
//
//  Created by Weiyu Chen on 2015/2/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

@property (nonatomic, readonly) id firstObject;

- (BOOL) isEmpty;
- (BOOL) isNotEmpty;

@end
