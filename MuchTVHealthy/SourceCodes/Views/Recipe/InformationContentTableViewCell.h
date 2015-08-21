//
//  InformationContentTableTableViewCell.h
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/7/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeObject.h"
#import "InformationIntroductionView.h"
#import "InformationCardTableViewCell.h"
@protocol InformationContentTableViewCellDelegate <NSObject>
@optional//////following have not been implemented
- (void) goPlayVideo:(NSString *)url title:(NSString*) title;

- (void) goMoreVideo;


@end

@interface InformationContentTableViewCell : UITableViewCell

@property (nonatomic) BOOL                  hasMoreVideoMenu;
@property (nonatomic, strong) RecipePictureObject *recipePictureObjcet;
@property (nonatomic, strong) RecipeIntroductionObject *recipeIntroductionObject;


@property (nonatomic, strong) NSMutableArray       *videoMenuDataArray;
@property (nonatomic, strong) InformationIntroductionView   *introductionView;
@property (nonatomic, weak) id <InformationContentTableViewCellDelegate> delegate;
//@property (nonatomic, weak) id <InformationIntroductionViewDelegate> ddelegate;
//- (void) initTableVieww;//for testing
//- (void) initTableViewwithDataArray:(NSString*)dataArray;
//- (void) initBottomRockLogo;
@end
