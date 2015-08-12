//
//  UIView+Utils.m
//  Community
//
//  Created by Weiyu Chen on 2015/2/5.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (id) initForAutolayout
{
    self = [self init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

@end
