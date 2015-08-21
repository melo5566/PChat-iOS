//
//  VideoListViewController.m
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/8/5.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoListTableViewCell.h"
#import "VideoSingleViewController.h"

@interface VideoListViewController ()<UITableViewDataSource, UITableViewDelegate>// yet to set model delegate
@property (nonatomic, strong) UITableView               *videoListTableView;
@property (nonatomic) BOOL                              isFirstLoad;
@property (nonatomic) BOOL                              hasMoreVideoData;


@end

@implementation VideoListViewController

#pragma mark System
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"節目影音";
    [self initListButton];
    //[self initRightPanelButton];
    self.view.backgroundColor=[UIColor clearColor];
    _isFirstLoad = YES;
    [self initModel];
    
}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_isFirstLoad) {
        _isFirstLoad = NO;
        [self initTableView];
        [self firstLoadData];
    }

  }

- (void) viewDidDisappear:(BOOL)animated {
    [self dismissMenu];
}

- (void) viewDidAppear:(BOOL)animated {
    [self initMenuLayout];
}

- (void) initModel {
    if(!_videoModel) {
        _videoModel = [[VideoModel alloc]init];
    }
}

- (void) firstLoadData {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"讀取中..." delayToHide:-1];
    [_videoModel loadVideoDataWithBlock:^(VideoObject *videoObject, BOOL hasMore) {
        [self.hud hide:YES];
        _videoObject = videoObject;
        _hasMoreVideoData = hasMore;
        _videoListTableView.hidden = NO;
        [_videoListTableView reloadData];
    }];

}

- (void)resetParams {

    _hasMoreVideoData = YES;
    if(!_videoObject) {
        _videoObject = nil;
    }
    if(!_videoModel.videoObject) {
        _videoModel.videoObject = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initTableView{
    if (!_videoListTableView) {
        _videoListTableView = [[UITableView alloc] initForAutolayout];
        _videoListTableView.delegate = self;
        _videoListTableView.dataSource = self;
        _videoListTableView.backgroundColor=[UIColor colorWithHexString:kVideoBackGroundColorHexString];
        _videoListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _videoListTableView.showsVerticalScrollIndicator=NO;
        [self.view addSubview:_videoListTableView];
        NSMutableArray *tableviewconstraints = @[].mutableCopy;
        [tableviewconstraints addObject:[NSLayoutConstraint constraintWithItem:_videoListTableView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint constraintWithItem:_videoListTableView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint constraintWithItem:_videoListTableView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0]];
        [tableviewconstraints addObject:[NSLayoutConstraint constraintWithItem:_videoListTableView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0]];
        [self.view addConstraints:tableviewconstraints];
    }
}
#pragma mark - UITableView data source and delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section{
    return _videoObject.videoList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return (kScreenWidth)/4*3+45;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"video";
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[VideoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.videoDataObject = _videoObject.videoList[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CelebrityObject *celebrityobject = (CelebrityObject *)_CelebrityList[indexPath.row];
    //controller.celebrityobject = celebrityobject;
    VideoSingleViewController *controller = [[VideoSingleViewController alloc]init];
    controller.videoDataObject = _videoObject.videoList[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark left delegate
- (void) changeMainScrollable{
    _videoListTableView.scrollEnabled=_videoListTableView.isScrollEnabled?NO:YES;
    _videoListTableView.allowsSelection=_videoListTableView.allowsSelection?NO:YES;
}




@end
