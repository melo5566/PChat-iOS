//
//  PersonalSettingViewController.m
//  493_Project
//
//  Created by Peter on 2015/10/23.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "SignUpAndSignInModel.h"
#import "UserModel.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "CustomizedSettingPageButton.h"
#import "SignUpViewController.h"

#import "CustomizedAlertView.h"
#import <Parse/Parse.h>


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
@property (nonatomic, strong) UIButton                          *checkboxButton;
@property (nonatomic, strong) UIButton                          *autoLoginButton;
@property (nonatomic, strong) UIButton                          *forgetPasswordButton;
@property (nonatomic) BOOL                                      checkboxSelected;
@property (nonatomic) BOOL                                      autoLoginSelected;
@property (nonatomic, strong) UITextView                        *rememberMeView;
@property (nonatomic, strong) UITextView                        *autoLoginView;

// Logged out subviews
@property (nonatomic, strong) UIImageView                       *viviImageView;
@property (nonatomic, strong) UILabel                           *textLabel;
@property (nonatomic, strong) CustomizedSettingPageButton       *signInButton;
@property (nonatomic, strong) CustomizedSettingPageButton       *signUpButton;
@property (nonatomic, strong) UILabel                           *accountLabel;
@property (nonatomic, strong) UILabel                           *passwordLabel;

@property (nonatomic, strong) NSLayoutConstraint                *userNameViewBottomConstraint;

@property (nonatomic, strong) SignUpAndSignInModel              *signUpAndSignInModel;
@property (nonatomic, strong) UserModel                         *userModel;
@property (nonatomic, strong) PFUser                            *currentLogInUser;

@property (nonatomic) BOOL                                      isFirstLoad;
@property (nonatomic) BOOL                                      isUpdatingAvatar;
@property (nonatomic) BOOL                                      isUpdatingUsername;
@property (nonatomic, strong) NSString                          *originUserName;
@property (nonatomic, strong) NSString                          *originAvatarUrl;
@property (nonatomic, strong) UIImage                           *tempImageForReupload;

@property (nonatomic, strong) CustomizedAlertView               *changeAvatarAlertView;

@property (nonatomic) BOOL                                      isAccountValid;
@property (nonatomic) BOOL                                      isPasswordValid;
@end

@implementation PersonalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Setting";
    [self initPermanentNotificationObservers];
    [self initNavigationBarBackButtonAtLeft];
    _isFirstLoad = YES;
    _currentLogInUser = [PFUser currentUser];
    
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
    [self initAvatarImageView];
    [self initChangeAvatarButton];
    [self initUserNameView];
    [self initLogoutButton];
    
    [UIView animateWithDuration:0.8 animations:^(){
        for (UIView *subView in self.view.subviews) {
            subView.alpha = 1;
        }
    }];
    
}

- (void) initUserLoggedOutLayout {
    [self initLoginButton];
    [UIView animateWithDuration:0.8 animations:^(){
        for (UIView *subView in self.view.subviews) {
            subView.alpha = 1;
        }
    }];
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
        
        
//        _originAvatarUrl = [_currentLogInUser getObjectForKey:@"avatar"];
        PFFile *imageFile = _currentLogInUser[@"imageFile"];
        __block __typeof (UIImageView *) avatarImageView = _avatarImageView;
        [_avatarImageView setImageWithURL:[NSURL URLWithString:imageFile.url]
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
        [_changeAvatarButton setTitle:@"Change Photo" forState:UIControlStateNormal];
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
                                                                            multiplier:1.0f constant:120.0f]];
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
        
        UILabel *displaynameLabel           = [[UILabel alloc] initForAutolayout];
        displaynameLabel.backgroundColor    = [UIColor clearColor];
        displaynameLabel.textColor          = [UIColor colorWithHexString:@"109bac"];
        displaynameLabel.font               = [UIFont boldSystemFontOfSize:17.0f];
        displaynameLabel.text               = @"Name";
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
        [_changeUserNameButton setTitle:@"Change" forState:UIControlStateNormal];
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
                                                                              multiplier:1.0f constant:60.0f]];
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
        _userNameTextField.text = _currentLogInUser[@"displayName"];
        _originUserName = _currentLogInUser[@"displayName"];
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
        [_logOutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_logOutButton];
        
        NSMutableArray *logOutButtonConstraint = @[].mutableCopy;
        
        [logOutButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_logOutButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_userNameTextField
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f constant:50.0f]];
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

- (void) initLoginButton {
    [self initAccountLabel];
    [self initSignInAccountTextField];
    [self initPasswordLabel];
    [self initSignInPasswordTextField];
    [self initSignInButton];
    [self initSignUpButton];
}

- (void) initSignInAccountTextField {
    if (!_signInAccountTextField) {
        _signInAccountTextField                          = [[UITextField alloc] initForAutolayout];
        _signInAccountTextField.backgroundColor          = [UIColor whiteColor];
        _signInAccountTextField.borderStyle              = UITextBorderStyleRoundedRect;
        _signInAccountTextField.font                     = [UIFont systemFontOfSize:15];
        _signInAccountTextField.placeholder              = @"Please enter user account";
        _signInAccountTextField.autocorrectionType       = UITextAutocorrectionTypeNo;
        _signInAccountTextField.keyboardType             = UIKeyboardTypeDefault;
        _signInAccountTextField.returnKeyType            = UIReturnKeyDone;
        _signInAccountTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
        _signInAccountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _signInAccountTextField.leftViewMode             = UITextFieldViewModeAlways;
        _signInAccountTextField.delegate                 = self;
        [_signInAccountTextField addTarget:self
                                    action:@selector(signInAccountTextFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_signInAccountTextField];
        
        NSMutableArray *signInAccountConstraint = @[].mutableCopy;
        
        [signInAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInAccountTextField
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_accountLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:5.0f]];
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
}


- (void) initSignInPasswordTextField {
    if (!_signInPasswordTextField) {
        _signInPasswordTextField                            = [[UITextField alloc] initForAutolayout];
        _signInPasswordTextField.backgroundColor            = [UIColor whiteColor];
        _signInPasswordTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _signInPasswordTextField.font                       = [UIFont systemFontOfSize:15];
        _signInPasswordTextField.placeholder                = @"Please enter a password";
        _signInPasswordTextField.secureTextEntry            = YES;
        _signInPasswordTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _signInPasswordTextField.keyboardType               = UIKeyboardTypeDefault;
        _signInPasswordTextField.returnKeyType              = UIReturnKeyDone;
        _signInPasswordTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _signInPasswordTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _signInPasswordTextField.leftViewMode               = UITextFieldViewModeAlways;
        _signInPasswordTextField.delegate                   = self;
        [_signInPasswordTextField addTarget:self
                                     action:@selector(signInPasswordTextFieldDidChange:)
                           forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_signInPasswordTextField];
        
        NSMutableArray *signInPasswordConstraint = @[].mutableCopy;
        
        [signInPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signInPasswordTextField
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_passwordLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:5.0f]];
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
                                                                          toItem:_signInPasswordTextField
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f constant:30.0f]];
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

- (void) initAccountLabel {
    if (!_accountLabel) {
        _accountLabel                 = [[UILabel alloc] initForAutolayout];
        _accountLabel.backgroundColor = [UIColor clearColor];
        _accountLabel.textColor       = [UIColor blackColor];
        [self.view addSubview:_accountLabel];
        
        NSMutableArray *labelConstraint = @[].mutableCopy;
        
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_accountLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f constant:30.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_accountLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:-20.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_accountLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:25.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_accountLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:labelConstraint];
    }
    _accountLabel.text = @"Account";
}

- (void) initPasswordLabel {
    if (!_passwordLabel) {
        _passwordLabel                 = [[UILabel alloc] initForAutolayout];
        _passwordLabel.backgroundColor = [UIColor clearColor];
        _passwordLabel.textColor       = [UIColor blackColor];
        [self.view addSubview:_passwordLabel];
        
        NSMutableArray *labelConstraint = @[].mutableCopy;
        
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_passwordLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_signInAccountTextField
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:15.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_passwordLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:-20.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_passwordLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:25.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_passwordLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:labelConstraint];
    }
    _passwordLabel.text = @"Password";
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
        _currentLogInUser = [PFUser currentUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self userLoggedIn];
        });
        
    }
}


#pragma mark - button actions
- (void)signInButtonClicked:(id)sender {
    if (_signInAccountTextField.text.length > 0 && _signInPasswordTextField.text.length > 0) {
        [PFUser logInWithUsernameInBackground:[[NSString alloc] initWithString:_signInAccountTextField.text]
                                     password:[[NSString alloc] initWithString:_signInPasswordTextField.text]
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                [self.hud hide:YES];
                                                _currentLogInUser = user;
//                                                [[NSNotificationCenter defaultCenter] postNotificationName:kEventUserStatusChanged object:@"LOGGED_IN"];
                                                [self userLoggedIn];
                                            } else {
                                                [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:[error userInfo][@"error"] delayToHide:1];
                                            }
                                        }];

    } else if(_signInAccountTextField.text.length > 0 && _signInPasswordTextField.text.length == 0) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter the password..." delayToHide:1];
    } else if (_signInPasswordTextField.text.length > 0 && _signInAccountTextField.text.length == 0) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter the account..." delayToHide:1];
    } else {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter the account and password..." delayToHide:1];
    }

}

- (void)signUpButtonClicked:(id)sender {
    SignUpViewController *signUpView = [SignUpViewController new];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:signUpView];
    naviController.navigationBar.translucent = NO;
    [self presentViewController:naviController animated:YES completion:nil];
}


- (void) changeUserNameButtonPressed:(id)sender {
    [_userNameTextField becomeFirstResponder];
}

- (void) changeAvatarButtonPressed:(id)sender {
    _changeAvatarAlertView = [[CustomizedAlertView alloc] initWithTitle:@"Change Photo" andMessage:@"Choice to get photo"];
    [_changeAvatarAlertView addButtonWithTitle:@"Camera" type:CustomizedAlertViewButtonTypeDefaultLightGreen handler:^(CustomizedAlertView *alertView) {
        [self useCamera];
    }];
    [_changeAvatarAlertView addButtonWithTitle:@"Library" type:CustomizedAlertViewButtonTypeDefaultGreen handler:^(CustomizedAlertView *alertView) {
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


- (void) checkValidation {
    if (_isAccountValid && _isPasswordValid) {
        _signInButton.alpha   = 1.0;
        _signInButton.enabled = YES;
    }
    else {
        _signInButton.alpha   = 0.3;
        _signInButton.enabled = NO;
    }
}

#pragma mark - methods
- (void)dismissKeyboard {
    [_signInAccountTextField resignFirstResponder];
    [_signInPasswordTextField resignFirstResponder];
    [_userNameTextField resignFirstResponder];
}

- (void) userLoggedIn {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.8 animations:^(){
            for (UIView *subView in self.view.subviews) {
                subView.alpha = 0;
            }
            if (_textLabel) {
                [_textLabel removeFromSuperview];
                _textLabel = nil;
            }
            if (_signInButton) {
                [_signInButton removeFromSuperview];
                _signInButton = nil;
            }
            if (_signUpButton) {
                [_signUpButton removeFromSuperview];
                _signUpButton = nil;
            }
            if (_signInAccountTextField) {
                [_signInAccountTextField removeFromSuperview];
                _signInAccountTextField = nil;
            }
            if (_signInPasswordTextField) {
                [_signInPasswordTextField removeFromSuperview];
                _signInPasswordTextField = nil;
            }
            if (_accountLabel) {
                [_accountLabel removeFromSuperview];
                _accountLabel = nil;
            }
            if (_passwordLabel) {
                [_passwordLabel removeFromSuperview];
                _passwordLabel = nil;
            }
            [self initUserLoggedInLayout];
        }];
        
    });
}

- (void) logout:(id)sender {
    [PFUser logOut];
    _currentLogInUser = nil;
    
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
        } completion:^(BOOL finished){
            [self initUserLoggedOutLayout];
        }];
        
    });
}

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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera is not authorized"
                                                            message:@"Camera is not authorized.Please authorize it"
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES"
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can not use camera"
                                                            message:@"Sorry, you don't have camera"
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

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

- (void) startToUploadAvatar:(UIImage *) image {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Uploading..." delayToHide:-1];
    _isUpdatingAvatar = YES;
    _tempImageForReupload = image;
    NSData *imageData = UIImageJPEGRepresentation([image scaledWithMaxLength:1000], 0.6);
    
    if (!_userModel) {
        _userModel = [[UserModel alloc] init];
        _userModel.delegate = self;
    }
    
    [_userModel uploadAvatarWithBlock:imageData ForUser:_currentLogInUser completeBlock:^(NSString *imageUrl) {
        [self.hud hide:YES];
         __block __typeof (UIImageView *) avatarImageView = _avatarImageView;
        [_avatarImageView setImageWithURL:[NSURL URLWithString:imageUrl]
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

        if (_isUpdatingAvatar) {
            _isUpdatingAvatar = NO;
        }
    }];
    
}

- (void) updateUsername {
    if (_userNameTextField.text.length > 0) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Saving..." delayToHide:-1];
        _isUpdatingUsername = YES;
        if (!_userModel) {
            _userModel = [[UserModel alloc] init];
            _userModel.delegate = self;
        }
        [_userModel updateUsername:_userNameTextField.text ForUser:_currentLogInUser completeBlock:^() {
            [self.hud hide:YES];
            [super backButtonPressed:self.navigationItem.leftBarButtonItem];
        }];
    } else {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter your name..." delayToHide:1];
    }
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

- (void) signInPasswordTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 8) {
            NSRange oversteppedRange = NSMakeRange(8, textField.text.length - 8);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
        
        if (textField.text.length >= 6) {
            _isPasswordValid = YES;
        } else {
            _isPasswordValid = NO;
        }
        
        [self checkValidation];
    }

}

- (void) signInAccountTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 10) {
            NSRange oversteppedRange = NSMakeRange(10, textField.text.length - 10);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
        
        if (textField.text.length >=6) {
            _isAccountValid = YES;
        } else {
            _isAccountValid = NO;
        }
        [self checkValidation];
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
    
    if (croppedImage) {
        [self startToUploadAvatar:croppedImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UserModel delegate
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
