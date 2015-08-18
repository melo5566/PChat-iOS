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

@interface ConnoisseurSinglePageObject : NSObject

@property (nonatomic, strong) NSMutableArray    *discussionArray;
@property (nonatomic, strong) NSMutableArray    *recommendArray;
@property (nonatomic, strong) NSMutableArray    *aboutArray;
@property (nonatomic, strong) NSMutableArray    *facebookArray;
@end


@interface ConnoisseurObject : NSObject
@property (nonatomic,strong) NSMutableArray             *dataArray;
@end


@interface ConnoisseurDiscussionDataObject : NSObject
@property (nonatomic,strong) NSString                   *dataType;
@property (nonatomic,strong) NSString                   *discussionImageUrl;
@property (nonatomic,strong) NSString                   *discussionTitle;
@property (nonatomic,strong) NSString                   *discussionDate;
- (id) initWithDictionaryObject:(NSMutableDictionary *)data;
@end


@interface ConnoisseurAboutDataObject : NSObject
@property (nonatomic,strong) NSString                   *dataType;
@property (nonatomic,strong) NSString                   *AboutData;
- (id) initWithDictionaryObject:(NSMutableDictionary *)data;
@end


@interface ConnoisseurRecommendDataObject : NSObject
@property (nonatomic,strong) NSString                   *dataType;
@property (nonatomic,strong) NSString                   *productImage;
@property (nonatomic,strong) NSString                   *productName;
@property (nonatomic,strong) NSString                   *productSize;
@property (nonatomic,strong) NSString                   *productPrice;
- (id) initWithDictionaryObject:(NSMutableDictionary *)data;
@end

@interface ConnoisseurFacebookDataObject : NSObject

@end