//
//  FrontpageModel.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "FrontpageModel.h"
#import "AppDelegate.h"


@interface FrontpageModel ()
@property (nonatomic, strong) KiiQuery      *frontpageNextQuery;
@end


@implementation FrontpageModel
@dynamic delegate;

- (void) loadFrontpageData {
    KiiBucket *bucket = [Kii bucketWithName:@"home"];
    [self checkNetworkReachabilityAndDoNext:^{
        KiiQuery *query = [KiiQuery queryWithClause:nil];
        [query sortByDesc:@"date"];
        [query setLimit:5];
        
        NSMutableArray *allResults = [NSMutableArray array];
        
        [bucket executeQuery:query
                   withBlock:^(KiiQuery *query, KiiBucket *bucket, NSArray *results, KiiQuery *nextQuery, NSError *error) {
                       if (error != nil) {
                           NSLog(@"Error");
                           if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
                               [self.delegate hasNoNetworkConnection];
                           }
                           return;
                       }
                       [allResults addObjectsFromArray:results];
                       
                       NSMutableArray *listArray = @[].mutableCopy;
                       
                       for (KiiObject *object in allResults) {
                            [listArray addObject:[[FrontpageObject alloc] initWithKiiObject:object]];
                       }
                       
                       if ([self.delegate respondsToSelector:@selector(didLoadFrontpageData:)]) {
                           [self.delegate didLoadFrontpageData:listArray];
                       }
                       if (nextQuery) {
                           _frontpageNextQuery = nextQuery;
                       }
                       
                   }];
    }];
}

- (void)executeMoreFrontpageData {
    KiiBucket *bucket = [Kii bucketWithName:@"home"];
    [self checkNetworkReachabilityAndDoNext:^{
        [_frontpageNextQuery sortByDesc:@"date"];
        [_frontpageNextQuery setLimit:5];
        
        NSMutableArray *allResults = [NSMutableArray array];
        
        [bucket executeQuery:_frontpageNextQuery
                   withBlock:^(KiiQuery *query, KiiBucket *bucket, NSArray *results, KiiQuery *nextQuery, NSError *error) {
                       if (error != nil) {
                           NSLog(@"Error");
                           if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
                               [self.delegate hasNoNetworkConnection];
                           }
                           return;
                       }
                       [allResults addObjectsFromArray:results];
                       
                       NSMutableArray *listArray = @[].mutableCopy;
                       
                       for (KiiObject *object in allResults) {
                           [listArray addObject:[[FrontpageObject alloc] initWithKiiObject:object]];
                       }
                       
                       if ([self.delegate respondsToSelector:@selector(didLoadFrontpageData:)]) {
                           [self.delegate didLoadFrontpageData:listArray];
                       }
                       if (nextQuery) {
                           _frontpageNextQuery = nextQuery;
                       }
                       
                   }];
    }];
}



@end
