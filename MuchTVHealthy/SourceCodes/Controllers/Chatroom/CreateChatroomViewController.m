//
//  CreateChatroomViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/24.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "CreateChatroomViewController.h"
#import "CustomizedSettingPageButton.h"
#import "ChatroomModel.h"
#import <Parse/Parse.h>

@interface CreateChatroomViewController () <CustomizedSettingPageButtonDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITextField                   *nameTextField;
@property (nonatomic, strong) UITextField                   *distanceTextField;
@property (nonatomic, strong) CustomizedSettingPageButton   *createButton;
@property (nonatomic, strong) ChatroomModel                 *chatroomModel;
@property (nonatomic, strong) PFUser                        *currentUser;
@property (nonatomic, strong) UILabel                       *chatroomNameLabel;
@property (nonatomic, strong) UILabel                       *distanceLabel;
@end

@implementation CreateChatroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Create Chatroom"];
    [self initNavigationBarBackButtonAtLeft];
    _chatroomModel = [ChatroomModel new];
    _currentUser = [PFUser currentUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([_currentUser[@"chatroomID"] isNotEmpty]) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Loading..." delayToHide:-1];
        [_chatroomModel getOwnChatroomDataWithBlock:_currentUser[@"chatroomID"] completeBlock:^(NSString *chatroomName, NSUInteger distance) {
            [self.hud hide:YES];
            [self initChatroomNameLabel];
            [self initNameTextField:chatroomName];
            [self initDistanceLabel];
            [self initDistanceTextField:distance];
            [self initCreateButton];
        }];
    } else {
        [self initChatroomNameLabel];
        [self initNameTextField:@""];
        [self initDistanceLabel];
        [self initDistanceTextField:0];
        [self initCreateButton];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void) initChatroomNameLabel {
    if (!_chatroomNameLabel) {
        _chatroomNameLabel                 = [[UILabel alloc] initForAutolayout];
        _chatroomNameLabel.backgroundColor = [UIColor clearColor];
        _chatroomNameLabel.textColor       = [UIColor blackColor];
        [self.view addSubview:_chatroomNameLabel];
        
        NSMutableArray *labelConstraint = @[].mutableCopy;
        
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_chatroomNameLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f constant:30.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_chatroomNameLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:-20.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_chatroomNameLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:25.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_chatroomNameLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:labelConstraint];
    }
    _chatroomNameLabel.text = @"Chatroom Name";
}

- (void) initDistanceLabel {
    if (!_distanceLabel) {
        _distanceLabel                 = [[UILabel alloc] initForAutolayout];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textColor       = [UIColor blackColor];
        [self.view addSubview:_distanceLabel];
        
        NSMutableArray *labelConstraint = @[].mutableCopy;
        
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_nameTextField
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f constant:15.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:-20.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:25.0f]];
        [labelConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:labelConstraint];
    }
    _distanceLabel.text = @"Distance(meter)";
}


- (void) initNameTextField:(NSString *)chatroomName {
    if (!_nameTextField) {
        _nameTextField                            = [[UITextField alloc] initForAutolayout];
        _nameTextField.backgroundColor            = [UIColor whiteColor];
        _nameTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _nameTextField.font                       = [UIFont systemFontOfSize:15];
        _nameTextField.placeholder                = @"Please enter chatroom name(max 20)";
        _nameTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _nameTextField.keyboardType               = UIKeyboardTypeDefault;
        _nameTextField.returnKeyType              = UIReturnKeyDone;
        _nameTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _nameTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _nameTextField.leftViewMode               = UITextFieldViewModeAlways;
        _nameTextField.delegate                   = self;
        [_nameTextField addTarget:self
                           action:@selector(nameTextFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_nameTextField];
        
        NSMutableArray *nameFieldConstraint = @[].mutableCopy;
        
        [nameFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_chatroomNameLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:5.0f]];
        [nameFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:-20.0f]];
        [nameFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:20.0f]];
        [nameFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_nameTextField
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:nameFieldConstraint];
    }
    if ([_currentUser[@"chatroomID"] isNotEmpty])
        _nameTextField.text = chatroomName;
}


- (void) initDistanceTextField:(NSUInteger )distance {
    if (!_distanceTextField) {
        _distanceTextField                            = [[UITextField alloc] initForAutolayout];
        _distanceTextField.backgroundColor            = [UIColor whiteColor];
        _distanceTextField.borderStyle                = UITextBorderStyleRoundedRect;
        _distanceTextField.font                       = [UIFont systemFontOfSize:15];
        _distanceTextField.placeholder                = @"Please enter the distance(min 50 meter)";
        _distanceTextField.autocorrectionType         = UITextAutocorrectionTypeNo;
        _distanceTextField.keyboardType               = UIKeyboardTypeNumbersAndPunctuation;
        _distanceTextField.returnKeyType              = UIReturnKeyDone;
        _distanceTextField.clearButtonMode            = UITextFieldViewModeWhileEditing;
        _distanceTextField.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
        _distanceTextField.leftViewMode               = UITextFieldViewModeAlways;
        _distanceTextField.delegate                   = self;
        [_distanceTextField addTarget:self
                           action:@selector(distanceTextFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_distanceTextField];
        
        NSMutableArray *distanceFieldConstraint = @[].mutableCopy;
        
        [distanceFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceTextField
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_distanceLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:5.0f]];
        [distanceFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceTextField
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-20.0f]];
        [distanceFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceTextField
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:20.0f]];
        [distanceFieldConstraint addObject:[NSLayoutConstraint constraintWithItem:_distanceTextField
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:distanceFieldConstraint];
    }
    if ([_currentUser[@"chatroomID"] isNotEmpty])
        _distanceTextField.text = [NSString stringWithFormat:@"%lu",distance];
}


- (void) initCreateButton {
    if (!_createButton) {
        _createButton                       = [[CustomizedSettingPageButton alloc] init];
        _createButton.delegate              = self;
        _createButton.settingPageButtonType = ChatroomButtonTypeCreate;
        [_createButton addTarget:self action:@selector(createButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_createButton];
        
        NSMutableArray *createButtonConstraint = @[].mutableCopy;
        
        [createButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_createButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_distanceTextField
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f constant:30.0f]];
        [createButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_createButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f constant:-20.0f]];
        [createButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_createButton
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0f constant:20.0f]];
        [createButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_createButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_createButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:58.5/345 constant:0.0f]];
        
        [self.view addConstraints:createButtonConstraint];
    }
}


- (void)createButtonClicked:(id)sender {
    if (_nameTextField.text.length > 0 && _distanceTextField.text.length > 0) {
        if (![self isNumeric:_distanceTextField.text]) {
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter number as distance..." delayToHide:1];
        } else if ([_distanceTextField.text integerValue] < 50)
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"The distance should be greater than 50..." delayToHide:1];
        else {
            [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                if (!error) {
                    if (![_currentUser[@"chatroomID"] isNotEmpty]) {
                        [_chatroomModel createChatroomWithBlock:_nameTextField.text distance:[_distanceTextField.text intValue] creator:_currentUser geoPoint:geoPoint completeBlock:^() {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    } else {
                        [_chatroomModel updateChatroomDataWithBlock:_nameTextField.text distance:[_distanceTextField.text intValue] chatroomID:_currentUser[@"chatroomID"] geoPoint:geoPoint completeBlock:^() {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                } else
                    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Can't get your location..." delayToHide:1];
            }];
        }
    } else {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter chatroom name and distance..." delayToHide:1];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) nameTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 20) {
            NSRange oversteppedRange = NSMakeRange(8, textField.text.length - 8);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
    }
    
}

- (void) distanceTextFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (isNullValue([textField markedTextRange])) {
        if (textField.text.length > 8) {
            NSRange oversteppedRange = NSMakeRange(8, textField.text.length - 8);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
    }
    
}

- (BOOL)isNumeric:(NSString *)string {
    NSScanner *sc = [NSScanner scannerWithString:string];
    if ( [sc scanFloat:NULL] ) {
        return [sc isAtEnd];
    }
    return NO;
}

- (void)dismissKeyboard {
    [_nameTextField resignFirstResponder];
    [_distanceTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
