//
//  BaseViewController.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIAlertView               *loginAlertView;
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

- (void) viewWillDisappear:(BOOL) animated
{
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

@end
