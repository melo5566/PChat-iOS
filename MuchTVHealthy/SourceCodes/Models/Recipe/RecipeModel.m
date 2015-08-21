//
//  RecipeModel.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "RecipeModel.h"

@implementation RecipeModel

- (void) loadRecipeDataWithBlock :(RecipeDataLoadingHandler)handler{
    
    if(!_recipeObject) {
        _recipeObject = [[RecipeObject alloc]init];
    }
    for (int i=0;i<5;i++) {
     NSMutableDictionary    *recipeFakeKiiDictionary = [[NSMutableDictionary alloc]init];
    // fake Kii data instead load kii data
       
    // put in image,time,description
        [recipeFakeKiiDictionary setValue:@"descriptiondescriptiondescriptiondescription" forKey:@"recipeDescription"];
        [recipeFakeKiiDictionary setValue:@"2015/03/21 14:12" forKey:@"time"];
        [recipeFakeKiiDictionary setValue:(i%3==1)?@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTtgQb4ZPwWo8t5CXR18MYHKVwBUMlrq8bJSv54744S3LXlpUlLQg":@"http://static.dezeen.com/uploads/2013/03/dezeen_3D-printed-food-by-Janne-Kytannen_5.jpg" forKey:@"imageUrl"];
    
    //  put in VideoList contain videoData
        NSMutableArray   *videoList = [[NSMutableArray alloc]init];
        for (int i=0;i<5;i++) {
            NSMutableDictionary *videoData = [[NSMutableDictionary alloc]init];
            [videoData setValue:@"titleitleitletitletitleitleitletitletitleitleitletitle" forKey:@"videoTitle"];
            [videoData setValue:@"https://www.youtube.com/watch?v=ace-TXcX6GY" forKey:@"link"];
            [videoData setValue:@"2015/08/18 14:12" forKey:@"time"];
            [videoList addObject:videoData];
        }
        [recipeFakeKiiDictionary setValue:videoList forKey:@"videoList"];
    
    //  put in InformationList contain informationData
        NSMutableArray   *introductionList = [[NSMutableArray alloc]init];
        for (int i=0;i<5;i++) {
            NSMutableDictionary *introductionData = [[NSMutableDictionary alloc]init];
            [introductionData setValue:@"titleitleitletitletitleitleitl" forKey:@"title"];
            [introductionData setValue:@"introductionintroductionintroductionintroductionintroductionintroductionintroductionintroduction" forKey:@"content"];
            [introductionList addObject:introductionData];
        }

        [recipeFakeKiiDictionary setValue:introductionList forKey:@"introductionList"];
        if (i%2==0){
            [recipeFakeKiiDictionary setValue:@"collect" forKey:@"type"];
        }
        [_recipeObject.recipeList  addObject:[[RecipeDataObject alloc]initWithDictionaryObject:recipeFakeKiiDictionary]];
    }
    BOOL hasMore = NO;
    handler(_recipeObject,hasMore);
}


@end
