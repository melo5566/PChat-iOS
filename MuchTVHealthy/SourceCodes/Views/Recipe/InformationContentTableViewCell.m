//
//  InformationContentTableTableViewCell.m
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/7/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//
#import "InformationContentTableViewCell.h"

@interface InformationContentTableViewCell ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView                   *videoTableView;
@property (nonatomic, strong) UIView                        *discussionHeader;
@property (nonatomic, strong) UIView                        *normalHeader;
@property (nonatomic, strong) UILabel                       *headerLabel;

@end
@implementation InformationContentTableViewCell

static CGFloat const cellPadding      = 20;

// this method is just for testing will be deleted soon
//- (void) initTableVieww{
//    if (!_discussionTableView) {
//        _discussionTableView=[[UITableView alloc]initForAutolayout];
//        
//        _discussionTableView.dataSource = self;
//        _discussionTableView.delegate = self;
//        _discussionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        
//        [_discussionTableView setLayoutMargins:UIEdgeInsetsZero];
//        _discussionTableView.separatorColor = [UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
//        _discussionTableView.scrollEnabled = NO;
//        
//        _discussionTableView.clipsToBounds=NO;
//        
//        //ORIGINALSS
//        [self.contentView addSubview:_discussionTableView];
//        NSMutableArray *tableViewConstaint = @[].mutableCopy;
//        [tableViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_discussionTableView
//                                                                   attribute:NSLayoutAttributeTop
//                                                                   relatedBy:NSLayoutRelationEqual
//                                                                      toItem:self
//                                                                   attribute:NSLayoutAttributeTop
//                                                                  multiplier:1.0f constant:0]];
//        [tableViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_discussionTableView
//                                                                   attribute:NSLayoutAttributeHeight
//                                                                   relatedBy:NSLayoutRelationEqual
//                                                                      toItem:nil
//                                                                   attribute:NSLayoutAttributeNotAnAttribute
//                                                                  multiplier:1.0f constant:350]];
//        [tableViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_discussionTableView
//                                                                   attribute:NSLayoutAttributeLeft
//                                                                   relatedBy:NSLayoutRelationEqual
//                                                                      toItem:self
//                                                                   attribute:NSLayoutAttributeLeft
//                                                                  multiplier:1.0f constant:0]];
//        [tableViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_discussionTableView
//                                                                   attribute:NSLayoutAttributeRight
//                                                                   relatedBy:NSLayoutRelationEqual
//                                                                      toItem:self
//                                                                   attribute:NSLayoutAttributeRight
//                                                                  multiplier:1.0f constant:0]];
//        [self addConstraints:tableViewConstaint];
//    }
//    _discussionTableView.clipsToBounds=NO;
//    _discussionTableView.layer.masksToBounds = NO;
//    _discussionTableView.backgroundColor=[UIColor colorWithHexString:kDefaultBackGroundColorHexString];
//    [_discussionTableView.layer setShadowColor:[UIColor blackColor].CGColor];
//    [_discussionTableView.layer setShadowOpacity:0.5];
//    [_discussionTableView.layer setShadowOffset:CGSizeMake(0, 0.5)];
//}

- (void) setTableView:(UITableView*)tableView{
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    tableView.separatorColor = [UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
    tableView.scrollEnabled = NO;
    tableView.clipsToBounds = NO;
    [self.contentView addSubview:tableView];
    NSMutableArray *tableViewConstaint = @[].mutableCopy;
    [tableViewConstaint addObject:[NSLayoutConstraint constraintWithItem:tableView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0f constant:0]];
    [tableViewConstaint addObject:[NSLayoutConstraint constraintWithItem:tableView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0f constant:-cellPadding]];
    [tableViewConstaint addObject:[NSLayoutConstraint constraintWithItem:tableView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0f constant:0]];
    [tableViewConstaint addObject:[NSLayoutConstraint constraintWithItem:tableView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0f constant:0]];
    [self addConstraints:tableViewConstaint];
    [tableView.layer setShadowColor:[UIColor blackColor].CGColor];
    [tableView.layer setShadowOpacity:0.5];
    [tableView.layer setShadowOffset:CGSizeMake(0, 0.5)];
    //    [tableView reloadData];
}
//video for recipe
- (void) setVideoMenuDataArray:(NSMutableArray *)videoMenuDataArray{
    _videoMenuDataArray = videoMenuDataArray;
    if ([_videoMenuDataArray isNotEmpty]) {
        _videoTableView=[[UITableView alloc]initForAutolayout];
        [self setTableView:_videoTableView];
    }
}


//introduction for recipe
- (void) setRecipeIntroductionObject:(RecipeIntroductionObject *)recipeIntroductionObject{
    _introductionView = [[InformationIntroductionView alloc] initForAutolayout];
    _introductionView.introductionObject=recipeIntroductionObject;
    [self setIntroductionView:_introductionView];
}
//intropic for recipe
-(void) setRecipePictureObjcet:(RecipePictureObject *)recipePictureObjcet{
    _introductionView = [[InformationIntroductionView alloc] initForAutolayout];
    _introductionView.recipePictureObject=recipePictureObjcet;
    [self setIntroductionView:_introductionView];
}
- (void) setIntroductionView:(UIView*)view{
    [self.contentView addSubview:view];
    NSMutableArray *constraints = @[].mutableCopy;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f constant:-cellPadding]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f constant:0]];
    [self addConstraints:constraints];
}

#pragma mark - UITableView data source and delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
        if (_videoMenuDataArray.count >= 3) {
            return 3;
        }
        else {
            return _videoMenuDataArray.count;
        }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  kHeaderHeightIncludingThick1Height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kkGlobalCardCellHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _videoTableView) {
        if (_hasMoreVideoMenu) {
            return kkGlobalFooterHeight;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(!_normalHeader){
        _normalHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeightIncludingThick1Height)];
        _normalHeader.backgroundColor=[UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
        _headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 29)];
        _headerLabel.textColor=[UIColor colorWithHexString:kCellTitleLabelTextColor];
        _headerLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:21];
        _headerLabel.backgroundColor=[UIColor whiteColor];
        [_normalHeader addSubview:_headerLabel];
    }
    _headerLabel.text=@" 相關影音";
    return _normalHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *uiv=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    uiv.backgroundColor=[UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:uiv];
    UIImageView *loadMoreImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-7, 10, 15, 10)];
    //UIImageView *loadMoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 30)/2 - 15, 0, 30, 30)];
    loadMoreImageView.backgroundColor = [UIColor clearColor];
    [loadMoreImageView setImage:[UIImage imageNamed:@"icon_more"]];
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setFrame:CGRectMake((kScreenWidth - 30)/2 - 15, 0, 30, 30)];
    //    button.backgroundColor = [UIColor clearColor];
    //    [button setImage:[UIImage imageNamed:@"Icon_Load_More"] forState:UIControlStateNormal];
    [footerView addSubview:loadMoreImageView];
    // UITapGestureRecognizer *moreVideoTap = [[UITapGestureRecognizer alloc]
    // initWithTarget:self action:@selector(videoTableFooterViewPressed:)];
    // [footerView addGestureRecognizer:moreVideoTap];
    return footerView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"InformationCardTableViewCell";
    InformationCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell=[[InformationCardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.recipeVideoObject = _videoMenuDataArray[indexPath.row];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* if (tableView == _videoTableView) {
     if ([self.delegate respondsToSelector:@selector(goPlayVideo:title:)]) {
     InformationVideoObject *object = _videoDataArray[indexPath.row];
     [self.delegate goPlayVideo:object.videourl title:object.content];
     }
     }
     else if(tableView==_fanspageTableView){
     InformationFanpageObject *object = _fanspageDataArray[indexPath.row];
     if ([object.link isNotEmpty]) {
     NSString *url = [NSString stringWithFormat:@"fb://story?id=%@",object.postId];
     if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]){
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
     }
     else {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:object.link]];
     }
     }
     }
     else if(tableView==_recommendationTableView){
     if ([self.delegate respondsToSelector:@selector(goPlayVideo:title:)]) {
     CelebrityVideoObject *object = _videoCelebrityDataArray[indexPath.row];
     [self.delegate goPlayVideo:object.videourl title:object.content];
     }
     }
     
     else if(tableView == _discussionTableView) {
     if ([self.delegate respondsToSelector:@selector(goCelebrityDiscussion:)]) {
     DiscussionObject *object = _discussionceleBrityDataArray[indexPath.row];
     [self.delegate goCelebrityDiscussion:object];
     
     }
     }*/
}
#pragma mark delegate methods
/*
 - (void) fanspageTableFooterViewPressed:(id)sender{
 
 if ([self.delegate respondsToSelector:@selector(goMoreFanspage)]) {
 [self.delegate goMoreFanspage];
 }
 }
 
 - (void) videoTableFooterViewPressed:(id)sender {
 
 if ([self.delegate respondsToSelector:@selector(goMoreVideo)]) {
 [self.delegate goMoreVideo];
 }
 }
 - (void) videocelebrityTableFooterPressed:(id)sender {
 
 if([self.delegate respondsToSelector:@selector(goMoreCelebrityVideo:)]){
 [self.delegate goMoreCelebrityVideo:_celebrityid];}
 }
 - (void) discussioncelebrityTableFooterPressed:(id)sender {
 if ([self.delegate respondsToSelector:@selector(goMoreCelebrityDiscussion)]) {
 [self.delegate goMoreCelebrityDiscussion];
 }}*/



@end
