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

- (void) loadConnoisseurSinglePageDataWithBlock:(ConnoissuerSingleDataLoadingHandler)handler {
    // fake Kii data instead load kii data
    // input discussionData
    NSMutableArray          *discussionArray = @[].mutableCopy;
    for(int i=0;i<3;i++) {
        NSMutableDictionary *connoisseurDiscussionData = [[NSMutableDictionary alloc]init];
        [connoisseurDiscussionData setValue:@"titietitietitietitie" forKey:@"discussionTitle"];
        [connoisseurDiscussionData setValue:@"http://www.iheartfood4thought.com/wp-content/uploads/2015/03/Food-for-thought-1.jpeg" forKey:@"discussionImage"];
        [connoisseurDiscussionData setValue:@"2015/06/13 14:12" forKey:@"discussionTime"];
        [discussionArray addObject:connoisseurDiscussionData];
    }
    
    // input AboutData
    NSMutableDictionary *connoisseurAboutData = [[NSMutableDictionary alloc]init];
    [connoisseurAboutData setValue:@"ContentContentContentContentContent" forKey:@"AboutContent"];
    
    // input recommendData
    NSMutableArray          *recommendArray = @[].mutableCopy;
    for(int i=0;i<3;i++) {
        NSMutableDictionary *connoisseurRecommmendData = [[NSMutableDictionary alloc]init];
        [connoisseurRecommmendData setValue:@"titietitietitietitie" forKey:@"productName"];
        [connoisseurRecommmendData setValue:@"http://www.iheartfood4thought.com/wp-content/uploads/2015/03/Food-for-thought-1.jpeg" forKey:@"productImage"];
        [connoisseurRecommmendData setValue:@"SizeSizeSize" forKey:@"productSize"];
        [connoisseurRecommmendData setValue:@"12344455" forKey:@"productPrice"];
        [recommendArray addObject:connoisseurRecommmendData];
    }
    
    if(!_connoisseurSinglePageObject) {
        _connoisseurSinglePageObject = [[ConnoisseurSinglePageObject alloc]init];
    }
    
    for (NSMutableDictionary* object in discussionArray) {
        ConnoisseurDiscussionDataObject    *connoisseurDiscussionDataObject = [[ConnoisseurDiscussionDataObject alloc]initWithDictionaryObject:object];
        [_connoisseurSinglePageObject.discussionArray   addObject:connoisseurDiscussionDataObject];
    }
    
    ConnoisseurAboutDataObject  *connoisseurAboutDataObject = [[ConnoisseurAboutDataObject alloc]initWithDictionaryObject:connoisseurAboutData];
    [_connoisseurSinglePageObject.aboutArray   addObject:connoisseurAboutDataObject];
    
    
    for (NSMutableDictionary* object in recommendArray) {
        ConnoisseurRecommendDataObject    *connoisseurRecommendDataObject = [[ConnoisseurRecommendDataObject alloc]initWithDictionaryObject:object];
        [_connoisseurSinglePageObject.recommendArray   addObject:connoisseurRecommendDataObject];
    }
    BOOL hasMoreDiscussoin =YES;
    BOOL hasMoreRecommend = NO;
    BOOL hasMoreFacebook = NO;
    handler(_connoisseurSinglePageObject,hasMoreDiscussoin,hasMoreRecommend,hasMoreFacebook);
}

@end

