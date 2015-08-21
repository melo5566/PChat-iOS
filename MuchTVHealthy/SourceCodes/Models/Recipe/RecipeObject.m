//
//  RecipeObject.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "RecipeObject.h"

@implementation RecipeObject
- (id) init {
    self = [super init];
    _recipeList = [[NSMutableArray alloc] init];
    return self;
}
@end

@implementation RecipeDataObject

- (id) initWithDictionaryObject:(NSMutableDictionary *)data
{
    self = [super init];
    if (self) {
        
        _title      = isNotNullValue([data valueForKey:@"recipeDescription"])?[data valueForKey:@"recipeDescription"]:@"";
        _time       = isNotNullValue([data valueForKey:@"time"])?[data valueForKey:@"time"]:@"";
        _imageUrl   = isNotNullValue([data valueForKey:@"imageUrl"])?[data valueForKey:@"imageUrl"]:@"";
        _type       = isNotNullValue([data valueForKey:@"type"])?[data valueForKey:@"type"]:@"";
            //following lines are for single page view
            _dataArray      = [[NSMutableArray alloc]init];
            [_dataArray addObject:[[RecipePictureObject alloc] initWithUrl:_imageUrl content:_title]];
        
            if (isNotNullValue([data valueForKey:@"videoList"])){
                NSMutableArray *videoList=(NSMutableArray *)[data valueForKey:@"videoList"];
                for (NSMutableDictionary *videodata in videoList) {
                        [_dataArray addObject:[[RecipeVideoObject alloc] initWithDictionary:videodata]];
                }
                _hasMoreVideo = YES;
            }
            if (isNotNullValue([data valueForKey:@"introductionList"])){
                NSMutableArray *introductionList=(NSMutableArray *)[data valueForKey:@"introductionList"];
                for (NSMutableDictionary *introduction in introductionList) {
                        [_dataArray addObject:[[RecipeIntroductionObject alloc] initWithDictionary:introduction]];
                }
            }
    }
    return self;
}

@end

// ** Video ** //
@implementation RecipeVideoObject
- (id) initWithDictionary:(NSMutableDictionary *)data
{
    self = [super init];
    if (self) {
            //   _objectID       = isNotNullValue(data.objectId) ? data.objectId : @"";
            _content        = isNotNullValue([data valueForKey:@"videoTitle"])?[data valueForKey:@"videoTitle"]:@"";
            _link           = isNotNullValue([data valueForKey:@"link"])?[data valueForKey:@"link"]:@"";
            _time           = isNotNullValue([data valueForKey:@"time"])?[data valueForKey:@"time"]:@"";
    }
    return self;
}

@end
// ** Introduction ** //
@implementation RecipeIntroductionObject
- (id) initWithDictionary:(NSMutableDictionary *)data
{
    self = [super init];
    if (self) {
        @try {
            _title      = isNotNullValue(data[@"title"]) ? data[@"title"] : @"";
            _title      =[@" " stringByAppendingString:_title];
            _content    = isNotNullValue(data[@"content"]) ? data[@"content"] : @"";
            
            //to estimate height
            UILabel *contentLabel=[[UILabel alloc] init];
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            contentLabel.text = _content;
            contentLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:18];
            CGSize maximumLabelSize = CGSizeMake(kScreenWidth-20, 9999);
            CGSize expectSize = [contentLabel sizeThatFits:maximumLabelSize];
            
            _calculatedIntroductionCardHeight=expectSize.height+20;
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
    return self;
}
@end
// ** picture ** //

@implementation RecipePictureObject


-(id) initWithUrl:(NSString *)data content:(NSString *)content
{
    self=[super init];
    if (self) {
        @try {
            _imageurl = isNotNullValue(data) ? data: @"";
            _content=content;
            UILabel *contentLabel=[[UILabel alloc] init];
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            contentLabel.text = _content;
            contentLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:18];
            CGSize maximumLabelSize = CGSizeMake(kScreenWidth-20, 9999);
            CGSize expectSize = [contentLabel sizeThatFits:maximumLabelSize];
            
            _calculatedIntroductionCardHeight=expectSize.height+20;
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
    return self;
}

@end

