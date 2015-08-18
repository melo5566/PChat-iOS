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

@interface SignUpViewController () <UITextFieldDelegate, CustomizedSettingPageButtonDelegate, SignUpAndSignInModelDelegate>
@property (nonatomic, strong) UITextField                                   *signUpAccountTextField;
@property (nonatomic, strong) UITextField                                   *signUpPasswordTextField;
@property (nonatomic, strong) UITextField                                   *signUpUserNameTextField;
@property (nonatomic, strong) CustomizedSettingPageButton                   *confirmButton;
@property (nonatomic, strong) NSString                                      *account;
@property (nonatomic, strong) NSString                                      *password;
@property (nonatomic, strong) NSString                                      *userName;
@property (nonatomic, strong) SignUpAndSignInModel                          *signUpAndSignInModel;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarCloseButtonAtLeft];
    [self.navigationItem setTitle:@"註冊"];
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




#pragma mark - init
- (void) initLayout {
    [self initSignUpUserNameTextField];
    [self initSignUpAccountTextField];
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
        [self.view addSubview:_signUpUserNameTextField];
        
        NSMutableArray *signUpUserNameConstraint = @[].mutableCopy;
        
        [signUpUserNameConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpUserNameTextField
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:100.0f]];
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
        _signUpAccountTextField.keyboardType = UIKeyboardTypeDefault;
        _signUpAccountTextField.returnKeyType = UIReturnKeyDone;
        _signUpAccountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _signUpAccountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _signUpAccountTextField.leftViewMode = UITextFieldViewModeAlways;
        _signUpAccountTextField.delegate = self;
        [self.view addSubview:_signUpAccountTextField];
        
        NSMutableArray *signUpAccountConstraint = @[].mutableCopy;
        
        [signUpAccountConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpAccountTextField
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_signUpUserNameTextField
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:15.0f]];
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
        _signUpAccountTextField.placeholder = @"Please enter account";
    } else {
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
        [self.view addSubview:_signUpPasswordTextField];
        
        NSMutableArray *signUpPasswordConstraint = @[].mutableCopy;
        
        [signUpPasswordConstraint addObject:[NSLayoutConstraint constraintWithItem:_signUpPasswordTextField
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_signUpAccountTextField
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:15.0f]];
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
                                                                      multiplier:1.0f constant:50.0f]];
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
                                               [[NSNotificationCenter defaultCenter] postNotificationName:kEventUserStatusChanged object:@"LOGGED_IN"];
                                               [self dismissViewControllerAnimated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
