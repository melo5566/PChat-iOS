//
//  PersonalSettingViewController.m
//  North7
//
//  Created by Weiyu Chen on 2015/4/23.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "SignUpAndSignInModel.h"
#import "UserModel.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "CustomizedSettingPageButton.h"
#import "FrontpageViewController.h"
#import "SignUpViewController.h"

#import "CustomizedAlertView.h"

#define kPhoneLoginAvailable        NO
#define kFacebookLoginAvailable     YES
#define kGoogleLoginAvailable       NO

@interface PersonalSettingViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UserModelDelegate, CustomizedSettingPageButtonDelegate, SignUpAndSignInModelDelegate>
// Logged in subviews
@property (nonatomic, strong) UIImageView                       *avatarImageView;
@property (nonatomic, strong) UIButton                          *changeAvatarButton;
@property (nonatomic, strong) UIView                            *userNameView;
@property (nonatomic, strong) UIButton                          *changeUserNameButton;
@property (nonatomic, strong) UITextField                       *userNameTextField;
@property (nonatomic, strong) CustomizedSettingPageButton       *logOutButton;
@property (nonatomic, strong) UITextField                       *signInAccountTextField;
@property (nonatomic, strong) UITextField                       *signInPasswordTextField;
@property (nonatomic, strong) NSString                          *account;
@property (nonatomic, strong) NSString                          *password;
@property (nonatomic, strong) NSUserDefaults                    *defaults;
@property (nonatomic, strong) UIButton                          *checkboxButton;
@property (nonatomic) BOOL                                      checkboxSelected;
@property (nonatomic, strong) UITextView                        *rememberMeView;

// Logged out subviews
@property (nonatomic, strong) UIImageView                       *viviImageView;
@property (nonatomic, strong) UIImageView                       *fanzytvLogoImageView;
@property (nonatomic, strong) UILabel                           *textLabel;
@property (nonatomic, strong) CustomizedSettingPageButton       *phoneLoginButton;
@property (nonatomic, strong) CustomizedSettingPageButton       *facebookLoginButton;
@property (nonatomic, strong) CustomizedSettingPageButton       *googleplusLoginButton;
@property (nonatomic, strong) CustomizedSettingPageButton       *signInButton;
@property (nonatomic, strong) CustomizedSettingPageButton       *signUpButton;
@property (nonatomic, strong) CustomizedSettingPageButton       *phoneSignUpButton;

@property (nonatomic, strong) UIButton                          *fanzytvButton;
@property (nonatomic, strong) NSLayoutConstraint                *userNameViewBottomConstraint;

@property (nonatomic, strong) SignUpAndSignInModel              *signUpAndSignInModel;
@property (nonatomic, strong) UserModel                         *userModel;
@property (nonatomic, strong) KiiUser                           *currentLogInUser;

@property (nonatomic) BOOL                                      isFirstLoad;
@property (nonatomic) BOOL                                      isUpdatingAvatar;
@property (nonatomic) BOOL                                      isUpdatingUsername;
@property (nonatomic, strong) NSString                          *originUserName;
@property (nonatomic, strong) NSString                          *originAvatarUrl;
@property (nonatomic, strong) UIImage                           *tempImageForReupload;

@property (nonatomic, strong) CustomizedAlertView               *changeAvatarAlertView;
@end

@implementation PersonalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"設定";
    [self initPermanentNotificationObservers];
    [self initNavigationBarBackButtonAtLeft];
    _isFirstLoad = YES;
    _currentLogInUser = [KiiUser currentUser];
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNavigationBarBackButtonAtLeft];
    [self initNotificationObservers];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    _signUpAndSignInModel.delegate = self;
    
    if (_isFirstLoad) {
        _isFirstLoad = NO;
        if (_currentLogInUser) {
            [self initUserLoggedInLayout];
        } else {
            [self initUserLoggedOutLayout];
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _account  = [defaults stringForKey:@"account"];
    _password = [defaults stringForKey:@"password"];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotificationObservers];
}

- (void) dealloc {
    [self removePermanentNotificationObservers];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layout init
- (void) initUserLoggedInLayout {
    [self initFanzytvLogoButton];
    [self initAvatarImageView];
    [self initChangeAvatarButton];
    [self initUserNameView];
    [self initLogoutButton];
    [self initFanzytvLogoImageView];
    
    [UIView animateWithDuration:0.8 animations:^(){
        for (UIView *subView in self.view.subviews) {
            subView.alpha = 1;
        }
    }];
    
}

- (void) initUserLoggedOutLayout {
    [self initFanzytvLogoButton];
//    [self initViviImageView];
    [self initTextLabel];
    [self initLoginButton];
    [UIView animateWithDuration:0.8 animations:^(){
        for (UIView *subView in self.view.subviews) {
            subView.alpha = 1;
        }
    }];
}

- (void) initFanzytvLogoButton {
    if (!_fanzytvButton) {
        _fanzytvButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fanzytvButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _fanzytvButton.alpha = 0;
        _fanzytvButton.backgroundColor = [UIColor clearColor];
        [_fanzytvButton setImage:[UIImage imageNamed:@"FanzyTv Logo"] forState:UIControlStateNormal];
        [_fanzytvButton addTarget:self action:@selector(fanzytvButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_fanzytvButton];
        NSMutableArray *fanzytvButtonConstraint = @[].mutableCopy;
        [fanzytvButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:IS_IPHONE_4 ? -10.0f : -22.7f]];
        [fanzytvButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_fanzytvButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:15.0/48.0 constant:0.0f]];
        [fanzytvButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvButton
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:82.0f]];
        [fanzytvButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-82.0f]];
        [self.view addConstraints:fanzytvButtonConstraint];
    }
}

- (void) initRememberMeView {
    if (!_rememberMeView) {
        _rememberMeView                     = [[UITextView alloc] initForAutolayout];
        _rememberMeView.text                = @"Remember me";
        _rememberMeView.backgroundColor     = [UIColor clearColor];
        _rememberMeView.textColor           = [UIColor blackColor];
        _rememberMeView.font                = [UIFont fontWithName:nil size:12];
        [self.view addSubview:_rememberMeView];
        
        NSMutableArray *rememberMeViewConstraint = @[].mutableCopy;
        
        [rememberMeViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_rememberMeView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                            toItem:_checkboxButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:10.0f]];
        [rememberMeViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_rememberMeView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_checkboxButton
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:-2.0f]];
        [rememberMeViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_rememberMeView
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:100.0f]];
        [rememberMeViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_rememberMeView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_checkboxButton
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:rememberMeViewConstraint];
    }
}

- (void) initCheckboxButton {
    if (!_checkboxButton) {
        _checkboxButton = [[UIButton alloc] initForAutolayout];
        [_checkboxButton addTarget:self action:@selector(checkboxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_checkboxButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [_checkboxButton setImage:[UIImage imageNamed:@"selected_checkbox"] forState:UIControlStateHighlighted];
        [_checkboxButton setImage:[UIImage imageNamed:@"selected_checkbox"] forState:UIControlStateSelected];
        _checkboxButton.adjustsImageWhenHighlighted = YES;
        
        [self.view addSubview:_checkboxButton];
        
        NSMutableArray *checkboxButtonConstraint = @[].mutableCopy;
        
        [checkboxButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_checkboxButton
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_signInPasswordTextField
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:0.0f]];
        [checkboxButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_checkboxButton
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_signInPasswordTextField
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:15.0f]];
        [checkboxButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_checkboxButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:25.0f]];
        [checkboxButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_checkboxButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:25.0f]];
        [self.view addConstraints:checkboxButtonConstraint];

    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:@"rememberMe"]) {
        _checkboxSelected = YES;
        [_checkboxButton setSelected:YES];
    }
}

- (void) initAvatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initForAutolayout];
        _avatarImageView.alpha = 0;
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.layer.cornerRadius = (kScreenWidth - 225) / 2;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.clipsToBounds = YES;
        [self.view addSubview:_avatarImageView];
        NSMutableArray *avatarConstraint = @[].mutableCopy;
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:112.5f]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f constant:-112.5f]];
        NSLayoutConstraint *avatarTopDefaultConstraint = [NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                                      attribute:NSLayoutAttributeTop
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.view
                                                                                      attribute:NSLayoutAttributeTop
                                                                                     multiplier:1.0f constant:15.0f];
        avatarTopDefaultConstraint.priority = 750;
        [avatarConstraint addObject:avatarTopDefaultConstraint];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:-20.0f]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_avatarImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0f constant:0.0f]];
        [self.view addConstraints:avatarConstraint];
        
        
        _originAvatarUrl = [_currentLogInUser getObjectForKey:@"avatar"];
        __block __typeof (UIImageView *) avatarImageView = _avatarImageView;
        [_avatarImageView setImageWithURL:[NSURL URLWithString:[_currentLogInUser getObjectForKey:@"avatar"]]
                     withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    if (image) {
                                        avatarImageView.alpha = 0;
                                        [UIView animateWithDuration:0.3 animations:^(){
                                            [avatarImageView setImage:image];
                                            avatarImageView.alpha = 1;
                                        }];
                                    }
                                    else {
                                        [avatarImageView setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                                    }
                                }
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
    }
}

- (void) initChangeAvatarButton {
    if (!_changeAvatarButton) {
        _changeAvatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeAvatarButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _changeAvatarButton.alpha = 0;
        _changeAvatarButton.backgroundColor = [UIColor clearColor];
        [_changeAvatarButton setTitle:@"變更頭像" forState:UIControlStateNormal];
        [_changeAvatarButton setTitleColor:[UIColor colorWithHexString:kPersonalSettingChangeAvatarButtonTextColorHexString] forState:UIControlStateNormal];
        _changeAvatarButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_changeAvatarButton addTarget:self action:@selector(changeAvatarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_changeAvatarButton];
        NSMutableArray *changeAvatarButtonConstraint = @[].mutableCopy;
        [changeAvatarButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_changeAvatarButton
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_avatarImageView
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f constant:7.8f]];
        [changeAvatarButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_changeAvatarButton
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:68.0f]];
        [changeAvatarButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_changeAvatarButton
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:17.5f]];
        [changeAvatarButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_changeAvatarButton
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0f constant:0.0f]];
        [self.view addConstraints:changeAvatarButtonConstraint];
    }
}

- (void) initUserNameView {
    if (!_userNameView) {
        _userNameView                   = [[UIView alloc] initForAutolayout];
        _userNameView.alpha             = 0;
        _userNameView.backgroundColor   = [UIColor clearColor];
        [self.view addSubview:_userNameView];
        NSMutableArray *userNameViewConstraint = @[].mutableCopy;
        [userNameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_changeAvatarButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f constant:47.2f]];
        [userNameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0f constant:15.0f]];
        [userNameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f constant:-15.0f]];
        [userNameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0f constant:33.0f]];
        [userNameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1.0f constant:0.0f]];
        [self.view addConstraints:userNameViewConstraint];
        
        // Bottom Line
        UIView *bottomLine          = [[UIView alloc] initForAutolayout];
        bottomLine.backgroundColor  = [UIColor colorWithHexString:@"0f9bab"];
        [_userNameView addSubview:bottomLine];
        NSMutableArray *bottomLineConstraint = @[].mutableCopy;
        [bottomLineConstraint addObject:[NSLayoutConstraint constraintWithItem:bottomLine
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_userNameView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [bottomLineConstraint addObject:[NSLayoutConstraint constraintWithItem:bottomLine
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_userNameView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [bottomLineConstraint addObject:[NSLayoutConstraint constraintWithItem:bottomLine
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_userNameView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        [bottomLineConstraint addObject:[NSLayoutConstraint constraintWithItem:bottomLine
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:1.0f]];
        
        [self.view addConstraints:bottomLineConstraint];
        
        // Label (顯示暱稱)
        UILabel *displaynameLabel           = [[UILabel alloc] initForAutolayout];
        displaynameLabel.backgroundColor    = [UIColor clearColor];
        displaynameLabel.textColor          = [UIColor colorWithHexString:@"109bac"];
        displaynameLabel.font               = [UIFont boldSystemFontOfSize:17.0f];
        displaynameLabel.text               = @"顯示暱稱";
        [_userNameView addSubview:displaynameLabel];
        NSMutableArray *displaynameLabelConstraint = @[].mutableCopy;
        [displaynameLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:displaynameLabel
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_userNameView
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1.0f constant:0.0f]];
        [displaynameLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:displaynameLabel
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_userNameView
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0f constant:0.0f]];
        [displaynameLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:displaynameLabel
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0f constant:68.0f]];
        [displaynameLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:displaynameLabel
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0f constant:17.5f]];
        
        [self.view addConstraints:displaynameLabelConstraint];
        
        // changeUserNameButton
        _changeUserNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeUserNameButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _changeUserNameButton.backgroundColor = [UIColor clearColor];
        [_changeUserNameButton setTitle:@"變更" forState:UIControlStateNormal];
        [_changeUserNameButton setTitleColor:[UIColor colorWithHexString:kPersonalSettingChangeAvatarButtonTextColorHexString] forState:UIControlStateNormal];
        _changeUserNameButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_changeUserNameButton addTarget:self action:@selector(changeUserNameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_userNameView addSubview:_changeUserNameButton];
        NSMutableArray *changeUserNameButtonConstraint = @[].mutableCopy;
        [changeUserNameButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_changeUserNameButton
                                                                               attribute:NSLayoutAttributeCenterY
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_userNameView
                                                                               attribute:NSLayoutAttributeCenterY
                                                                              multiplier:1.0f constant:0.0f]];
        [changeUserNameButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_changeUserNameButton
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_userNameView
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.0f constant:0.0f]];
        [changeUserNameButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_changeUserNameButton
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1.0f constant:34.0f]];
        [changeUserNameButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_changeUserNameButton
                                                                               attribute:NSLayoutAttributeHeight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1.0f constant:17.5f]];
        
        [self.view addConstraints:changeUserNameButtonConstraint];
        
        // UserNameTextField
        _userNameTextField = [[UITextField alloc] initForAutolayout];
        _userNameTextField.delegate = self;
        [_userNameTextField addTarget:self
                               action:@selector(userNameTextFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
        _userNameTextField.backgroundColor  = [UIColor clearColor];
        _userNameTextField.textColor        = [UIColor colorWithHexString:@"1d1d1d"];
        _userNameTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
        _userNameTextField.returnKeyType    = UIReturnKeyDone;
        _userNameTextField.font             = [UIFont systemFontOfSize:24.0f];
        _userNameTextField.textAlignment    = NSTextAlignmentCenter;
        _userNameTextField.borderStyle      = UITextBorderStyleNone;
        _userNameTextField.adjustsFontSizeToFitWidth = YES;
        _userNameTextField.minimumFontSize  = 14.0f;
        _userNameTextField.text             = _currentLogInUser.displayName;
        _originUserName                     = _currentLogInUser.displayName;
        [_userNameView addSubview:_userNameTextField];
        NSMutableArray *userNameTextFieldConstraint = @[].mutableCopy;
        [userNameTextFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameTextField
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_userNameView
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1.0f constant:0.0f]];
        [userNameTextFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameTextField
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:displaynameLabel
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:8.0f]];
        [userNameTextFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameTextField
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_changeUserNameButton
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0f constant:-8.0f]];
        [userNameTextFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameTextField
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:24.5f]];
        
        [self.view addConstraints:userNameTextFieldConstraint];
        
    }
}

- (void) initLogoutButton {
    if (!_logOutButton) {
        _logOutButton                       = [[CustomizedSettingPageButton alloc] init];
        _logOutButton.alpha                 = 0;
        _logOutButton.delegate              = self;
        _logOutButton.settingPageButtonType = SettingPageButtonTypeLogout;
        [self.view addSubview:_logOutButton];
        NSMutableArray *logOutButtonConstraint = @[].mutableCopy;
        [logOutButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_logOutButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_fanzytvButton
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0f constant:-45.0f]];
        [logOutButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_logOutButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f constant:-15.0f]];
        [logOutButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_logOutButton
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0f constant:15.0f]];
        [logOutButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_logOutButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_logOutButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:58.5/345 constant:0.0f]];
        
        [self.view addConstraints:logOutButtonConstraint];
    }
}

- (void) initFanzytvLogoImageView {
    if (!_fanzytvLogoImageView) {
        _fanzytvLogoImageView                   = [[UIImageView alloc] initForAutolayout];
        _fanzytvLogoImageView.backgroundColor   = [UIColor clearColor];
        _fanzytvLogoImageView.image             = [UIImage imageNamed:@"btn_fanzytv"];
        
        [self.view addSubview:_fanzytvLogoImageView];
        
        NSMutableArray *fanzytvLogoConstaint = @[].mutableCopy;
        
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoImageView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:100.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoImageView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:-30.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoImageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:60.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoImageView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:-100.0f]];
        
        [self.view addConstraints:fanzytvLogoConstaint];
        
    }
}



- (void) initViviImageView {
    if (!_viviImageView) {
        _viviImageView                  = [[UIImageView alloc] initForAutolayout];
        _viviImageView.alpha            = 0;
        _viviImageView.backgroundColor  = [UIColor clearColor];
        _viviImageView.contentMode      = UIViewContentModeScaleAspectFill;
        _viviImageView.clipsToBounds    = YES;
        [self.view addSubview:_viviImageView];
        NSMutableArray *viviImageViewConstraint = @[].mutableCopy;
        [viviImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_viviImageView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:109.0f]];
        [viviImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_viviImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-109.0f]];
        [viviImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_viviImageView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:22.5f]];
        [viviImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_viviImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_viviImageView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0f constant:0.0f]];
        [self.view addConstraints:viviImageViewConstraint];
        [_viviImageView setImage:[UIImage imageNamed:@"Logged out image"]];
    }
}

- (void) initTextLabel {
    _textLabel                           = [[UILabel alloc] initForAutolayout];
    _textLabel.backgroundColor           = [UIColor clearColor];
    _textLabel.alpha                     = 0;
    _textLabel.textColor                 = [UIColor colorWithHexString:kListTableViewTimeColorHexString];
    _textLabel.font                      = [UIFont boldSystemFontOfSize:IS_IPHONE_4 ? 20.0f : 24.0f];
    _textLabel.text                      = @"登入可以改變您的資料，與名人們做更進一步的互動喔！";
    _textLabel.adjustsFontSizeToFitWidth = YES;
    _textLabel.numberOfLines             = 2;
    
    [self.view addSubview:_textLabel];
    NSMutableArray *textLabelConstraint = @[].mutableCopy;
    [textLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_textLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:IS_IPHONE_4 ? 20.0f : 15.0f]];
    [textLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_textLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:IS_IPHONE_4 ? -20.0f : -15.0f]];
    [textLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_textLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f constant:15.0f]];
    NSLayoutConstraint *textLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_textLabel
                                                                                 attribute:NSLayoutAttributeHeight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:nil
                                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                                multiplier:1.0f constant:61.0f];
    textLabelHeightConstraint.priority = 750;
    [textLabelConstraint addObject:textLabelHeightConstraint];
    
    [self.view addConstraints:textLabelConstraint];
    [_textLabel sizeToFit];
}

- (void) initLoginButton {
    [self initSignInAccountTextField];
    [self initSignInPasswordTextField];
    [self initCheckboxButton];
    [self initRememberMeView];
    [self initSignInButton];
    [self initSignUpButton];
    [self initPhoneSignUpButton];
//    if (kGoogleLoginAvailable) {
//        [self initGooglePlusLoginButton];
//    }
//
//    if (kFacebookLoginAvailable) {
//        [self initFacebookLoginButton];
//    }
//    
//    if (kPhoneLoginAvailable) {
//        [self initPhoneLoginButton];
//    }
}

- (void) initFacebookLoginButton {
    if (!_facebookLoginButton) {
        _facebookLoginButton                        = [[CustomizedSettingPageButton alloc] init];
        _facebookLoginButton.alpha                  = 0;
        _facebookLoginButton.delegate               = self;
        _facebookLoginButton.settingPageButtonType  = SettingPageButtonTypeFacebookLogin;
        [self.view addSubview:_facebookLoginButton];
        
        NSMutableArray *facebookLoginButtonConstraint = @[].mutableCopy;
        
        if (kGoogleLoginAvailable) {
            [facebookLoginButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookLoginButton
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:_googleplusLoginButton
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1.0f constant:IS_IPHONE_4 ? -10.0f : -15.0f]];
        }
        else {
            NSLayoutConstraint *facebookLoginButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:_facebookLoginButton
                                                                                                   attribute:NSLayoutAttributeBottom
                                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                                      toItem:_fanzytvButton
                                                                                                   attribute:NSLayoutAttributeTop
                                                                                                  multiplier:1.0f constant:-117.0f];
            facebookLoginButtonBottomConstraint.priority = 750;
            [facebookLoginButtonConstraint addObject:facebookLoginButtonBottomConstraint];
            
        }
        
        
        
        [facebookLoginButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookLoginButton
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                 toItem:_textLabel
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0f constant:10.0f]];
        
        [facebookLoginButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookLoginButton
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:IS_IPHONE_4 ? -20.0f : -15.0f]];
        [facebookLoginButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookLoginButton
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0f constant:IS_IPHONE_4 ? 20.0f : 15.0f]];
        [facebookLoginButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookLoginButton
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_facebookLoginButton
                                                                              attribute:NSLayoutAttributeWidth
                                                                             multiplier:58.5/345 constant:0.0f]];
        
        [self.view addConstraints:facebookLoginButtonConstraint];
    }
}


- (void) initSignInAccountTextField {
    if (!_signInAccountTextField) {
        _signInAccountTextField                          = [[UITextField alloc] initForAutolayout];
        _signInAccountTextField.backgroundColor          = [UIColor whiteColor];
        _signInAccountTextField.borderStyle              = UITextBorderStyleRoundedRect;
        _signInAccountTextField.font                     = [UIFont systemFontOfSize:15];
        _signInAccountTextField.placeholder              = @"enter user account";
        _signInAccountTextField.autocorrectionType       = UITextAutocorrectionTypeNo;
        _signInAccountTextField.keyboardType             = UIKeyboardTypeDefault;
        _signInAccountTextField.returnKeyType            = UIReturnKeyDone;
        _signInAccountTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
        _signInAccountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _signInAccountTextField.leftViewMode             = UITextFieldViewModeAlways;
        _signInAccountTextField.delegate                 = self;
        [self.view addSubview:_signInAccountTextField];
        
        NSMutableArray *signInAccountConstraint = @[].mutableCopy;
        
        [signInAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInAccountTextField
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_textLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:15.0f]];
        [signInAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInAccountTextField
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-20.0f]];
        [signInAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInAccountTextField
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:20.0f]];
        [signInAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInAccountTextField
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:35.0f]];
        
        [self.view addConstraints:signInAccountConstraint];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:@"account"]) {
        _signInAccountTextField.text = [defaults stringForKey:@"account"];
    }
    
}


- (void) initSignInPasswordTextField {
    if (!_signInPasswordTextField) {
        _signInPasswordTextField                            = [[UITextField alloc] initForAutolayout];
        _signInPasswordTextField.backgroundColor            = [UIColor whiteColor];
        _signInPasswordTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _signInPasswordTextField.font                       = [UIFont systemFontOfSize:15];
        _signInPasswordTextField.placeholder                = @"Please enter password";
        _signInPasswordTextField.secureTextEntry            = YES;
        _signInPasswordTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _signInPasswordTextField.keyboardType               = UIKeyboardTypeDefault;
        _signInPasswordTextField.returnKeyType              = UIReturnKeyDone;
        _signInPasswordTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _signInPasswordTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _signInPasswordTextField.leftViewMode               = UITextFieldViewModeAlways;
        _signInPasswordTextField.delegate                   = self;
        [self.view addSubview:_signInPasswordTextField];
        
        NSMutableArray *signInPasswordConstraint = @[].mutableCopy;
        
        [signInPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInPasswordTextField
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_signInAccountTextField
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:10.0f]];
        [signInPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInPasswordTextField
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-20.0f]];
        [signInPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInPasswordTextField
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:20.0f]];
        [signInPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInPasswordTextField
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:35.0f]];
        
        [self.view addConstraints:signInPasswordConstraint];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:@"password"]) {
        _signInPasswordTextField.text = [defaults stringForKey:@"password"];
    }
}



- (void) initSignInButton {
    if (!_signInButton) {
        _signInButton                       = [[CustomizedSettingPageButton alloc] init];
        _signInButton.alpha                 = 0;
        _signInButton.delegate              = self;
        _signInButton.settingPageButtonType = SettingPageButtonTypeSignIn;
        [_signInButton addTarget:self action:@selector(signInButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_signInButton];
        
        NSMutableArray *signInButtonConstraint = @[].mutableCopy;
        
        [signInButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:_checkboxButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f constant:15.0f]];
        [signInButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f constant:-20.0f]];
        [signInButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInButton
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0f constant:20.0f]];
        [signInButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_signInButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:58.5/345 constant:0.0f]];
        
        [self.view addConstraints:signInButtonConstraint];
    }
}



- (void) initSignUpButton {
    if (!_signUpButton) {
        _signUpButton                       = [[CustomizedSettingPageButton alloc] init];
        _signUpButton.alpha                 = 0;
        _signUpButton.delegate              = self;
        _signUpButton.settingPageButtonType = SettingPageButtonTypeSignUp;
        [_signUpButton addTarget:self action:@selector(signUpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_signUpButton];
        
        NSMutableArray *signUpButtonConstraint = @[].mutableCopy;
        
        [signUpButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:_signInButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f constant:30.0f]];
        [signUpButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f constant:-20.0f]];
        [signUpButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpButton
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0f constant:20.0f]];
        [signUpButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_signUpButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:58.5/345 constant:0.0f]];
        
        [self.view addConstraints:signUpButtonConstraint];
    }
}

- (void) initPhoneSignUpButton {
    if (!_phoneSignUpButton) {
        _phoneSignUpButton                       = [[CustomizedSettingPageButton alloc] init];
        _phoneSignUpButton.alpha                 = 0;
        _phoneSignUpButton.delegate              = self;
        _phoneSignUpButton.settingPageButtonType = SettingPageButtonTypePhoneSignUp;
        [_phoneSignUpButton addTarget:self action:@selector(phoneSignUpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_phoneSignUpButton];
        
        NSMutableArray *signUpButtonConstraint = @[].mutableCopy;
        
        [signUpButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_phoneSignUpButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:_signUpButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f constant:30.0f]];
        [signUpButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_phoneSignUpButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f constant:-20.0f]];
        [signUpButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_phoneSignUpButton
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0f constant:20.0f]];
        [signUpButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_phoneSignUpButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_signUpButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:58.5/345 constant:0.0f]];
        
        [self.view addConstraints:signUpButtonConstraint];
    }
}


#pragma mark - notifications
- (void) initPermanentNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userStatusChanged:)
                                                 name:kEventUserStatusChanged
                                               object:nil];
}

- (void) removePermanentNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kEventUserStatusChanged
                                                  object:nil];
}

- (void) initNotificationObservers {
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
//
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - notification handlers
- (void) keyboardWillShow:(NSNotification *) notification
{
    if (kScreenWidth <= 320) {
        NSDictionary* keyboardInfo               = [notification userInfo];
        NSValue* keyboardEndFrameValue           = keyboardInfo[@"UIKeyboardFrameEndUserInfoKey"];
        CGRect keyboardEndFrame                  = [keyboardEndFrameValue CGRectValue];
        NSNumber* animationDurationNumber        = keyboardInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
        NSTimeInterval animationDuration         = [animationDurationNumber doubleValue];
        NSNumber* animationCurveNumber           = keyboardInfo[@"UIKeyboardAnimationCurveUserInfoKey"];
        UIViewAnimationCurve animationCurve      = [animationCurveNumber intValue];
        UIViewAnimationOptions animationOptions  = animationCurve << 16;
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:animationOptions
                         animations:^{
                             if ([self.view.constraints containsObject:_userNameViewBottomConstraint]) {
                                 [self.view removeConstraint:_userNameViewBottomConstraint];
                             }
                             if (_userNameView) {
                                 _userNameViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_userNameView
                                                                                              attribute:NSLayoutAttributeBottom
                                                                                              relatedBy:NSLayoutRelationEqual
                                                                                                 toItem:self.view
                                                                                              attribute:NSLayoutAttributeBottom
                                                                                             multiplier:1.0f constant:-keyboardEndFrame.size.height- 5];
                                 [self.view addConstraint:_userNameViewBottomConstraint];
                             }
                             
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    NSDictionary* keyboardInfo              = [notification userInfo];
    NSNumber* animationDurationNumber       = keyboardInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    NSTimeInterval animationDuration        = [animationDurationNumber doubleValue];
    NSNumber* animationCurveNumber          = keyboardInfo[@"UIKeyboardAnimationCurveUserInfoKey"];
    UIViewAnimationCurve animationCurve     = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         if ([self.view.constraints containsObject:_userNameViewBottomConstraint]) {
                             [self.view removeConstraint:_userNameViewBottomConstraint];
                         }
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {}];
}

- (void) userStatusChanged:(NSNotification *) notification {
    if ([notification.object isEqualToString:@"LOGGED_IN"]) {
        _currentLogInUser = [KiiUser currentUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self userLoggedIn];
        });
        
    }
}


#pragma mark - button actions
- (void) checkboxButtonClicked:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (_checkboxSelected) {
        [_checkboxButton setSelected:NO];
        _checkboxSelected = NO;
        [defaults setObject:nil forKey:@"rememberMe"];
    } else {
        [_checkboxButton setSelected:YES];
        _checkboxSelected = YES;
        [defaults setObject:@"YES" forKey:@"rememberMe"];
    }
}


- (void)signUpButtonClicked:(id)sender {
    SignUpViewController *signUpView = [SignUpViewController new];
    signUpView.signUpType = @"normal";
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:signUpView];
    naviController.navigationBar.translucent = NO;
    [self presentViewController:naviController animated:YES completion:nil];
}

- (void)phoneSignUpButtonClicked:(id)sender {
    SignUpViewController *signUpView = [SignUpViewController new];
    signUpView.signUpType = @"phone";
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:signUpView];
    naviController.navigationBar.translucent = NO;
    [self presentViewController:naviController animated:YES completion:nil];
}

- (void)signInButtonClicked:(id)sender {
    if (_signInAccountTextField.text.length > 0 && _signInPasswordTextField.text.length > 0) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"登入中" delayToHide:-1];
        if (!_signUpAndSignInModel) {
            _signUpAndSignInModel = [SignUpAndSignInModel new];
            _signUpAndSignInModel.delegate = self;
        }
        [_signUpAndSignInModel kiiUserLogIn:[[NSString alloc] initWithString:_signInAccountTextField.text]
                                   password:[[NSString alloc] initWithString:_signInPasswordTextField.text]
                              CompleteBlock:^(KiiUser *user, NSError *error) {
                                  [self.hud hide:YES];
                                  if (error != nil) {
                                      NSLog(@"# ERROR : %@",error.userInfo[@"server_message"]);
                                      NSLog(@"# ERROR CODE : %ld",(long)error.code);
                                      return;
                                  }
                                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                  if (_checkboxSelected) {
                                      [defaults setObject:[[NSString alloc] initWithString:_signInAccountTextField.text] forKey:@"account"];
                                      [defaults setObject:[[NSString alloc] initWithString:_signInPasswordTextField.text] forKey:@"password"];
                                      [defaults setObject:@"YES" forKey:@"rememberMe"];
                                  } else {
                                      [defaults setObject:nil forKey:@"account"];
                                      [defaults setObject:nil forKey:@"password"];
                                      [defaults setObject:nil forKey:@"rememberMe"];
                                  }
                                  [defaults synchronize];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:kEventUserStatusChanged object:@"LOGGED_IN"];
                                  
    }];
        
        
    } else if(_signInAccountTextField.text.length > 0 && _signInPasswordTextField.text.length == 0) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"請輸入密碼" delayToHide:1];
    } else if (_signInPasswordTextField.text.length > 0 && _signInAccountTextField.text.length == 0) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"請輸入帳號" delayToHide:1];
    } else {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"請輸入帳號和密碼" delayToHide:1];
    }
    
}

- (void) changeUserNameButtonPressed:(id)sender {
    [_userNameTextField becomeFirstResponder];
}

- (void) changeAvatarButtonPressed:(id)sender {
    _changeAvatarAlertView = [[CustomizedAlertView alloc] initWithTitle:@"變更頭像" andMessage:@"選擇輸入方式"];
    [_changeAvatarAlertView addButtonWithTitle:@"相機" type:CustomizedAlertViewButtonTypeDefaultLightGreen handler:^(CustomizedAlertView *alertView) {
        [self useCamera];
    }];
    [_changeAvatarAlertView addButtonWithTitle:@"相簿" type:CustomizedAlertViewButtonTypeDefaultGreen handler:^(CustomizedAlertView *alertView) {
        [self usePhotoLibrary];
    }];
    [_changeAvatarAlertView show];
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"變更頭像"
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"使用照相機",@"使用圖片庫", nil];
//    [sheet showInView:[UIApplication sharedApplication].delegate.window];
}

- (void) settingPageButtonPressed:(id)sender {
    if (sender == _logOutButton) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"登出中..." delayToHide:-1];
        [self performSelector:@selector(logout:) withObject:sender afterDelay:1];
    }
    else if (sender == _facebookLoginButton) {
        [self facebookLogin];
    }
}

- (void) fanzytvButtonPressed:(id)sender {
//    [self.appdelegate openURL:[NSURL URLWithString:kFanzytvWebPageURL]];
}

- (void) backButtonPressed:(id) sender {
    if (_currentLogInUser) {
        if (![_originUserName isEqualToString:_userNameTextField.text]) {
            [self updateUsername];
        }
        else {
            [super backButtonPressed:sender];
        }
    }
    else {
        [super backButtonPressed:sender];
    }
}

#pragma mark - methods
- (void)dismissKeyboard {
    [_signInAccountTextField resignFirstResponder];
    [_signInPasswordTextField resignFirstResponder];
    [_userNameTextField resignFirstResponder];
}

- (void) facebookLogin {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"登入中..." delayToHide:-1];
    
    if (!_signUpAndSignInModel) {
        _signUpAndSignInModel = [[SignUpAndSignInModel alloc] init];
    }
    
    [_signUpAndSignInModel facebookLogInInWithReadPermissions:nil completeBlock:^(facebookLogInStatus logInStatus, KiiUser *user) {
        switch (logInStatus) {
            case facebookLogInStatusUserCanceled:{
                [self.hud hide:YES];
                [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"登入已被取消..." delayToHide:1];
                break;
            }
            case facebookLogInStatusNewUser:
            case facebookLogInStatusLoggedIn: {
                [self.hud hide:YES];
                [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"登入成功" delayToHide:1];
                _currentLogInUser = user;
                [self userLoggedIn];
                break;
            }
            case facebookLogInStatusFailedToLoggIn:
            case facebookLogInStatusFailedToGetUserFacebookData: {
                [self.hud hide:YES];
                [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"登入發生錯誤..." delayToHide:1];
                break;
            }
            default:
                break;
        }
        
    }];
}

- (void) userLoggedIn {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.8 animations:^(){
            for (UIView *subView in self.view.subviews) {
                subView.alpha = 0;
            }
            if (_viviImageView) {
                [_viviImageView removeFromSuperview];
                _viviImageView = nil;
            }
            if (_textLabel) {
                [_textLabel removeFromSuperview];
                _textLabel = nil;
            }
            if (_facebookLoginButton) {
                [_facebookLoginButton removeFromSuperview];
                _facebookLoginButton = nil;
            }
            if (_fanzytvButton) {
                [_fanzytvButton removeFromSuperview];
                _fanzytvButton = nil;
            }
            if (_signInButton) {
                [_signInButton removeFromSuperview];
                _signInButton = nil;
            }
            if (_signUpButton) {
                [_signUpButton removeFromSuperview];
                _signUpButton = nil;
            }
            if (_phoneSignUpButton) {
                [_phoneSignUpButton removeFromSuperview];
                _phoneSignUpButton = nil;
            }
            if (_signInAccountTextField) {
                [_signInAccountTextField removeFromSuperview];
                _signInAccountTextField = nil;
            }
            if (_signInPasswordTextField) {
                [_signInPasswordTextField removeFromSuperview];
                _signInPasswordTextField = nil;
            }
            if (_checkboxButton) {
                [_checkboxButton removeFromSuperview];
                _checkboxButton = nil;
            }
            if (_rememberMeView) {
                [_rememberMeView removeFromSuperview];
                _rememberMeView = nil;
            }
            
            [self initUserLoggedInLayout];
        }];
        
    });
}

- (void) logout:(id)sender {
    [KiiUser logOut];
    _currentLogInUser = nil;
   
    // clear token
//    [kUserDefault removeObjectForKey:kKiiUserAccessTokenUserdefaultKey];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
        
        [UIView animateWithDuration:0.8 animations:^(){
            for (UIView *subView in self.view.subviews) {
                subView.alpha = 0;
            }
            if (_avatarImageView) {
                [_avatarImageView removeFromSuperview];
                _avatarImageView = nil;
            }
            if (_changeAvatarButton) {
                [_changeAvatarButton removeFromSuperview];
                _changeAvatarButton = nil;
            }
            if (_userNameView) {
                [_userNameTextField removeFromSuperview];
                _userNameTextField = nil;
                [_changeUserNameButton removeFromSuperview];
                _changeUserNameButton = nil;
                [_userNameView removeFromSuperview];
                _userNameView = nil;
            }
            if (_logOutButton) {
                [_logOutButton removeFromSuperview];
                _logOutButton = nil;
            }
            if (_fanzytvButton) {
                [_fanzytvButton removeFromSuperview];
                _fanzytvButton = nil;
            }
        } completion:^(BOOL finished){
            [self initUserLoggedOutLayout];
        }];
        
    });
}

/**
 * 使用照相機
 */
- (void) useCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSLog(@"=====>> AVAuthorizationStatus : %ld",(long)status);
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     if (granted) {
                                         [self openCamera];
                                     }
                                 }];
    }
    else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"尚未授權相機功能"
                                                            message:@"尚未授權相機功能，您可以到手機設定中的隱私權更改設定"
                                                           delegate:nil
                                                  cancelButtonTitle:@"確定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [self openCamera];
    }
}

- (void) openCamera {
    // check if camera is available
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"無法使用照相機"
                                                            message:@"抱歉，您的設備無照相功能!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"確定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/**
 * 使用圖片庫
 */
- (void) usePhotoLibrary {
    UIImagePickerController* imagePicker    = [[UIImagePickerController alloc] init];
    imagePicker.sourceType                  = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate                    = self;
    imagePicker.allowsEditing               = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self useCamera];
    } else if (buttonIndex==1) {
        [self usePhotoLibrary];
    }
}

- (void) startToUploadAvatar:(UIImage *) image
{
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"大頭貼上傳中..." delayToHide:-1];
    _isUpdatingAvatar = YES;
    _tempImageForReupload = image;
    NSData *imageData = UIImageJPEGRepresentation([image scaledWithMaxLength:1000], 0.6);
    
    if (!_userModel) {
        _userModel = [[UserModel alloc] init];
        _userModel.delegate = self;
    }
    
    [_userModel uploadAvatar:imageData ForUser:_currentLogInUser];
}

- (void) updateUsername {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"儲存個人設定..." delayToHide:-1];
    _isUpdatingUsername = YES;
    if (!_userModel) {
        _userModel = [[UserModel alloc] init];
        _userModel.delegate = self;
    }
    if (_userNameTextField.text.length > 0)
        [_userModel updateUsername:_userNameTextField.text ForUser:_currentLogInUser];
    else
        [_userModel updateUsername:@" " ForUser:_currentLogInUser];
}

#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _userNameTextField && isNullValue([textField markedTextRange])) {
        
        if (textField.text.length - range.length + string.length  > 15) {
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

- (void) userNameTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 15) {
            NSRange oversteppedRange = NSMakeRange(15, textField.text.length - 15);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

#pragma mark - image picker delegate
- (void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    UIImage *croppedImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (croppedImage)
    {
        // 開始上傳
        [self startToUploadAvatar:croppedImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UserModel delegate
- (void) didUpdateUserAvatarWithImageData:(NSData *)imageData {
    [self.hud hide:YES];
    [_avatarImageView setImage:[UIImage imageWithData:imageData]];
    if (_isUpdatingAvatar) {
        _isUpdatingAvatar = NO;
    }
}

- (void) didUpdateUserName {
    [self.hud hide:YES];
    [super backButtonPressed:self.navigationItem.leftBarButtonItem];
}

- (void) noNetworkAlertRefreshButtonPressed {
    if (_isUpdatingAvatar) {
        [self startToUploadAvatar:_tempImageForReupload];
    }
    
    if (_isUpdatingUsername) {
        [self updateUsername];
    }
}

- (void) noNetworkAlertCancelButtonPressed {
    if (_isUpdatingAvatar) {
        _isUpdatingAvatar = NO;
    }
    
    if (_isUpdatingUsername) {
        _isUpdatingUsername = NO;
        _userNameTextField.text = _originUserName;
    }
}

@end
