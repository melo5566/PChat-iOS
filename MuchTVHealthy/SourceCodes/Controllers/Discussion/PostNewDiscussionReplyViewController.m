//
//  PostNewDiscussionReplyViewController.m
//  FaceNews
//
//  Created by Peter on 2015/7/21.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "PostNewDiscussionReplyViewController.h"
//#import "DiscussionModel.h"

@interface PostNewDiscussionReplyViewController () <UITextViewDelegate>
//@property (nonatomic, strong) UIView                        *contentView;
@property (nonatomic, strong) UITextView                    *contentTextView;
@property (nonatomic, strong) UILabel                       *placeHolder;
//@property (nonatomic, strong) DiscussionModel               *discussionModel;
@property (nonatomic, strong) NSLayoutConstraint            *contentViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint            *contentViewHeightConstraint;
@property (nonatomic, strong) UIAlertView                   *notFinishedAlert;
@property (nonatomic) BOOL                                  isFirstLoad;
@property float                                             keyboardHeight;
@end

@implementation PostNewDiscussionReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarBackButtonAtLeft];
    [self.navigationItem setTitle:@"回覆"];
    _isFirstLoad = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNotificationObservers];
    
//    if (!_discussionModel) {
//        _discussionModel = [[DiscussionModel alloc] init];
//        _discussionModel.delegate = self;
//    }
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
    [customizedButton setTitle:@"發表" forState:UIControlStateNormal];
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
        _contentTextView.backgroundColor    = [UIColor colorWithR:255 G:255 B:255];
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
        _placeHolder.textColor          = [UIColor colorWithHexString:@"#C7C7CD"];
        _placeHolder.text               = @"留言(限制140字)...";
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
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"內容請勿空白..." delayToHide:1];
    }
}

- (void) backButtonPressed:(id) sender {
    if ([_contentTextView isFirstResponder]) {
        [_contentTextView endEditing:YES];
    }
    
    _notFinishedAlert = [[UIAlertView alloc] initWithTitle:@"注意"
                                                   message:@"尚未完成，\n您確定要離開了嗎？"
                                                  delegate:self
                                         cancelButtonTitle:@"停留"
                                         otherButtonTitles:@"離開", nil];
    [_notFinishedAlert show];
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
//    self.navigationItem.rightBarButtonItem.enabled = NO;
//    self.navigationItem.leftBarButtonItem.enabled = NO;
//    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"發表中..." delayToHide:-1];
//    [_discussionModel postNewDiscussionCommentWithDiscussionUri:_discussionObject.objectUri
//                                            DiscussionAuthorUri:_discussionObject.authorUri
//                                                        Content:_contentTextView.text
//                                              withCompleteBlock:^(){
//                                                  [self.hud hide:YES];
//                                                  [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"發表成功" delayToHide:1];
//                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kEventNewCommentHasPost object:nil];
//                                                  [self performSelector:@selector(popThisPage) withObject:nil afterDelay:1];
//                                              }];
//    [_contentTextView endEditing:YES];
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

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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
