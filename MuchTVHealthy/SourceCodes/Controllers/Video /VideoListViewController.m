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
@property (nonatomic, strong) UITableView                       *videoListTableView;
@property (nonatomic, strong) UIView                            *videoMenuView;
@property (nonatomic, strong) UIView                            *fanzytvLogoView;
@property (nonatomic, strong) UIView                            *classifiedView;
@property (nonatomic, strong) UIButton                          *videoMenuButton;
@property (nonatomic, strong) UIImageView                       *fanzytvLogo;
@property (nonatomic, strong) NSLayoutConstraint                *videoMenuViewLeftLayoutConstraint;
@property (nonatomic) BOOL                                      isShownVideoMenuView;
@property (nonatomic) BOOL                                      isFirstLoad;
@property (nonatomic) BOOL                                      hasMoreVideoData;
@end

@implementation VideoListViewController

#pragma mark System
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"節目影音";
    [self initListButton];
    
    UIButton *customizedButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame           = CGRectMake(0, 0, 25, 25);
    UIImage *iconImage               = [UIImage imageNamed:[NSString stringWithFormat:@"icon_category"]];
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(videoMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    navigatinBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
    
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
    [self initVideoMenuLayout];

  }

- (void) viewDidDisappear:(BOOL)animated {
    [self dismissMenu];
}

- (void) viewDidAppear:(BOOL)animated {
    [self initMenuLayout];
    [self initGestureRecognizer];
    [self initVideoGestureRecognizer];
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

#pragma mark - init
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

- (void) initVideoMenuLayout {
    [self initVideoMenuView];
    [self initVideoMenuButton];
    [self initVideoFanzytvLogoView];
    [self initVideoFanzytvLogo];
}


- (void) initVideoMenuView {
    if (!_videoMenuView) {
        _videoMenuView                 = [[UIView alloc] initForAutolayout];
        _videoMenuView.backgroundColor = [UIColor colorWithHexString:@"#2a7372"];
        
        [self.view addSubview:_videoMenuView];
        
        NSMutableArray *menuViewConstraint = [[NSMutableArray alloc] init];
        
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_videoMenuView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kScreenWidth*3/5]];
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_videoMenuView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f constant:0.0f]];
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_videoMenuView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:0.0f]];
        
        _videoMenuViewLeftLayoutConstraint = [NSLayoutConstraint constraintWithItem:_videoMenuView
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0f constant:0.0f];
        
        [self.view addConstraints:menuViewConstraint];
        [self.view addConstraint:_videoMenuViewLeftLayoutConstraint];
        
    }
}


- (void)initVideoMenuButton {
    NSArray *buttonArray = @[@"分類",@"全 部",@"達 人",@"保 健",@"甜 點",@"家 常"];
    for (int i = 0; i < buttonArray.count; i++) {
        _videoMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoMenuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _videoMenuButton.tag = i;
        [_videoMenuButton addTarget:self action:@selector(videoMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_videoMenuButton setTitle:buttonArray[i] forState:UIControlStateNormal];
        [_videoMenuButton setTitleColor:[UIColor colorWithR:255 G:255 B:255] forState:UIControlStateNormal];
        _videoMenuButton.titleLabel.font     = [UIFont systemFontOfSize:18];
        [_videoMenuView addSubview:_videoMenuButton];
        
        NSMutableArray *menuButtonConstaint = @[].mutableCopy;
        
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_videoMenuButton
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_videoMenuView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:0.0f]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_videoMenuButton
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_videoMenuView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:i*kFrameHeight*55/600]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_videoMenuButton
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:kFrameHeight*55/600]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_videoMenuButton
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_videoMenuView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:menuButtonConstaint];
        
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight*55/600 -1, kScreenWidth*3/5, 1)];
        borderView.backgroundColor = [UIColor colorWithHexString:@"#4f9999"];
        [_videoMenuButton addSubview:borderView];
    }
    
}

- (void) initVideoFanzytvLogoView {
    if (!_fanzytvLogoView) {
        _fanzytvLogoView                 = [[UIView alloc] initForAutolayout];
        [_videoMenuView addSubview:_fanzytvLogoView];
        
        NSMutableArray *fanzytvLogoConstaint = @[].mutableCopy;
        
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_videoMenuView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_videoMenuView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:100.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_videoMenuView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:fanzytvLogoConstaint];
        
        
    }
}


- (void) initVideoFanzytvLogo {
    if (!_fanzytvLogo) {
        _fanzytvLogo = [[UIImageView alloc] initForAutolayout];
        _fanzytvLogo.backgroundColor = [UIColor clearColor];
        _fanzytvLogo.image = [UIImage imageNamed:@"fanzytv_btn@2x"];
        
        [_fanzytvLogoView addSubview:_fanzytvLogo];
        
        NSMutableArray *fanzytvLogoConstaint = @[].mutableCopy;
        
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogo
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:20.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogo
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:kFrameHeight*20/600]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogo
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:-kFrameHeight*20/600]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogo
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:-20.0f]];
        
        [self.view addConstraints:fanzytvLogoConstaint];
        
    }
}

- (void) initVideoGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *swipeLeft = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(videoSwipeLeft)];
    [swipeLeft setEdges:UIRectEdgeRight];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(videoSwipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_videoMenuView addGestureRecognizer:swipeRight];
}


#pragma mark - button action
- (void)videoMenuButtonClicked:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            NSLog(@"%d",button.tag);
            break;
        } case 1: {
            NSLog(@"%d",button.tag);
            break;
        } case 2: {
            NSLog(@"%d",button.tag);
            break;
        } case 3: {
            NSLog(@"%d",button.tag);
            break;
        } case 4: {
            NSLog(@"%d",button.tag);
            break;
        } case 5: {
            NSLog(@"%d",button.tag);
            break;
        }
        default:
            break;
    }
    
}


- (void)videoMenuButtonPressed:(id)sender {
    [self.view removeConstraint:_videoMenuViewLeftLayoutConstraint];
    if (_isShownVideoMenuView) {
        [self dismissVideoMenu];
    } else {
        if (self.isShownMenuView) {
            [self dismissMenu];
        }
        [self showVideoMenu];
    }
    
}

- (void) dismissVideoMenu {
    _isShownVideoMenuView = NO;
    [self.view removeConstraint:_videoMenuViewLeftLayoutConstraint];
    [UIView animateWithDuration:0.5
                     animations:^{
                         _videoMenuViewLeftLayoutConstraint = [NSLayoutConstraint constraintWithItem:_videoMenuView
                                                                                            attribute:NSLayoutAttributeLeft
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:self.view
                                                                                            attribute:NSLayoutAttributeRight
                                                                                           multiplier:1.0f constant:0.0f];
                         
                         [self.view addConstraint:_videoMenuViewLeftLayoutConstraint];
                         [self.view layoutIfNeeded];
                     }];
    
}

- (void) showVideoMenu {
    _isShownVideoMenuView = YES;
    [UIView animateWithDuration:0.5
                     animations:^{
                         _videoMenuViewLeftLayoutConstraint = [NSLayoutConstraint constraintWithItem:_videoMenuView
                                                                                            attribute:NSLayoutAttributeLeft
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:self.view
                                                                                            attribute:NSLayoutAttributeRight
                                                                                           multiplier:1.0f constant:-kScreenWidth*3/5];
                         
                         [self.view addConstraint:_videoMenuViewLeftLayoutConstraint];
                         [self.view layoutIfNeeded];
                     }];
    
}

- (void) showMenu {
    if (_isShownVideoMenuView) {
        [self dismissVideoMenu];
    }
    self.isShownMenuView = YES;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.menuViewRightLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.menuView
                                                                                           attribute:NSLayoutAttributeRight
                                                                                           relatedBy:NSLayoutRelationEqual
                                                                                              toItem:self.view
                                                                                           attribute:NSLayoutAttributeLeft
                                                                                          multiplier:1.0f constant:kScreenWidth*3/5];
                         
                         [self.view addConstraint:self.menuViewRightLayoutConstraint];
                         [self.view layoutIfNeeded];
                     }];
    
}

#pragma mark - swipe
- (void)videoSwipeRight {
    if (_isShownVideoMenuView) {
        [self.view removeConstraint:_videoMenuViewLeftLayoutConstraint];
        [self dismissVideoMenu];
    }
}

- (void)videoSwipeLeft {
    if (!_isShownVideoMenuView) {
        if (self.isShownMenuView) {
            [self dismissMenu];
        }
        [self.view removeConstraint:_videoMenuViewLeftLayoutConstraint];
        [self showVideoMenu];
    }
}

#pragma mark - UITableView data source and delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _videoObject.videoList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return (kScreenWidth)/4*3+45;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"video";
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[VideoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.videoDataObject = _videoObject.videoList[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //CelebrityObject *celebrityobject = (CelebrityObject *)_CelebrityList[indexPath.row];
    //controller.celebrityobject = celebrityobject;
    VideoSingleViewController *controller = [[VideoSingleViewController alloc]init];
    controller.videoDataObject = _videoObject.videoList[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark left delegate
- (void) changeMainScrollable {
    _videoListTableView.scrollEnabled   = _videoListTableView.isScrollEnabled?NO:YES;
    _videoListTableView.allowsSelection = _videoListTableView.allowsSelection?NO:YES;
}




@end
