//
//  FrontpageObject.h
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrontpageObject : NSObject
@property (nonatomic, strong) NSString      *imageUrl;
@property (nonatomic, strong) NSString      *link;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *time;
- (id) initWithKiiObject:(KiiObject *) kiiobject;
@end
