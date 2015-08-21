//
//  RecipeObject.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeObject : NSObject

@property (nonatomic, strong) NSMutableArray    *recipeList;


@end


@interface RecipeDataObject : NSObject

@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *imageUrl;
@property (nonatomic, strong) NSDictionary      *tagDict;
@property (nonatomic ,strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) NSString          *time;
@property (nonatomic, strong) NSString          *type;
@property (nonatomic) BOOL hasMoreVideo;
- (id) initWithDictionaryObject:(NSMutableDictionary *)data;
@end

// ** picture ** //
@interface RecipePictureObject : NSObject
@property (nonatomic, strong) NSString      *imageurl;
@property (nonatomic, strong) NSString      *content;
@property (nonatomic)         CGFloat       calculatedIntroductionCardHeight;
- (id) initWithUrl:(NSString *) data content:(NSString *)content;
@end

// ** Video ** //
@interface RecipeVideoObject : NSObject
@property (nonatomic, strong) NSString      *content;
@property (nonatomic, strong) NSString      *time;
@property (nonatomic, strong) NSString      *link;
@property (nonatomic, strong) NSString      *imageUrl;
- (id) initWithDictionary:(NSMutableDictionary *)data;
@end

// ** Introduction ** //
@interface RecipeIntroductionObject : NSObject
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *content;
@property (nonatomic)         CGFloat       calculatedIntroductionCardHeight;
- (id) initWithDictionary:(NSMutableDictionary *)data;


@end
