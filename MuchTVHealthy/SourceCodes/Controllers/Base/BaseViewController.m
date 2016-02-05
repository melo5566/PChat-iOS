//
//  BaseViewController.m
//  493_Project
//
//  Created by Peter on 2015/10/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonalSettingViewController.h"
#import "DiscussionSingleViewController.h"
#import "ChatroomViewController.h"
#import "DiscussionListViewController.h"
#import "IntroductionViewController.h"
#import <Parse/Parse.h>

@interface BaseViewController ()
@property (nonatomic, strong) UIAlertView                       *loginAlertView;
//@property (nonatomic, strong) UIView                            *menuView;
@property (nonatomic, strong) UILabel                           *UMLogoView;
@property (nonatomic, strong) UILabel                           *userNameLabel;
@property (nonatomic, strong) UIButton                          *menuButton;
@property (nonatomic, strong) UIButton                          *settinButton;
@property (nonatomic, strong) UIImageView                       *avatarImageView;
@property (nonatomic, strong) UIImageView                       *UMLogo;
//@property (nonatomic, strong) NSLayoutConstraint                *menuViewRightLayoutConstraint;
@property (nonatomic, strong) PFUser                            *currentUser;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarStyle];
    self.view.backgroundColor = [UIColor colorWithHexString:kDefaultBackGroundColorHexString];
    BaseModel *model = [BaseModel new];
    model.delegate = self;
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

- (void) initGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *swipeRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipeRight)];
    [swipeRight setEdges:UIRectEdgeLeft];
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_menuView addGestureRecognizer:swipeLeft];
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
    if ([PFUser currentUser]) {
        _currentUser = [PFUser currentUser];
    } else {
        _currentUser = nil;
    }
    [self initMenuView];
    [self initAvatarImageView];
    [self initUserNameLabel];
    [self initMenuButton];
    [self initUMLogoView];
    [self initUMLogo];
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
                                                                     multiplier:1.0f constant:kScreenWidth*3/5];
        
        
        [self.view addConstraints:menuViewConstraint];
        [self.view addConstraint:_menuViewRightLayoutConstraint];
        _isShownMenuView = YES;
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
        PFFile *imageFile = _currentUser[@"imageFile"];
        [_avatarImageView setImageWithURL:[NSURL URLWithString:imageFile.url]
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
        _userNameLabel.text = _currentUser[@"displayName"];
    else
        _userNameLabel.text = @"User";
}

- (void)initMenuButton {
    NSArray *buttonArray = @[@"Chatroom",@"Sports",@"Academics",@"Games",@"Favorites"];
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
                                                                   multiplier:1.0f constant:kFrameHeight*10/600 + i*kFrameHeight*55/600]];
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

- (void) initUMLogoView {
    if (!_UMLogoView) {
        _UMLogoView                 = [[UILabel alloc] initForAutolayout];
        _UMLogoView.textAlignment = UITextAlignmentCenter;
        _UMLogoView.userInteractionEnabled = YES;
        _UMLogoView.text = @"Information";
        _UMLogoView.textColor = [UIColor whiteColor];
        _UMLogoView.font = [UIFont systemFontOfSize:18];
//        _UMLogoView.backgroundColor = [UIColor colorWithHexString:@"#0c3937"];
        _UMLogoView.backgroundColor = [UIColor clearColor];
        [_menuView addSubview:_UMLogoView];
        
        NSMutableArray *UMLogoConstaint = @[].mutableCopy;
        
        [UMLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_UMLogoView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_menuView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:0.0f]];
        [UMLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_UMLogoView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_menuButton
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:0.0f]];
        [UMLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_UMLogoView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_menuView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:0.0f]];
        [UMLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_UMLogoView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_menuView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:UMLogoConstaint];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToIntro:)];
        tap.numberOfTapsRequired = 1;
        [_UMLogoView addGestureRecognizer:tap];
    }
}

- (void) initUMLogo {
    if (!_UMLogo) {
        _UMLogo                 = [[UIImageView alloc] initForAutolayout];
        [_UMLogo setImage:[UIImage imageNamed:@"info"]];
        _UMLogo.userInteractionEnabled = YES;
        [_menuView addSubview:_UMLogo];
        
        NSMutableArray *UMLogoConstaint = @[].mutableCopy;
        
        [UMLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_UMLogo
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_UMLogoView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:10.0f]];
        [UMLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_UMLogo
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_UMLogoView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0f constant:0.0f]];
        [UMLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_UMLogo
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f constant:30.0f]];
        [UMLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_UMLogo
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:UMLogoConstaint];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToIntro:)];
        tap.numberOfTapsRequired = 1;
        [_UMLogo addGestureRecognizer:tap];
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
            ChatroomViewController *viewController = [ChatroomViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 1: {
            DiscussionListViewController *controller = [DiscussionListViewController new];
            controller.title = @"Sports";
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 2: {
            break;
        }
        case 3: {
            break;
        }
        case 4: {
            break;
        }
        default:
            break;
    }
    
}


- (void)settingButtonClicked:(id)sender {
    PersonalSettingViewController *controller = [[PersonalSettingViewController alloc] init];
    [self dismissMenu];
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

- (void)swipeRight {
    if (!_isShownMenuView) {
        [self.view removeConstraint:_menuViewRightLayoutConstraint];
        [self showMenu];
    }
}

- (void)swipeLeft {
    if (_isShownMenuView) {
        [self.view removeConstraint:_menuViewRightLayoutConstraint];
        [self dismissMenu];
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


- (void) showNoNetworkAlert {
    if (IS_IOS_8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"目前網路不穩定，無法正常執行，請您重新檢查網路後進行重新整理"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 [self.hud hide:YES];
                                                                 if ([self.noNetworkAlertDelegate respondsToSelector:@selector(noNetworkAlertCancelButtonPressed)]) {
                                                                     [self.noNetworkAlertDelegate noNetworkAlertCancelButtonPressed];
                                                                 }
                                                                 
                                                             }];
        UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"重新整理"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self.hud hide:YES];
                                                                  [self.noNetworkAlertDelegate noNetworkAlertRefreshButtonPressed];
                                                              }];
        [alert addAction:cancelAction];
        [alert addAction:refreshAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"目前網路不穩定，無法正常執行，請您重新檢查網路後進行重新整理"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"重新整理", nil];
        [alertView show];
    }
    
}

- (void)goToIntro:(id)sender {
    IntroductionViewController *controller = [IntroductionViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
