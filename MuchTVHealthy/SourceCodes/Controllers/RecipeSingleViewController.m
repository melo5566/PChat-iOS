//
//  RecipeSingleViewController.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "RecipeSingleViewController.h"
#import "RecipeModel.h"
#import "InformationContentTableViewCell.h"

@interface RecipeSingleViewController () <UITableViewDataSource, UITableViewDelegate,InformationIntroductionViewDelegate>
@property (nonatomic, strong) UITableView                               *recipeTableView;
@property (nonatomic) BOOL                                              isFirstLoad;
@property (nonatomic, strong) RecipePictureObject                       *recipePicture;
@property (nonatomic, strong) NSMutableArray                            *introductionDataArray;
@property (nonatomic, strong) NSMutableArray                            *videoDataArray;
@property (nonatomic, strong) NSMutableArray                            *introductionCellHeightArray;
@property (nonatomic) BOOL                                              hasMoreVideo;
@property (nonatomic) CGFloat                                           videoCellHeight;
@property (nonatomic, strong) RecipeModel                               *Menumodel;

@end


@implementation RecipeSingleViewController
static CGFloat const cellPadding      = 20;

- (void) setRecipeDataObject:(RecipeDataObject *)recipeDataObject {
    _recipeDataObject = recipeDataObject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    self.title = _recipeDataObject.title;
    self.view.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self initTableView];
    if (_isFirstLoad) {
        _recipeTableView.hidden = YES;
    }
    [self getInformationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void) getInformationData
{
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"讀取中..." delayToHide:-1];
    [self diduseRecipeDataObject:_recipeDataObject];
}

- (void) diduseRecipeDataObject:(RecipeDataObject *) data
{
    [self.hud hide:YES];
    if (_isFirstLoad) {
        _isFirstLoad = NO;
    }
    [self resetDataArrays];
    
    for (id object in data.dataArray) {
        if ([object isKindOfClass:[RecipePictureObject class]]) {
            _recipePicture=(RecipePictureObject *)object;
        }
        else if ([object isKindOfClass:[RecipeIntroductionObject class]]) {
            [_introductionDataArray addObject:object];
        }
        else if ([object isKindOfClass:[RecipeVideoObject class]]) {
            [_videoDataArray addObject:object];
        }
    }
    _hasMoreVideo=data.hasMoreVideo?YES:NO;
    [self calculateCellHeight];
    
    [_recipeTableView reloadData];
    _recipeTableView.hidden = NO;
}

- (void) resetDataArrays {
    _introductionDataArray = @[].mutableCopy;
    _videoDataArray=@[].mutableCopy;
    _introductionCellHeightArray = @[].mutableCopy;
}

- (void) calculateCellHeight {
    
    for (RecipeIntroductionObject *introductionObject in _introductionDataArray) {
        NSNumber * aNumber = [NSNumber numberWithFloat:(introductionObject.calculatedIntroductionCardHeight+30 +cellPadding)];
        [_introductionCellHeightArray addObject:aNumber];
    }
    _videoCellHeight = [_videoDataArray isNotEmpty] ? (cellPadding+kHeaderHeightIncludingThick1Height + (_videoDataArray.count>=3 ? 3 : _videoDataArray.count) * kkGlobalCardCellHeight + (_hasMoreVideo ? kkGlobalFooterHeight : 0)) : 0;
    
}


- (void) initTableView{
    if (!_recipeTableView) {
        _recipeTableView = [[UITableView alloc] initForAutolayout];
        _recipeTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _recipeTableView.backgroundColor = [UIColor colorWithHexString:kRecipeBackGroundColorHexString];
        _recipeTableView.delegate = self;
        _recipeTableView.dataSource = self;
        [self.view addSubview:_recipeTableView];
        NSMutableArray *tableviewconstraints = @[].mutableCopy;
        [tableviewconstraints addObject:[NSLayoutConstraint constraintWithItem:_recipeTableView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant: 0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint constraintWithItem:_recipeTableView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint constraintWithItem:_recipeTableView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0]];
        [tableviewconstraints addObject:[NSLayoutConstraint constraintWithItem:_recipeTableView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0]];
        [self.view addConstraints:tableviewconstraints];
    }
    
}

- (void) noNetworkAlertRefreshButtonPressed {
    [self getInformationData];
}

#pragma mark tableview delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return 2 + _introductionDataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kScreenWidth/4*3+_recipePicture.calculatedIntroductionCardHeight+60;
    }
    else if (indexPath.row > 0 && indexPath.row <= _introductionDataArray.count) {
        return [_introductionCellHeightArray[indexPath.row - 1] floatValue];
    }
    
    else if (indexPath.row == _introductionDataArray.count + 1) {
        return _videoCellHeight;
        
    }
    
    else return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationContentTableViewCell *cell = [[InformationContentTableViewCell alloc]init];
    // cell.delegate = self;
    if(indexPath.row > 0 && indexPath.row <= _introductionDataArray.count){
        
        cell.recipeIntroductionObject = _introductionDataArray[indexPath.row - 1];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    else if(indexPath.row==_introductionDataArray.count+1){
        cell.hasMoreVideoMenu=_hasMoreVideo;
        cell.videoMenuDataArray=_videoDataArray;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row==0){
        cell.recipePictureObjcet=_recipePicture;
        cell.introductionView.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    return nil;
}


- (void)likeClicked:(id) sender{
    NSLog(@"Liked!");
}

- (void)shareClicked:(id) sender{
    NSLog(@"Shared!!");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
