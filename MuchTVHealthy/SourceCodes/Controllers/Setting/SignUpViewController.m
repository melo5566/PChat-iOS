//
//  SignUpViewController.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/30.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "SignUpViewController.h"
#import "CustomizedSettingPageButton.h"
#import "SignUpAndSignInModel.h"
#import "VerifyViewController.h"

@interface SignUpViewController () <UITextFieldDelegate, CustomizedSettingPageButtonDelegate, SignUpAndSignInModelDelegate>
@property (nonatomic, strong) UITextField                                   *signUpAccountTextField;
@property (nonatomic, strong) UITextField                                   *signUpPasswordTextField;
@property (nonatomic, strong) UITextField                                   *signUpUserNameTextField;
@property (nonatomic, strong) CustomizedSettingPageButton                   *confirmButton;
@property (nonatomic, strong) UILabel                                       *userNameLabel;
@property (nonatomic, strong) UILabel                                       *accountLabel;
@property (nonatomic, strong) UILabel                                       *passwordLabel;
@property (nonatomic, strong) SignUpAndSignInModel                          *signUpAndSignInModel;
@property (nonatomic) BOOL                                                  isAccountValid;
@property (nonatomic) BOOL                                                  isPasswordValid;
@property (nonatomic) BOOL                                                  isUserNameValid;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_signUpType isEqualToString:@"normal"]) {
        [self.navigationItem setTitle:@"註冊"];
        [self initNavigationBarCloseButtonAtLeft];
    } else {
        [self.navigationItem setTitle:@"電話註冊"];
        [self initNavigationBarBackButtonAtLeft];
    }
    
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
    if ([_signUpType isEqualToString:@"normal"]) {
        _signUpAccountTextField.keyboardType = UIKeyboardTypeDefault;
        _signUpAccountTextField.placeholder = @"Please enter account";
    } else {
        _signUpAccountTextField.keyboardType = UIKeyboardTypeNumberPad;
        _signUpAccountTextField.placeholder = @"Please enter your phone number";
    }
}


- (void) initSignUpPasswordTextField {
    if (!_signUpPasswordTextField) {
        _signUpPasswordTextField                            = [[UITextField alloc] initForAutolayout];
        _signUpPasswordTextField.backgroundColor            = [UIColor whiteColor];
        _signUpPasswordTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _signUpPasswordTextField.font                       = [UIFont systemFontOfSize:15];
        _signUpPasswordTextField.placeholder                = @"Please enter password";
        _signUpPasswordTextField.secureTextEntry            = YES;
        _signUpPasswordTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _signUpPasswordTextField.keyboardType               = UIKeyboardTypeDefault;
        _signUpPasswordTextField.returnKeyType              = UIReturnKeyDone;
        _signUpPasswordTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _signUpPasswordTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _signUpPasswordTextField.leftViewMode               = UITextFieldViewModeAlways;
        _signUpPasswordTextField.delegate                   = self;
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
                                                                           toItem:_signUpPasswordTextField
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
                                                               multiplier:1.0f constant:40.0f]];
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
    _userNameLabel.text = @"暱稱";
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
    if ([_signUpType isEqualToString:@"normal"])
        _accountLabel.text = @"帳號";
    else
        _accountLabel.text = @"電話號碼";
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
    _passwordLabel.text = @"密碼";
}


- (void)confirmButtonClicked:(id)sender {
    if (_signUpAccountTextField.text.length > 0 && _signUpPasswordTextField.text.length > 0 && _signUpUserNameTextField.text.length > 0) {
        _signUpAndSignInModel = [SignUpAndSignInModel new];
        _signUpAndSignInModel.delegate = self;
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"註冊中..." delayToHide:-1];
        if ([_signUpType isEqualToString:@"normal"]) {
            NSLog(@"normal signup");
            [_signUpAndSignInModel kiiUserSignUp:[[NSString alloc] initWithString:_signUpUserNameTextField.text]
                                         account:[[NSString alloc] initWithString:_signUpAccountTextField.text]
                                        password:[[NSString alloc] initWithString:_signUpPasswordTextField.text]
                                   CompleteBlock:^(KiiUser *user, NSError *error) {
                                       [self.hud hide:YES];
                                       if (error != nil) {
                                           NSLog(@"# ERROR : %@",error.userInfo[@"server_message"]);
                                           NSLog(@"# ERROR CODE : %ld",(long)error.code);
                                           return;
                                       }
                                       [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"註冊成功" delayToHide:1];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:kEventUserStatusChanged object:@"LOGGED_IN"];
                                       [self dismissViewControllerAnimated:YES completion:nil];

            }];
        } else {
            [_signUpAndSignInModel signUpWithPhoneNumber:[[NSString alloc] initWithString:_signUpUserNameTextField.text]
                                             phoneNumber:[[NSString alloc] initWithString:_signUpAccountTextField.text]
                                                password:[[NSString alloc] initWithString:_signUpPasswordTextField.text]
                                           CompleteBlock:^(KiiUser *user, NSError *error) {
                                               [self.hud hide:YES];
                                               if (error != nil) {
                                                   NSLog(@"# ERROR : %@",error.userInfo[@"server_message"]);
                                                   NSLog(@"# ERROR CODE : %ld",(long)error.code);
                                                   return;
                                               }
                                               [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"註冊成功" delayToHide:1];
                                               VerifyViewController *controller = [VerifyViewController new];
                                               [self.navigationController pushViewController:controller animated:YES];
//                                               [[NSNotificationCenter defaultCenter] postNotificationName:kEventUserStatusChanged object:@"LOGGED_IN"];
//                                               [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    } else {
        if ([_signUpType isEqualToString:@"normal"])
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"請輸入名稱，帳號和密碼" delayToHide:1];
        else
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"請輸入名稱，電話號碼和密碼" delayToHide:1];
    }
    
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
        if ([_signUpType isEqualToString:@"phone"]) {
            if (textField.text.length > 10) {
                NSRange oversteppedRange = NSMakeRange(10, textField.text.length - 10);
                textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
            }

        } else {
            if (textField.text.length > 8) {
                NSRange oversteppedRange = NSMakeRange(8, textField.text.length - 8);
                textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
            }

        }
        
        if ([_signUpType isEqualToString:@"phone"]) {
            if ([textField.text isPhoneNumber])
                _isAccountValid = YES;
            else
                _isAccountValid = NO;
        } else {
            if (textField.text.length >= 6) {
                _isAccountValid = YES;
            } else {
                _isAccountValid = NO;
            }

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
