//
//  FrontpageViewController.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "FrontpageViewController.h"
#import "FrontpageTableViewCell.h"
#import "FrontpageModel.h"
#import "FrontpageObject.h"
#import "PersonalSettingViewController.h"
#import "PostNewDiscussionViewController.h"
#import "SignUpAndSignInModel.h"
#import "DiscussionSingleViewController.h"


@interface FrontpageViewController () <UITableViewDataSource, UITableViewDelegate, FrontpageModelDelegate>
@property (nonatomic, strong) UIView                            *menuView;
@property (nonatomic, strong) UIView                            *fanzytvLogoView;
@property (nonatomic, strong) UILabel                           *userNameLabel;
@property (nonatomic, strong) UIButton                          *menuButton;
@property (nonatomic, strong) UIButton                          *settinButton;
@property (nonatomic, strong) UIImageView                       *avatarImageView;
@property (nonatomic, strong) UIImageView                       *fanzytvLogo;
@property (nonatomic, strong) UITableView                       *frontpageTableView;
@property (nonatomic, strong) NSMutableArray                    *frontpageDataArray;
@property (nonatomic, strong) NSLayoutConstraint                *menuViewRightLayoutConstraint;
@property (nonatomic, strong) FrontpageModel                    *frontpageModel;
@property (nonatomic, strong) KiiUser                           *currentUser;
@property (nonatomic, strong) CAGradientLayer                   *gradient;
@property (nonatomic, strong) UIRefreshControl                  *refreshControl;
@property (nonatomic) NSUInteger                                loadingStartIndex;
@property (nonatomic) BOOL                                      isShownMenuView;
@property (nonatomic) BOOL                                      hasMoreFrontpageData;
@property (nonatomic) BOOL                                      isLoadingMoreFrontpageData;
@end


@implementation FrontpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *customizedButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame           = CGRectMake(0, 0, 30, 30);
    UIImage *iconImage               = [UIImage imageNamed:[NSString stringWithFormat:@"icon_setting"]];
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    navigatinBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem = navigatinBarButtonItem;
    
    UIButton *postDiscussionButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    postDiscussionButton.backgroundColor = [UIColor clearColor];
    postDiscussionButton.frame           = CGRectMake(0, 0, 30, 30);
    UIImage *image               = [UIImage imageNamed:[NSString stringWithFormat:@"icon_setting"]];
    [postDiscussionButton setImage:image forState:UIControlStateNormal];
    [postDiscussionButton addTarget:self action:@selector(postDiscussionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:postDiscussionButton];
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem1;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isShownMenuView            = NO;
    _frontpageTableView.hidden  = YES;
    if ([KiiUser currentUser]) {
        _currentUser = [KiiUser currentUser];
    } else {
        _currentUser = nil;
    }
    
    [self resetParams];
    [self firstLoadFrontpageData];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view removeConstraint:_menuViewRightLayoutConstraint];
    [UIView animateWithDuration:0.5
                     animations:^{
                         _menuViewRightLayoutConstraint = [NSLayoutConstraint constraintWithItem:_menuView
                                                                                       attribute:NSLayoutAttributeRight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.view
                                                                                       attribute:NSLayoutAttributeLeft
                                                                                      multiplier:1.0f constant:0.0f];
                         
                         [self.view addConstraint:_menuViewRightLayoutConstraint];
                         [self.view layoutIfNeeded];
                     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - inits
- (void) initFrontpageTableView {
    if (!_frontpageTableView) {
        _frontpageTableView                         = [[UITableView alloc] initForAutolayout];
        _frontpageTableView.delegate                = self;
        _frontpageTableView.dataSource              = self;
        _frontpageTableView.backgroundColor         = [UIColor clearColor];
        _frontpageTableView.separatorStyle          = UITableViewCellSeparatorStyleNone;
        _frontpageTableView.scrollIndicatorInsets   = UIEdgeInsetsMake(0, 0, 0, -10);
        _frontpageTableView.clipsToBounds           = NO;
        
        [self.view insertSubview:_frontpageTableView atIndex:0];
        
        NSMutableArray *frontpageTableViewConstraint = [[NSMutableArray alloc] init];
        
        [frontpageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageTableView
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0f constant:10.0f]];
        [frontpageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageTableView
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0f constant:-10.0f]];
        [frontpageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageTableView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0f constant:15.0f]];
        [frontpageTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageTableView
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f constant:-15.0f]];
        
        [self.view addConstraints:frontpageTableViewConstraint];
        if (!_refreshControl) {
            _refreshControl = [[UIRefreshControl alloc] init];
            [_refreshControl addTarget:self
                                action:@selector(refreshFrontpage)
                      forControlEvents:UIControlEventValueChanged];
            [_frontpageTableView addSubview:_refreshControl];
            
        }

    }
    [_frontpageTableView reloadData];

}

- (void) initMenuView {
    if (!_menuView) {
        _menuView                 = [[UIView alloc] initForAutolayout];
        _menuView.backgroundColor = [UIColor colorWithR:0 G:125 B:125];
        
        [self.view addSubview:_menuView];

        NSMutableArray *menuViewConstraint = [[NSMutableArray alloc] init];
        
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_menuView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kScreenWidth*3/5]];
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_menuView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f constant:0.0f]];
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_menuView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:0.0f]];
        
        _menuViewRightLayoutConstraint = [NSLayoutConstraint constraintWithItem:_menuView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f];
        
        [self.view addConstraints:menuViewConstraint];
        [self.view addConstraint:_menuViewRightLayoutConstraint];

    }
}

- (void) initAvatarImageView {
    if (!_avatarImageView) {
        _avatarImageView                    = [[UIImageView alloc] initForAutolayout];
        _avatarImageView.alpha              = 1.0f;
        _avatarImageView.layer.borderWidth  = 5.0f;
        _avatarImageView.layer.borderColor  = [UIColor whiteColor].CGColor;
        _avatarImageView.backgroundColor    = [UIColor clearColor];
        _avatarImageView.layer.cornerRadius = (kScreenWidth*3/5 - 80) / 2;
        _avatarImageView.contentMode        = UIViewContentModeScaleAspectFill;
        _avatarImageView.clipsToBounds      = YES;
        [_menuView addSubview:_avatarImageView];

        
        NSMutableArray *avatarConstraint = @[].mutableCopy;
        
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_menuView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:40.0f]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_menuView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:30.0f]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_menuView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f constant:-40.0f]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0f constant:0.0f]];

        [self.view addConstraints:avatarConstraint];
        
    }
    
}

- (void) initUserNameLabel {
    if (!_userNameLabel) {
        _userNameLabel                    = [[UILabel alloc] initForAutolayout];
        _userNameLabel.backgroundColor    = [UIColor clearColor];
        _userNameLabel.font               = [UIFont systemFontOfSize:17.0f];
        _userNameLabel.textAlignment      = UITextAlignmentCenter;
        [_menuView addSubview:_userNameLabel];
        
        NSMutableArray *nameViewConstraint = @[].mutableCopy;
        
        [nameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:0.0f]];
        [nameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f constant:10.0f]];
        [nameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f constant:0.0f]];
        [nameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:nameViewConstraint];
        
    }
    if (_currentUser)
        _userNameLabel.text = _currentUser.displayName;
    else
        _userNameLabel.text = @"User";
}

- (void)initMenuButton {
    NSArray *buttonArray = @[@"首頁",@"訊息中心",@"節目影音",@"達人專區",@"食譜"];
    for (int i = 0; i < buttonArray.count; i++) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _menuButton.tag = i;
        [_menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _menuButton.backgroundColor = [UIColor colorWithR:0 G:139+5*i B:139+10*i];
        
        [_menuButton setTitle:buttonArray[i] forState:UIControlStateNormal];
        [_menuButton setTitleColor:[UIColor colorWithR:255 G:255 B:255] forState:UIControlStateNormal];
        _menuButton.titleLabel.font     = [UIFont systemFontOfSize:18];
        [_menuView addSubview:_menuButton];
        
        NSMutableArray *menuButtonConstaint = @[].mutableCopy;
        
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_menuButton
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_menuView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:0.0f]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_menuButton
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_userNameLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:kFrameHeight*30/600 + i*kFrameHeight*55/600]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_menuButton
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:kFrameHeight*55/600]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_menuButton
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_menuView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:menuButtonConstaint];
        
    }

}

- (void) initFanzytvLogoView {
    if (!_fanzytvLogoView) {
        _fanzytvLogoView                 = [[UIView alloc] initForAutolayout];
        _fanzytvLogoView.backgroundColor = [UIColor colorWithR:35 G:85 B:85];
        [_menuView addSubview:_fanzytvLogoView];
        
        NSMutableArray *fanzytvLogoConstaint = @[].mutableCopy;
        
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_menuView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_menuButton
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_menuView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_menuView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:fanzytvLogoConstaint];
        
        
    }
}


- (void) initFanzytvLogo {
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


- (void) initSettingButton {
    if (!_settinButton) {
        _settinButton  = [[UIButton alloc] initForAutolayout];
        [_settinButton setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
        [_settinButton addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:_settinButton];
        
        
        NSMutableArray *settingButtonConstraint = @[].mutableCopy;
        
        [settingButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_settinButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_menuView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-5.0f]];
        [settingButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_settinButton
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_menuView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:5.0f]];
        [settingButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_settinButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:30.0f]];
        [settingButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_settinButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:settingButtonConstraint];

    }
}

#pragma mark - methods
- (void) firstLoadFrontpageData {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"讀取中..." delayToHide:-1];
    
    if (!_frontpageModel) {
        _frontpageModel = [[FrontpageModel alloc] init];
        _frontpageModel.delegate = self;
    }
    
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    
    if (_loadingStartIndex != 0) {
        _loadingStartIndex = 0;
    }
    
    [_frontpageModel loadFrontpageData];
//    [_frontpageTableView reloadData];
}

- (void)loadMoreFrontpageData {
    if (!_frontpageModel) {
        _frontpageModel = [[FrontpageModel alloc] init];
        _frontpageModel.delegate = self;
    }
    _loadingStartIndex += 1;
    [_frontpageModel executeMoreFrontpageData];
}

- (void) resetParams {
    _isLoadingMoreFrontpageData = NO;
    _loadingStartIndex = 0;
    _hasMoreFrontpageData = YES;
    _frontpageDataArray = @[].mutableCopy;
}

- (void) initMenuLayout {
    [self initMenuView];
    [self initAvatarImageView];
    [self initUserNameLabel];
    [self initMenuButton];
    [self initFanzytvLogoView];
    [self initFanzytvLogo];
    [self initSettingButton];
}

- (void) refreshFrontpage {
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    
    [self firstLoadFrontpageData];
}

#pragma mark - button action
- (void)postDiscussionButtonClicked:(id)sender {
    PostNewDiscussionViewController *controller = [PostNewDiscussionViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)settingButtonPressed:(id)sender {
    [self.view removeConstraint:_menuViewRightLayoutConstraint];
    if (_isShownMenuView) {
        _isShownMenuView = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             _menuViewRightLayoutConstraint = [NSLayoutConstraint constraintWithItem:_menuView
                                                                                           attribute:NSLayoutAttributeRight
                                                                                           relatedBy:NSLayoutRelationEqual
                                                                                              toItem:self.view
                                                                                           attribute:NSLayoutAttributeLeft
                                                                                          multiplier:1.0f constant:0.0f];
                             
                             [self.view addConstraint:_menuViewRightLayoutConstraint];
                             [self.view layoutIfNeeded];
                         }];

    } else {
        _isShownMenuView = YES;
        [UIView animateWithDuration:0.5
                         animations:^{
                             _menuViewRightLayoutConstraint = [NSLayoutConstraint constraintWithItem:_menuView
                                                                                           attribute:NSLayoutAttributeRight
                                                                                           relatedBy:NSLayoutRelationEqual
                                                                                              toItem:self.view
                                                                                           attribute:NSLayoutAttributeLeft
                                                                                          multiplier:1.0f constant:kScreenWidth*3/5];
                             
                             [self.view addConstraint:_menuViewRightLayoutConstraint];
                             [self.view layoutIfNeeded];
                         }];
        
    }
    
}

- (void)menuButtonClicked:(id)sender {
    UIButton *button = sender;
    NSLog(@"%lu",button.tag);
    if (button.tag == 0) {
        DiscussionSingleViewController *singleViewController = [DiscussionSingleViewController new];
        [self.navigationController pushViewController:singleViewController animated:YES];
    }
}


- (void)settingButtonClicked:(id)sender {
    PersonalSettingViewController *controller = [[PersonalSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - frontpage model delegate
- (void)didLoadFrontpageData:(NSArray *)data {
    [self.hud hide:YES];
    self.navigationItem.leftBarButtonItem.enabled  = YES;
    [_frontpageDataArray addObjectsFromArray:data];
    
    
    if (_loadingStartIndex == 0) {
        [self resetParams];
        [_frontpageDataArray addObjectsFromArray:data];
        [self initFrontpageTableView];
        _frontpageTableView.hidden = NO;
        [_frontpageTableView reloadData];
    } else {
        [_frontpageDataArray addObjectsFromArray:data];
        [_frontpageTableView reloadData];
    }
    if (!_menuView) {
        [self initMenuLayout];
    }
    
    if (_currentUser) {
         _userNameLabel.text   = _currentUser.displayName;
        [_avatarImageView setImageWithURL:[NSURL URLWithString:[_currentUser getObjectForKey:@"avatar"]]
                     withPlaceholderImage:[UIImage imageNamed:@"image_preset_avatar"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    if (image) {
                                        [_avatarImageView setImage:image];
                                        _avatarImageView.alpha = 0;
                                        [UIView animateWithDuration:0.3 animations:^(){
                                            [_avatarImageView setImage:image];
                                            _avatarImageView.alpha = 0.9;
                                        }];
                                    } else {
                                        NSLog(@"Error");
                                    }
                                }
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
    } else {
        _userNameLabel.text     = @"User";
        _avatarImageView.image  = [UIImage imageNamed:@"image_preset_avatar"];
    }
    
}


#pragma mark - UITableView data source and delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _frontpageDataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 15 + (kScreenWidth-30-5)*3.0f/4.0f + 7.8f + 43.0f + 5.0f + 21.5f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FrontpageTableViewCell";
    FrontpageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[FrontpageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.frontpageObject = _frontpageDataArray[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _frontpageDataArray.count - 1 && _hasMoreFrontpageData && _frontpageDataArray.count >= 5 && !_isLoadingMoreFrontpageData) {
        _isLoadingMoreFrontpageData = YES;
        
        dispatch_async(dispatch_get_main_queue(),^{
            NSRange range = NSMakeRange(0, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [_frontpageTableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
        });
        
        [self loadMoreFrontpageData];
        
    }

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
