//
//  VerifyViewController.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/19.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "VerifyViewController.h"
#import "CustomizedSettingPageButton.h"
#import "SignUpAndSignInModel.h"
#import "CustomizedAlertView.h"
#import "PersonalSettingViewController.h"

@interface VerifyViewController () <UITextFieldDelegate, CustomizedSettingPageButtonDelegate, SignUpAndSignInModelDelegate>
@property (nonatomic, strong) UITextField                   *verifyTextField;
@property (nonatomic, strong) CustomizedSettingPageButton   *confirmButton;
@property (nonatomic, strong) SignUpAndSignInModel          *signUpAndSignInModel;
@property (nonatomic, strong) CustomizedAlertView           *alert;
@property (nonatomic, strong) UIButton                      *resendVerificationButton;
@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    self.navigationItem.title = @"電話認證";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    if (!_signUpAndSignInModel) {
        _signUpAndSignInModel = [SignUpAndSignInModel new];
        _signUpAndSignInModel.delegate = self;
    }
    [self initConfirmButton];
    [self initVerifyTextField];
    [self initResendVerificationButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init
- (void) initVerifyTextField {
    if (!_verifyTextField) {
        _verifyTextField                            = [[UITextField alloc] initForAutolayout];
        _verifyTextField.backgroundColor            = [UIColor whiteColor];
        _verifyTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _verifyTextField.font                       = [UIFont systemFontOfSize:15];
        _verifyTextField.placeholder                = @"Please enter verified code";
        _verifyTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _verifyTextField.keyboardType               = UIKeyboardTypeDefault;
        _verifyTextField.returnKeyType              = UIReturnKeyDone;
        _verifyTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _verifyTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _verifyTextField.leftViewMode               = UITextFieldViewModeAlways;
        _verifyTextField.delegate                   = self;
        [_verifyTextField addTarget:self
                                     action:@selector(verifyTextFieldDidChange:)
                           forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_verifyTextField];
        
        NSMutableArray *verifyTextFieldConstraint = @[].mutableCopy;
        
        [verifyTextFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_verifyTextField
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_confirmButton
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:-20.0f]];
        [verifyTextFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_verifyTextField
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-20.0f]];
        [verifyTextFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_verifyTextField
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:20.0f]];
        [verifyTextFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_verifyTextField
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:40.0f]];
        
        [self.view addConstraints:verifyTextFieldConstraint];
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
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0f constant:0.0f]];
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

- (void) initResendVerificationButton {
    if (!_resendVerificationButton) {
        _resendVerificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resendVerificationButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_resendVerificationButton addTarget:self action:@selector(resendVerificationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_resendVerificationButton setTitle:@"重新發送驗證碼" forState:UIControlStateNormal];
         _resendVerificationButton.backgroundColor = [UIColor clearColor];
        [_resendVerificationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _resendVerificationButton.titleLabel.font     = [UIFont systemFontOfSize:15];
        [self.view addSubview:_resendVerificationButton];
        
        NSMutableArray *voteViewStatusLabelConstaint = @[].mutableCopy;
        
        [voteViewStatusLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_resendVerificationButton
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_verifyTextField
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0f constant:-10.0f]];
        [voteViewStatusLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_resendVerificationButton
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_verifyTextField
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0f constant:0.0f]];
        [voteViewStatusLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_resendVerificationButton
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:100.0f]];
        [voteViewStatusLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_resendVerificationButton
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:25.0f]];
        
        [self.view addConstraints:voteViewStatusLabelConstaint];
        
    }
}


- (void) dismissKeyboard {
    [_verifyTextField resignFirstResponder];
}

- (void) verifyTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 4) {
            NSRange oversteppedRange = NSMakeRange(4, textField.text.length - 4);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
    }
}

#pragma mark - button action
- (void)confirmButtonClicked:(id)sender {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"認證中..." delayToHide:-1];
    [_signUpAndSignInModel verifyPhoneNumberWithCode:_verifyTextField.text WithCompleteBlock:^(KiiUser *user, NSError *error) {
        [self.hud hide:YES];
        if (error != nil) {
            if ([error.userInfo[@"server_code"] isEqualToString:@"INVALID_VERIFICATION_CODE"]) {
                NSLog(@"# ERROR : INVALID_VERIFICATION_CODE");
                _alert = [[CustomizedAlertView alloc] initWithTitle:nil andMessage:@"驗證碼錯誤！"];
                [_alert addButtonWithTitle:@"確認" type:CustomizedAlertViewButtonTypeDefaultPink handler:^(CustomizedAlertView *alertView) {}];
                [_alert show];
            } else {
                [self hasNoNetworkConnection];
            }
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kEventUserStatusChanged object:@"LOGGED_IN"];
        _alert = [[CustomizedAlertView alloc] initWithTitle:nil andMessage:@"驗證成功！"];
        [_alert addButtonWithTitle:@"確認" type:CustomizedAlertViewButtonTypeDefaultPink handler:^(CustomizedAlertView *alertView) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonalSettingViewController class]]) {
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    break;
                }
            }
        }];
        [_alert show];
    }];
}

- (void) resendVerificationButtonClicked:(id)sender {
    [_signUpAndSignInModel resendPhoneVerificationCodeWithCompleteBlock:^(KiiUser *user, NSError *error) {
        if (error != nil) {
            NSLog(@"# ERROR : %@",error.userInfo[@"server_message"]);
            NSLog(@"# ERROR CODE : %ld",(long)error.code);
            return;
        }
        _alert = [[CustomizedAlertView alloc] initWithTitle:nil andMessage:@"已發送驗證碼"];
        [_alert addButtonWithTitle:@"確認" type:CustomizedAlertViewButtonTypeDefaultPink handler:nil];
        [_alert show];
    }];
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
