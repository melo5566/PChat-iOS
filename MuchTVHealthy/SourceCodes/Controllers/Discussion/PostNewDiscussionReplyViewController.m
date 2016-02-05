//
//  PostNewDiscussionReplyViewController.m
//  493_Project
//
//  Created by Peter on 2015/11/21.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "PostNewDiscussionReplyViewController.h"
#import "CustomizedAlertView.h"
#import "DiscussionModel.h"
#import <Parse/Parse.h>

@interface PostNewDiscussionReplyViewController () <UITextViewDelegate>
//@property (nonatomic, strong) UIView                        *contentView;
@property (nonatomic, strong) UITextView                    *contentTextView;
@property (nonatomic, strong) UILabel                       *placeHolder;
@property (nonatomic, strong) DiscussionModel               *discussionModel;
@property (nonatomic, strong) NSLayoutConstraint            *contentViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint            *contentViewHeightConstraint;
@property (nonatomic, strong) PFUser                        *currentUser;
//@property (nonatomic, strong) UIAlertView                   *notFinishedAlert;
@property (nonatomic, strong) CustomizedAlertView           *notFinishedAlert;
@property (nonatomic) BOOL                                  isFirstLoad;
@property float                                             keyboardHeight;
@end

@implementation PostNewDiscussionReplyViewController

- (void)setDiscussionObject:(DiscussionObject *)discussionObject {
    _discussionObject = discussionObject;
    if ([PFUser currentUser])
        _currentUser = [PFUser currentUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    [self.navigationItem setTitle:@"Reply"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ecf8f7"];
    _isFirstLoad = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNotificationObservers];
    if (!_discussionModel) {
        _discussionModel = [[DiscussionModel alloc] init];
        _discussionModel.delegate = self;
    }
    [self initLayout];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isFirstLoad) {
        _isFirstLoad = NO;
        [_contentTextView becomeFirstResponder];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotificationObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - init
- (void)initLayout {
    [self initPostBarButton];
    [self initContentTextView];
    [self initPlaceHolder];
}

- (void)initPostBarButton {
    UIButton *customizedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame = CGRectMake(0, 0, 40, 17);
    [customizedButton setTitle:@"Post" forState:UIControlStateNormal];
    [customizedButton setTitleColor:[UIColor colorWithR:255 G:255 B:255] forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(postBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
}


- (void) initContentTextView {
    if (!_contentTextView) {
        _contentTextView                    = [[UITextView alloc] initForAutolayout];
        _contentTextView.font               = [UIFont systemFontOfSize:18.0f];
        _contentTextView.delegate           = self;
        _contentTextView.backgroundColor    = [UIColor colorWithHexString:@"#ffffff"];
        _contentTextView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        _contentTextView.layer.borderWidth  = 0.5;
        
        [self.view addSubview:_contentTextView];
        
        NSMutableArray *contentViewConstaint = @[].mutableCopy;
        
        [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:15.0f]];
        [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:15.0f]];
        [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-15.0f]];
        
        [self.view addConstraints:contentViewConstaint];
        
        _contentViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_contentTextView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:-15.0f];
        [self.view addConstraint:_contentViewBottomConstraint];
    }
}


- (void)initPlaceHolder {
    if (!_placeHolder) {
        _placeHolder                    = [[UILabel alloc] initForAutolayout];
        _placeHolder.backgroundColor    = [UIColor clearColor];
        _placeHolder.font               = [UIFont systemFontOfSize:18.0f];
        _placeHolder.textColor          = [UIColor colorWithHexString:@"#6d6d6d"];
        _placeHolder.text               = @"reply(max140)...";
        [_contentTextView addSubview:_placeHolder];
        
        NSMutableArray *placeHolderConstraint = @[].mutableCopy;
        
        [placeHolderConstraint addObject:[NSLayoutConstraint constraintWithItem:_placeHolder
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentTextView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:5.0f]];
        [placeHolderConstraint addObject:[NSLayoutConstraint constraintWithItem:_placeHolder
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentTextView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:7.0f]];
        [placeHolderConstraint addObject:[NSLayoutConstraint constraintWithItem:_placeHolder
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentTextView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-9.0f]];
        [placeHolderConstraint addObject:[NSLayoutConstraint constraintWithItem:_placeHolder
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:21.0f]];
        
        [self.view addConstraints:placeHolderConstraint];
    }
}

- (void)initNotificationObservers {
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _contentTextView && isNullValue([textView markedTextRange])) {
        if (textView.text.length > 0) {
            _placeHolder.hidden = YES;
        }
        else {
            _placeHolder.hidden = NO;
        }
        
        if (textView.text.length > kDiscussionContentTextLimitLength) {
            NSRange oversteppedRange = NSMakeRange(kDiscussionContentTextLimitLength, textView.text.length - kDiscussionContentTextLimitLength);
            textView.text = [textView.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
    }
    
}

#pragma mark - button clicked
- (void)postBarButtonClicked:(id)sender {
    if (_contentTextView.text.length > 0) {
        [self postReply];
    } else {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter reply..." delayToHide:1];
    }
}

- (void) backButtonPressed:(id) sender {
    if ([_contentTextView isFirstResponder]) {
        [_contentTextView endEditing:YES];
    }
    _notFinishedAlert = [[CustomizedAlertView alloc] initWithTitle:@"Warning" andMessage:@"Not done yet，\nAre you sure"];
    [_notFinishedAlert addButtonWithTitle:@"Stay"
                                        type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                     handler:nil];
    
    [_notFinishedAlert addButtonWithTitle:@"Exit"
                                     type:CustomizedAlertViewButtonTypeDefaultGreen
                                  handler:^(CustomizedAlertView *alertView) {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }];

    [_notFinishedAlert show];
}

- (void) action {
    NSLog(@"action");
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"SHOW");
//    _keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    NSDictionary* keyboardInfo = [notification userInfo];
    
    NSValue* keyboardEndFrameValue = keyboardInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardEndFrame = [keyboardEndFrameValue CGRectValue];
    
    NSNumber* animationDurationNumber = keyboardInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber* animationCurveNumber = keyboardInfo[@"UIKeyboardAnimationCurveUserInfoKey"];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         [self.view removeConstraint:_contentViewBottomConstraint];
                         _contentViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_contentTextView
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.view
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                     multiplier:1.0f constant:-keyboardEndFrame.size.height-15];
                         
                         [self.view addConstraint:_contentViewBottomConstraint];
                     }
                     completion:^(BOOL finished) {}];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSNumber* animationDurationNumber = keyboardInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber* animationCurveNumber = keyboardInfo[@"UIKeyboardAnimationCurveUserInfoKey"];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         [self.view removeConstraint:_contentViewBottomConstraint];
                         _contentViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_contentTextView
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.view
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                     multiplier:1.0f constant:-15.0f];
                         
                         [self.view addConstraint:_contentViewBottomConstraint];
                     }
                     completion:^(BOOL finished) {}];
}

#pragma mark - method
- (void) postReply {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Uploading..." delayToHide:-1];
    [_discussionModel postReplyWithBlock:_contentTextView.text user:_currentUser targetID:_discussionObject.objectID completeBlock:^() {
        [self.hud hide:YES];
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Success..." delayToHide:1];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [_contentTextView endEditing:YES];
}

- (void) popThisPage {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NoNetworkAlertDelegate
- (void) noNetworkAlertRefreshButtonPressed {
    [self postReply];
}

- (void) noNetworkAlertCancelButtonPressed {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)hasNoNetworkConnection {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can not connect to the Internet. Please check the connection. "
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [self.hud hide:YES];
                                                             self.navigationItem.rightBarButtonItem.enabled = YES;
                                                             self.navigationItem.leftBarButtonItem.enabled = YES;
                                                         }];
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.hud hide:YES];
                                                              [self postReply];
                                                          }];
    [alert addAction:cancelAction];
    [alert addAction:refreshAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - UIAlertViewDelegate
//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView == _notFinishedAlert) {
//        if (buttonIndex == 0) {
//            [_contentTextView becomeFirstResponder];
//        }
//        if (buttonIndex == 1) {
//            [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(popViewPorTimer) userInfo:nil repeats: NO];
//        }
//    }
//}

- (void) alertView:(CustomizedAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _notFinishedAlert) {
        if (buttonIndex == 0) {
            [_contentTextView becomeFirstResponder];
        }
        if (buttonIndex == 1) {
            [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(popViewPorTimer) userInfo:nil repeats: NO];
        }
    }
}


-(void) popViewPorTimer
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
