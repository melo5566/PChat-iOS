//
//  BaseViewController.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonalSettingViewController.h"
#import "FrontpageViewController.h"
#import "DiscussionSingleViewController.h"
#import "ConnoisseurListViewController.h"
#import "RecipeViewController.h"
#import "VideoListViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIAlertView                       *loginAlertView;
//@property (nonatomic, strong) UIView                            *menuView;
@property (nonatomic, strong) UIView                            *fanzytvLogoView;
@property (nonatomic, strong) UILabel                           *userNameLabel;
@property (nonatomic, strong) UIButton                          *menuButton;
@property (nonatomic, strong) UIButton                          *settinButton;
@property (nonatomic, strong) UIImageView                       *avatarImageView;
@property (nonatomic, strong) UIImageView                       *fanzytvLogo;
//@property (nonatomic, strong) NSLayoutConstraint                *menuViewRightLayoutConstraint;
@property (nonatomic, strong) KiiUser                           *currentUser;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarStyle];
    self.view.backgroundColor = [UIColor colorWithHexString:kDefaultBackGroundColorHexString];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
    
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kEventReceiveNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNavigationBarStyle {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.hidesBackButton = YES;
    // set navigation title color
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor grayColor]];
    [shadow setShadowOffset: CGSizeMake(0.0f, 1.0f)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSShadowAttributeName: shadow};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBarColorHexString];
}



- (void) initNavigationBarCloseButtonAtLeft {
    [self initNavigationBarCloseButton:@"LEFT"];
}

- (void) initNavigationBarCloseButtonAtRight {
    [self initNavigationBarCloseButton:@"RIGHT"];
}

- (void) initNavigationBarBackButtonAtLeft {
    [self initNavigationBarBackButton:@"LEFT"];
}

- (void) initNavigationBarBackButtonAtRight {
    [self initNavigationBarBackButton:@"RIGHT"];
}

- (void) initListButton {
    UIButton *customizedButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame           = CGRectMake(0, 0, 25, 25);
    UIImage *iconImage               = [UIImage imageNamed:[NSString stringWithFormat:@"icon_list"]];
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(wholeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    navigatinBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem = navigatinBarButtonItem;
}

- (void) initNavigationBarCloseButton:(NSString *)position {
    UIButton *customizedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame = CGRectMake(0, 0, 20, 20);
    
    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_arrow_back"]];
    
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    if ([position isEqualToString:@"LEFT"]) {
        self.navigationItem.leftBarButtonItem = navigatinBarButtonItem;
    }
    else if ([position isEqualToString:@"RIGHT"]) {
        self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
    }
}

- (void) initNavigationBarBackButton:(NSString *)position {
    UIButton *customizedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame = CGRectMake(0, 0, 20, 20);
    
    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_arrow_back"]];
    
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    if ([position isEqualToString:@"LEFT"]) {
        self.navigationItem.leftBarButtonItem = navigatinBarButtonItem;
    }
    else if ([position isEqualToString:@"RIGHT"]) {
        self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
    }
}

- (void) closeButtonPressed:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) backButtonPressed:(id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showHUDAddedTo:(UIView *)view
               animated:(BOOL)animated
                HUDMode:(MBProgressHUDMode)mode
                   text:(NSString *)text
            delayToHide:(CGFloat)delayToHide
{
    _hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    _hud.mode = mode;
    _hud.labelText = text;
    [_hud show:YES];
    if (delayToHide > 0) {
        [_hud hide:YES afterDelay:delayToHide];
    }
}

- (void) initMenuLayout {
    if ([KiiUser currentUser]) {
        _currentUser = [KiiUser currentUser];
    } else {
        _currentUser = nil;
    }
    [self initMenuView];
    [self initAvatarImageView];
    [self initUserNameLabel];
    [self initMenuButton];
    [self initFanzytvLogoView];
    [self initFanzytvLogo];
    [self initSettingButton];
}


- (void) initMenuView {
    if (!_menuView) {
        _menuView                 = [[UIView alloc] initForAutolayout];
        _menuView.backgroundColor = [UIColor colorWithHexString:@"#4f9999"];
        
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
    
    if (_currentUser) {
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
        _avatarImageView.image  = [UIImage imageNamed:@"image_preset_avatar"];
    }
    
}

- (void) initUserNameLabel {
    if (!_userNameLabel) {
        _userNameLabel                    = [[UILabel alloc] initForAutolayout];
        _userNameLabel.backgroundColor    = [UIColor clearColor];
        _userNameLabel.font               = [UIFont systemFontOfSize:17.0f];
        _userNameLabel.textColor          = [UIColor colorWithHexString:@"#96ffff"];
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
    NSArray *colorArray  = @[@"#438a8a",@"#387f7f",@"#2a7372",@"#216563",@"#135350"];
    for (int i = 0; i < buttonArray.count; i++) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _menuButton.tag = i;
        [_menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _menuButton.backgroundColor = [UIColor colorWithHexString:colorArray[i]];
        
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
        _fanzytvLogoView.backgroundColor = [UIColor colorWithHexString:@"#0c3937"];
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
        [_settinButton setImage:[UIImage imageNamed:@"icon_personal_setting"] forState:UIControlStateNormal];
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

- (void)menuButtonClicked:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            FrontpageViewController *viewController = [FrontpageViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 1: {
            // 訊息
            NSLog(@"%lu",button.tag);
            break;
        }
        case 2: {
            // 資料討論
            NSLog(@"%lu",button.tag);
            VideoListViewController     *viewController = [VideoListViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 3: {
            // 名人堂
            ConnoisseurListViewController *controller = [ConnoisseurListViewController new];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 4: {
            //食譜
            RecipeViewController *controller = [RecipeViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
        default:
            break;
    }
    
}


- (void)settingButtonClicked:(id)sender {
    PersonalSettingViewController *controller = [[PersonalSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)wholeButtonPressed:(id)sender {
    [self.view removeConstraint:_menuViewRightLayoutConstraint];
    if (_isShownMenuView) {
        [self dismissMenu];
    } else {
        [self showMenu];
    }
}

- (void) showMenu {
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

- (void) dismissMenu {
    _isShownMenuView = NO;
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

@end
