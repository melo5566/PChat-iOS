//
//  VideoSingleViewController.m
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/8/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "VideoSingleViewController.h"
#import "YoutubeVideoPlayerView.h"
#import "PostNewDiscussionReplyViewController.h"
//#import "InformationCardTableViewCell.h"
//#import "replyPageViewController.h"

@interface VideoSingleViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView                               *videoTableView;
@property (nonatomic, strong) NSString                                  *pictureurl;
@property (nonatomic, strong) YoutubeVideoPlayerView                    *playerView;
@property (nonatomic, strong) UIImageView                               *mainImageView;
@property (nonatomic, strong) UIButton                                  *shareButton;
@property (nonatomic, strong) UIButton                                  *replyaButton;
@property (nonatomic, strong) NSAttributedString                        *attachmentString;
@property (nonatomic, strong) UIImageView                               *logoImage;
@end

@implementation VideoSingleViewController
static CGFloat const widthPadding      = 2*kkGlobalDefaultPadding+3;


- (void)setVideoDataObject:(VideoDataObject *)videoDataObject {
    _videoDataObject = videoDataObject;
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    self.title = _videoDataObject.title;
    self.view.backgroundColor=[UIColor colorWithHexString:kVideoBackGroundColorHexString];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initTableView];
    
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _playerView.playerView.delegate=nil;
    _playerView.playerView=nil;
    _playerView=nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initTableView{
    if (!_videoTableView) {
        _videoTableView=[[UITableView alloc]initForAutolayout];
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        [self.view addSubview:_videoTableView];
        NSMutableArray *Constraint = [[NSMutableArray alloc] init];
        
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_videoTableView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0f constant:kkGlobalDefaultPadding]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_videoTableView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0f constant:widthPadding]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_videoTableView
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0f constant:-widthPadding]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_videoTableView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0f constant:kScreenWidth/16*9+3*kkGlobalDefaultPadding+100]];
        
        [self.view addConstraints:Constraint];
        [_videoTableView.layer setShadowColor:[UIColor blackColor].CGColor];
        [_videoTableView.layer setShadowOpacity:0.5];
        [_videoTableView.layer setShadowOffset:CGSizeMake(0, 0.5)];
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_videoTableView setLayoutMargins:UIEdgeInsetsZero];
        _videoTableView.separatorColor = [UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
        _videoTableView.scrollEnabled = NO;
         _videoTableView.showsVerticalScrollIndicator=YES;
        _videoTableView.clipsToBounds=NO;
        _videoTableView.layer.masksToBounds = NO;
    }
    if(!_logoImage){
        _logoImage=[[UIImageView alloc]initForAutolayout];
        _logoImage.image=[UIImage imageNamed:@"btn_fanzytv.png"];
        [self.view addSubview:_logoImage];
        NSMutableArray *Constraint = [[NSMutableArray alloc] init];
    
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_logoImage
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_videoTableView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0f constant:40]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_logoImage
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0f constant:0]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_logoImage
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0f constant:40]];
        [Constraint addObject:[NSLayoutConstraint constraintWithItem:_logoImage
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0f constant:140]];
    
        [self.view addConstraints:Constraint];
    
    }}

#pragma mark tableview delegates

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kScreenWidth/16*9+3*kkGlobalDefaultPadding;
    }
    //     else if (indexPath.row > 1 && indexPath.row <= _introductionDataArray.count+1) {
    //     return [_introductionCellHeightArray[indexPath.row - 2] floatValue];
    //     }
    //     else if (indexPath.row == _introductionDataArray.count + 2) {
    //     return _videoCellHeight;
    //     }
    //     else if (indexPath.row == 1) {
    //     return _discussionCellHeight;
    //     }
    //     else {
    //     return 15;
    //     }
    else if(indexPath.row==1)
        return 120;
    else return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"celebritypic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
        if(_videoDataObject.videoURL){
            if (!_playerView) {
                _playerView = [[YoutubeVideoPlayerView alloc] initForAutolayout];
                _playerView.clipsToBounds = YES;
                _playerView.backgroundColor = [UIColor blackColor];
                
                [cell.contentView addSubview:_playerView];
                NSMutableArray *videoPlayerViewConstaint = @[].mutableCopy;
                [videoPlayerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_playerView
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:cell.contentView
                                                                                 attribute:NSLayoutAttributeTop
                                                                                multiplier:1.0f constant:kkGlobalDefaultPadding]];
                [videoPlayerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_playerView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:cell.contentView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                multiplier:1.0f constant:kkGlobalDefaultPadding]];
                [videoPlayerViewConstaint addObject: [NSLayoutConstraint constraintWithItem:_playerView
                                                                                  attribute:NSLayoutAttributeHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:nil
                                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                                 multiplier:1.0f constant:kScreenWidth * 9 / 16]];
                [videoPlayerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_playerView
                                                                                 attribute:NSLayoutAttributeRight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:cell.contentView
                                                                                 attribute:NSLayoutAttributeRight
                                                                                multiplier:1.0f constant:-kkGlobalDefaultPadding]];
                [cell.contentView addConstraints:videoPlayerViewConstaint];
                
                _playerView.youtubeID = [_videoDataObject.videoURL getYoutubeVieoCode];
            }
        }
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (indexPath.row == 1) {//////////to modify!!!!!!!!!!!!!!!!!!
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
        
        UIView *frontwhite=[[UIView alloc]initWithFrame:CGRectMake(0, 41, kScreenWidth-2*widthPadding, kkGlobalCardCellHeight)];
        frontwhite.backgroundColor=[UIColor whiteColor];
        [cell addSubview:frontwhite];
        
        if(!_shareButton){
            _shareButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, kScreenWidth-2*widthPadding, 39.5)];}
        [_shareButton addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.backgroundColor=[UIColor whiteColor];
        [cell addSubview:_shareButton];
        
        if(!_attachmentString){
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image=[UIImage imageWithImage:[UIImage imageNamed:@"icon_share.png"] scaledToSize:CGSizeMake(20, 20)];
            _attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];}
        
        NSMutableAttributedString *attachmentShareString = [[NSMutableAttributedString alloc] initWithAttributedString:_attachmentString];
        NSAttributedString *myText = [[NSMutableAttributedString alloc] initWithString:@" 分享" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"STHeitiTC-Light" size:20],NSForegroundColorAttributeName : [UIColor grayColor]}];
        [attachmentShareString appendAttributedString:myText];
        [_shareButton setAttributedTitle:attachmentShareString forState:UIControlStateNormal];
        
        if(!_replyaButton){
            _replyaButton=[[UIButton alloc]initWithFrame:CGRectMake(kkGlobalCardCellHeight+kkGlobalDefaultPadding, 60, kScreenWidth-kkGlobalCardCellHeight-3*widthPadding, 40)];}
        _replyaButton.layer.borderColor=[UIColor colorWithHexString:kReplyIputLabelPresetWordColor].CGColor;
        _replyaButton.layer.borderWidth=1;
        _replyaButton.clipsToBounds=YES;
        _replyaButton.layer.cornerRadius=10;
        
        NSAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:@" 回覆..." attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"STHeitiTC-Light" size:20],NSForegroundColorAttributeName : [UIColor colorWithHexString:kReplyIputLabelPresetWordColor]}];
        _replyaButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_replyaButton setAttributedTitle:mText forState:UIControlStateNormal];
        [_replyaButton addTarget:self action:@selector(goReply) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_replyaButton];
        
        UIImageView *avatar=[[UIImageView alloc]initWithFrame:CGRectMake(kkGlobalDefaultPadding+3, kkGlobalDefaultPadding, kkGlobalCardCellHeight-kkGlobalDefaultPadding*2, kkGlobalCardCellHeight-kkGlobalDefaultPadding*2)];
        avatar.backgroundColor=[UIColor grayColor];
        avatar.image=[UIImage imageNamed:@"image_preset_avatar"];///////to be set to the avatar
        avatar.clipsToBounds=YES;
        avatar.layer.cornerRadius=(kkGlobalCardCellHeight-2*kkGlobalDefaultPadding)/2;
        [frontwhite addSubview:avatar];
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        return cell;
    }

    return cell;}
- (void) goReply {
        PostNewDiscussionReplyViewController *controller=[[PostNewDiscussionReplyViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
}
- (void) goShare{
    NSLog(@"shared");
}
@end
