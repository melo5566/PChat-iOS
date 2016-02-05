//
//  SignUpViewController.m
//  493_Project
//
//  Created by Peter on 2015/10/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "SignUpViewController.h"
#import "CustomizedSettingPageButton.h"
#import "SignUpAndSignInModel.h"
#import <Parse/Parse.h>

@interface SignUpViewController () <UITextFieldDelegate, CustomizedSettingPageButtonDelegate, SignUpAndSignInModelDelegate>
@property (nonatomic, strong) UITextField                                   *signUpAccountTextField;
@property (nonatomic, strong) UITextField                                   *signUpPasswordTextField;
@property (nonatomic, strong) UITextField                                   *signUpUserNameTextField;
@property (nonatomic, strong) UITextField                                   *reSignUpPasswordTextField;
@property (nonatomic, strong) CustomizedSettingPageButton                   *confirmButton;
@property (nonatomic, strong) UILabel                                       *userNameLabel;
@property (nonatomic, strong) UILabel                                       *accountLabel;
@property (nonatomic, strong) UILabel                                       *passwordLabel;
@property (nonatomic, strong) UILabel                                       *rePasswordLabel;
@property (nonatomic, strong) SignUpAndSignInModel                          *signUpAndSignInModel;
@property (nonatomic) BOOL                                                  isAccountValid;
@property (nonatomic) BOOL                                                  isPasswordValid;
@property (nonatomic) BOOL                                                  isUserNameValid;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Sign Up"];
    [self initNavigationBarCloseButtonAtLeft];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self initLayout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_signUpAccountTextField resignFirstResponder];
    [_signUpPasswordTextField resignFirstResponder];
    [_signUpUserNameTextField resignFirstResponder];
}


#pragma mark - init
- (void) initLayout {
    [self initUserNameLabel];
    [self initSignUpUserNameTextField];
    [self initAccountLabel];
    [self initSignUpAccountTextField];
    [self initPasswordLabel];
    [self initSignUpPasswordTextField];
    [self initRePasswordLabel];
    [self initReSignUpPasswordTextField];
    [self initConfirmButton];
}

- (void) initSignUpUserNameTextField {
    if (!_signUpUserNameTextField) {
        _signUpUserNameTextField                            = [[UITextField alloc] initForAutolayout];
        _signUpUserNameTextField.backgroundColor            = [UIColor whiteColor];
        _signUpUserNameTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _signUpUserNameTextField.font                       = [UIFont systemFontOfSize:15];
        _signUpUserNameTextField.placeholder                = @"Please enter your name";
        _signUpUserNameTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _signUpUserNameTextField.keyboardType               = UIKeyboardTypeDefault;
        _signUpUserNameTextField.returnKeyType              = UIReturnKeyDone;
        _signUpUserNameTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _signUpUserNameTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _signUpUserNameTextField.leftViewMode               = UITextFieldViewModeAlways;
        _signUpUserNameTextField.delegate                   = self;
        [_signUpUserNameTextField addTarget:self
                                    action:@selector(signUpUserNameTextFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_signUpUserNameTextField];
        
        NSMutableArray *signUpUserNameConstraint = @[].mutableCopy;
        
        [signUpUserNameConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpUserNameTextField
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_userNameLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:0.0f]];
        [signUpUserNameConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpUserNameTextField
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-20.0f]];
        [signUpUserNameConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpUserNameTextField
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:20.0f]];
        [signUpUserNameConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpUserNameTextField
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:40.0f]];
        
        [self.view addConstraints:signUpUserNameConstraint];
    }
}


- (void) initSignUpAccountTextField {
    if (!_signUpAccountTextField) {
        _signUpAccountTextField = [[UITextField alloc] initForAutolayout];
        _signUpAccountTextField.backgroundColor = [UIColor whiteColor];
        _signUpAccountTextField.borderStyle = UITextBorderStyleRoundedRect;
        _signUpAccountTextField.font = [UIFont systemFontOfSize:15];
        _signUpAccountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _signUpAccountTextField.returnKeyType = UIReturnKeyDone;
        _signUpAccountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _signUpAccountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _signUpAccountTextField.leftViewMode = UITextFieldViewModeAlways;
        _signUpAccountTextField.delegate = self;
        [_signUpAccountTextField addTarget:self
                                     action:@selector(signUpAccountTextFieldDidChange:)
                           forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_signUpAccountTextField];
        
        NSMutableArray *signUpAccountConstraint = @[].mutableCopy;
        
        [signUpAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpAccountTextField
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_accountLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0.0f]];
        [signUpAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpAccountTextField
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-20.0f]];
        [signUpAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpAccountTextField
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:20.0f]];
        [signUpAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpAccountTextField
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:40.0f]];
        
        [self.view addConstraints:signUpAccountConstraint];
    }
    _signUpAccountTextField.keyboardType = UIKeyboardTypeDefault;
    _signUpAccountTextField.placeholder = @"Please enter account(6-8 letter or number)";
}


- (void) initSignUpPasswordTextField {
    if (!_signUpPasswordTextField) {
        _signUpPasswordTextField                            = [[UITextField alloc] initForAutolayout];
        _signUpPasswordTextField.backgroundColor            = [UIColor whiteColor];
        _signUpPasswordTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _signUpPasswordTextField.font                       = [UIFont systemFontOfSize:15];
        _signUpPasswordTextField.placeholder                = @"Please enter a password(6-8 letter or number)";
        _signUpPasswordTextField.secureTextEntry            = YES;
        _signUpPasswordTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _signUpPasswordTextField.keyboardType               = UIKeyboardTypeDefault;
        _signUpPasswordTextField.returnKeyType              = UIReturnKeyDone;
        _signUpPasswordTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _signUpPasswordTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _signUpPasswordTextField.leftViewMode               = UITextFieldViewModeAlways;
        _signUpPasswordTextField.delegate                   = self;
        
        _signUpPasswordTextField.returnKeyType = UIReturnKeyDone;
        
        [_signUpPasswordTextField addTarget:self
                                     action:@selector(signUpPasswordTextFieldDidChange:)
                           forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_signUpPasswordTextField];
        
        NSMutableArray *signUpPasswordConstraint = @[].mutableCopy;
        
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpPasswordTextField
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_passwordLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:0.0f]];
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpPasswordTextField
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-20.0f]];
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpPasswordTextField
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:20.0f]];
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpPasswordTextField
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:40.0f]];
        
        [self.view addConstraints:signUpPasswordConstraint];
    }
    
}

- (void) initReSignUpPasswordTextField {
    if (!_reSignUpPasswordTextField) {
        _reSignUpPasswordTextField                            = [[UITextField alloc] initForAutolayout];
        _reSignUpPasswordTextField.backgroundColor            = [UIColor whiteColor];
        _reSignUpPasswordTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _reSignUpPasswordTextField.font                       = [UIFont systemFontOfSize:15];
        _reSignUpPasswordTextField.placeholder                = @"Please confirm the password...";
        _reSignUpPasswordTextField.secureTextEntry            = YES;
        _reSignUpPasswordTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _reSignUpPasswordTextField.keyboardType               = UIKeyboardTypeDefault;
        _reSignUpPasswordTextField.returnKeyType              = UIReturnKeyDone;
        _reSignUpPasswordTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _reSignUpPasswordTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _reSignUpPasswordTextField.leftViewMode               = UITextFieldViewModeAlways;
        _reSignUpPasswordTextField.delegate                   = self;
        
        _reSignUpPasswordTextField.returnKeyType = UIReturnKeyDone;
        
        [_reSignUpPasswordTextField addTarget:self
                                     action:@selector(signUpPasswordTextFieldDidChange:)
                           forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_reSignUpPasswordTextField];
        
        NSMutableArray *signUpPasswordConstraint = @[].mutableCopy;
        
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_reSignUpPasswordTextField
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_rePasswordLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:0.0f]];
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_reSignUpPasswordTextField
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-20.0f]];
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_reSignUpPasswordTextField
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:20.0f]];
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_reSignUpPasswordTextField
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:40.0f]];
        
        [self.view addConstraints:signUpPasswordConstraint];
    }
    
}

- (void) initConfirmButton {
    if (!_confirmButton) {
        _confirmButton                       = [[CustomizedSettingPageButton alloc] init];
        _confirmButton.alpha                 = 1;
        _confirmButton.delegate              = self;
        _confirmButton.settingPageButtonType = SettingPageButtonTypeConfirm;
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
        
        NSMutableArray *confirmButtonConstraint = @[].mutableCopy;
        
        [confirmButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_confirmButton
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:_reSignUpPasswordTextField
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:40.0f]];
        [confirmButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_confirmButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-20.0f]];
        [confirmButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_confirmButton
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:20.0f]];
        [confirmButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_confirmButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0f constant:50.0f]];
        
        [self.view addConstraints:confirmButtonConstraint];
    }
}

- (void) initUserNameLabel {
    if (!_userNameLabel) {
        _userNameLabel                 = [[UILabel alloc] initForAutolayout];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor       = [UIColor blackColor];
        [self.view addSubview:_userNameLabel];
        
        NSMutableArray *labelConstraint = @[].mutableCopy;
        
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f constant:10.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:25.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:-20.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:labelConstraint];
    }
    _userNameLabel.text = @"Display Name";
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
                                                                   toItem:_signUpUserNameTextField
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:15.0f]];
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
                                                                   toItem:_signUpAccountTextField
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

- (void) initRePasswordLabel {
    if (!_rePasswordLabel) {
        _rePasswordLabel                 = [[UILabel alloc] initForAutolayout];
        _rePasswordLabel.backgroundColor = [UIColor clearColor];
        _rePasswordLabel.textColor       = [UIColor blackColor];
        [self.view addSubview:_rePasswordLabel];
        
        NSMutableArray *labelConstraint = @[].mutableCopy;
        
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_rePasswordLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_signUpPasswordTextField
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:15.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_rePasswordLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:-20.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_rePasswordLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:25.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_rePasswordLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:labelConstraint];
    }
    _rePasswordLabel.text = @"Confirm Password";
}


- (void)confirmButtonClicked:(id)sender {
    if (_signUpAccountTextField.text.length > 0 && _signUpPasswordTextField.text.length > 0 && _signUpUserNameTextField.text.length > 0 && _reSignUpPasswordTextField.text.length > 0) {
        if ([_reSignUpPasswordTextField.text isEqualToString:_signUpPasswordTextField.text]) {
            _signUpAndSignInModel = [SignUpAndSignInModel new];
            _signUpAndSignInModel.delegate = self;
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Signing Up..." delayToHide:-1];
            PFUser *user = [PFUser user];
            user[@"displayName"] = [[NSString alloc] initWithString:_signUpUserNameTextField.text];
            user.username = [[NSString alloc] initWithString:_signUpAccountTextField.text];
            user.password = [[NSString alloc] initWithString:_signUpPasswordTextField.text];
            user[@"hasChatroom"] = @NO;
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self.hud hide:YES];
                    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Successfully Sign Up..." delayToHide:1];
                    [PFUser logInWithUsernameInBackground:user.username
                                                 password:user.password
                                                    block:^(PFUser *user, NSError *error) {
                                                        if (user) {
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:kEventUserStatusChanged object:@"LOGGED_IN"];
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                        } else {
                                                            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:[error userInfo][@"error"] delayToHide:1];
                                                        }
                                                    }];
                    
                } else {
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    [self.hud hide:YES];
                    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:errorString delayToHide:1];
                }
            }];
        } else
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"The password and confirm password should be the same..." delayToHide:1];
    } else
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter name, account and password..." delayToHide:1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissKeyboard {
    [_signUpUserNameTextField resignFirstResponder];
    [_signUpAccountTextField resignFirstResponder];
    [_signUpPasswordTextField resignFirstResponder];
}

- (void) checkValidation {
    if (_isAccountValid && _isPasswordValid && _isUserNameValid) {
        _confirmButton.alpha   = 1.0;
        _confirmButton.enabled = YES;
    }
    else {
        _confirmButton.alpha   = 0.3;
        _confirmButton.enabled = NO;
    }
}

- (void) signUpUserNameTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 8) {
            NSRange oversteppedRange = NSMakeRange(8, textField.text.length - 8);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
        
        if (textField.text.length > 0) {
            _isUserNameValid = YES;
        } else {
            _isUserNameValid = NO;
        }
        
        [self checkValidation];
    }
    
}

- (void) signUpAccountTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 8) {
            NSRange oversteppedRange = NSMakeRange(8, textField.text.length - 8);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
        if (textField.text.length >= 6) {
            _isAccountValid = YES;
        } else {
            _isAccountValid = NO;
        }
        [self checkValidation];
    }
    
}

- (void) signUpPasswordTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 8) {
            NSRange oversteppedRange = NSMakeRange(8, textField.text.length - 8);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
        
        if ([textField.text isPassword] && textField.text.length >= 6) {
            _isPasswordValid = YES;
        } else {
            _isPasswordValid = NO;
        }
        
        [self checkValidation];
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
