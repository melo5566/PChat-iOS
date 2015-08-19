//
//  ConnoiseurObject.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/12.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ConnoisseurObject.h"

@implementation ConnoisseurDataObject

- (id) initWithDictionaryobject:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
     _connoisseurName     = isNotNullValue([data valueForKey:@"ConnoisseurName"])?[data valueForKey:@"ConnoisseurName"]:@"";
     _connoisseurSubtitle = isNotNullValue([data valueForKey:@"ConnoisseurSubtitle"])?[data valueForKey:@"ConnoisseurSubtitle"]:@"";
     _imageUrl            = isNotNullValue([data valueForKey:@"ConnoisseurImage"])?[data valueForKey:@"ConnoisseurImage"]:@"";
    }
    return self;
}


@end

@implementation ConnoisseurObject

- (id) init {
    self = [super init];
    _dataArray = [[NSMutableArray alloc] init];
    return self;
}
@end

@implementation ConnoisseurSinglePageObject

- (id) init {
    self = [super init];
    _discussionArray = [[NSMutableArray alloc] init];
    _aboutArray = [[NSMutableArray alloc] init];
    _facebookArray = [[NSMutableArray alloc] init];
    _recommendArray = [[NSMutableArray alloc] init];
    return self;
}

@end

@implementation ConnoisseurDiscussionDataObject

- (id) initWithDictionaryObject:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        _dataType        = @"Disscussion";
        _discussionTitle = isNotNullValue([data valueForKey:@"discussionTitle"])?[data valueForKey:@"discussionTitle"]:@"";
        _discussionImageUrl = isNotNullValue([data valueForKey:@"discussionImage"])?[data valueForKey:@"discussionImage"]:@"";
        _discussionDate = isNotNullValue([data valueForKey:@"discussionTime"])?[data valueForKey:@"discussionTime"]:@"";
    }
    return self;
}

@end

@implementation ConnoisseurAboutDataObject

- (id) initWithDictionaryObject:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        _dataType           = @"About";
        _aboutTitle         = isNotNullValue([data valueForKey:@"aboutTitle"])?[data valueForKey:@"aboutTitle"]:@"";
        _aboutContent       = isNotNullValue([data valueForKey:@"aboutContent"])?[data valueForKey:@"aboutContent"]:@"";
    }
    return self;
}

@end

@implementation ConnoisseurRecommendDataObject

- (id) initWithDictionaryObject:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        _dataType       = @"Recommend";
        _productImage   = isNotNullValue([data valueForKey:@"productImage"])?[data valueForKey:@"productImage"]:@"";
        _productName    = isNotNullValue([data valueForKey:@"productName"])?[data valueForKey:@"productName"]:@"";
        _productSize    = isNotNullValue([data valueForKey:@"productSize"])?[data valueForKey:@"productSize"]:@"";
        _productPrice   = isNotNullValue([data valueForKey:@"productPrice"])?[data valueForKey:@"productPrice"]:@"";
    }
    return self;
}

@end

@implementation ConnoisseurFacebookDataObject

- (id) initWithDictionaryObject:(NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        _dataType       = @"facebook";
        _facebookImage   = isNotNullValue([data valueForKey:@"facebookImage"])?[data valueForKey:@"facebookImage"]:@"";
        _facebookTime    = isNotNullValue([data valueForKey:@"facebookTime"])?[data valueForKey:@"facebookTime"]:@"";
        _facebookTitle   = isNotNullValue([data valueForKey:@"facebookTitle"])?[data valueForKey:@"facebookTitle"]:@"";
    }
    return self;
}

@end