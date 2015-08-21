//
//  RecipeModel.h
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseModel.h"
#import "RecipeObject.h"

@interface RecipeModel : BaseModel

typedef void (^RecipeDataLoadingHandler)(RecipeObject *recipeObject,BOOL hasMoreRecipe);


@property (nonatomic,strong) RecipeObject                       *recipeObject;

- (void) loadRecipeDataWithBlock:(RecipeDataLoadingHandler)handler;

@end
