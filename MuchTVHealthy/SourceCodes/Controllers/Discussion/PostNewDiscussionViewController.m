//
//  PostNewDiscussionViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/25.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "PostNewDiscussionViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "CustomizedAlertView.h"
#import <Parse/Parse.h>
#import "DiscussionModel.h"
#import "ChatroomModel.h"

@interface PostNewDiscussionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) NSURL                     *uri;
@property (nonatomic) BOOL                              isProgramDiscussion;
@property (nonatomic) BOOL                              isCelebrityDiscussion;
@property (nonatomic, strong) UIScrollView              *backgroundScrollView;
@property (nonatomic, strong) UIView                    *scrollContentView;
@property (nonatomic, strong) UITextField               *titleTextField;
@property (nonatomic, strong) UIView                    *titleView;
@property (nonatomic, strong) UIView                    *contentContainer;
@property (nonatomic, strong) UITextView                *contentTextView;
@property (nonatomic, strong) UILabel                   *contentPlaceHolderLabel;
@property (nonatomic, strong) UIView                    *chooseAttachmentView;
@property (nonatomic, strong) UILabel                   *chooseAttachmentTitleLabel;
@property (nonatomic, strong) UIButton                  *useCameraButton;
@property (nonatomic, strong) UIButton                  *useLibraryButton;
@property (nonatomic, strong) UIView                    *attachmentPreviewBackground;
@property (nonatomic, strong) NSLayoutConstraint        *contentTextViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint        *contentContainerBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint        *scrollViewBottomConstraint;
@property (nonatomic, strong) UIActivityIndicatorView   *activityIndicator;

@property (nonatomic, strong) NSMutableArray            *imageArray;

@property (nonatomic) BOOL                              isFirstLoad;
@property (nonatomic) BOOL                              needScrollToBottom;

@property (nonatomic, strong) CustomizedAlertView       *notFinishedAlert;
@property (nonatomic, strong) PFUser                    *currentUser;
@property (nonatomic, strong) DiscussionModel           *discussionModel;
@property (nonatomic, strong) ChatroomModel             *chatroomModel;
@end

@implementation PostNewDiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Post";
    [self initNavigationBarBackButtonAtLeft];
    [self initRightBarButton];
    _isFirstLoad = YES;
    _imageArray = [[NSMutableArray alloc] init];
    if ([PFUser currentUser])
        _currentUser = [PFUser currentUser];
}

- (id) initForProgramDiscussion {
    self = [super init];
    if (self) {
        _isProgramDiscussion = YES;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNotificationObservers];
    if (_isFirstLoad) {
        _isFirstLoad = NO;
        [self initLayout];
        [_titleTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotificationObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - inits
- (void) initRightBarButton {
    UIButton *customizedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame = CGRectMake(0, 0, 40, 17);
    [customizedButton setTitle:@"Post" forState:UIControlStateNormal];
    [customizedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(rightBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
}

- (void) initLayout {
    [self initBackgroundScrollView];
    [self initScrollContentView];
    [self initTitleView];
    [self initContentContainer];
}

- (void) initBackgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initForAutolayout];
        _backgroundScrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backgroundScrollView];
        NSMutableArray *scrollViewConstaint = @[].mutableCopy;
        [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:0.0f]];
        [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:0.0f]];
        [scrollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:0.0f]];
        _scrollViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:0.0f];
        [self.view addConstraints:scrollViewConstaint];
        [self.view addConstraint:_scrollViewBottomConstraint];
    }
}

- (void) initScrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] initForAutolayout];
        _scrollContentView.backgroundColor = [UIColor clearColor];
        [_backgroundScrollView addSubview:_scrollContentView];
        NSMutableArray *contentViewConstaint = @[].mutableCopy;
        [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_scrollContentView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_backgroundScrollView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:0.0f]];
        [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_scrollContentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_backgroundScrollView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_scrollContentView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_backgroundScrollView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        [contentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_scrollContentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_backgroundScrollView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_scrollContentView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:1.0f constant:0.0f];
        [contentViewConstaint addObject:widthConstraint];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_scrollContentView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                               toItem:_backgroundScrollView
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:1.0f constant:0.0f];
        [contentViewConstaint addObject:heightConstraint];
        [self.view addConstraints:contentViewConstaint];
        [self.view layoutIfNeeded];
        
        [_backgroundScrollView setContentSize:CGSizeMake(CGRectGetWidth(_scrollContentView.frame), CGRectGetHeight(_scrollContentView.frame))];
    }
}

- (void) initTitleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initForAutolayout];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.layer.borderWidth = 1.0f;
        _titleView.layer.borderColor = [UIColor colorWithHexString:kPostDiscussionViewBorderColorHexString].CGColor;
        [_scrollContentView addSubview:_titleView];
        NSMutableArray *titleViewConstaint = @[].mutableCopy;
        [titleViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_titleView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_scrollContentView
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0f constant:15.0f]];
        [titleViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_titleView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_scrollContentView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f constant:15.0f]];
        [titleViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_titleView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_scrollContentView
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f constant:-15.0f]];
        [titleViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_titleView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:40.0f]];
        
        // titleTextField
        _titleTextField = [[UITextField alloc] initForAutolayout];
        _titleTextField.backgroundColor = [UIColor clearColor];
        _titleTextField.borderStyle = UITextBorderStyleNone;
        _titleTextField.font = [UIFont systemFontOfSize:14.0f];
        _titleTextField.placeholder = @"Please enter the title(max 20)...";
        _titleTextField.delegate = self;
        [_titleTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
        [_titleView addSubview:_titleTextField];
        [titleViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_titleTextField
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_titleView
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0f constant:10.0f]];
        [titleViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_titleTextField
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_titleView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f constant:0.0f]];
        [titleViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_titleTextField
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_titleView
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f constant:-10.0f]];
        [titleViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_titleTextField
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:titleViewConstaint];
    }
}

- (void) initChooseAttachmentView {
    if (!_chooseAttachmentView) {
        _chooseAttachmentView = [[UIView alloc] initForAutolayout];
        _chooseAttachmentView.backgroundColor = [UIColor colorWithHexString:kPostDiscussionAttachmentViewBackgroundColorHexString];
        [_contentContainer addSubview:_chooseAttachmentView];
        NSMutableArray *attachmentViewConstaint = @[].mutableCopy;
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_contentContainer
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:0.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_contentContainer
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:0.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:45.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_contentContainer
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0.0f]];
        
        // titleLabel
        _chooseAttachmentTitleLabel = [[UILabel alloc] initForAutolayout];
        _chooseAttachmentTitleLabel.backgroundColor = [UIColor clearColor];
        _chooseAttachmentTitleLabel.font = [UIFont systemFontOfSize:18.0f];
        _chooseAttachmentTitleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _chooseAttachmentTitleLabel.text = @"Attachment";
        [_chooseAttachmentView addSubview:_chooseAttachmentTitleLabel];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_chooseAttachmentTitleLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:9.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_chooseAttachmentTitleLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0f constant:0.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_chooseAttachmentTitleLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:120.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_chooseAttachmentTitleLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:21.0f]];
        
        // Buttons
        _useLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useLibraryButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _useLibraryButton.backgroundColor = [UIColor clearColor];
        [_useLibraryButton setImage:[UIImage imageNamed:@"icon_fnphoto"] forState:UIControlStateNormal];
        [_useLibraryButton addTarget:self action:@selector(useLibraryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseAttachmentView addSubview:_useLibraryButton];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_useLibraryButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-15.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_useLibraryButton
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0f constant:0.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_useLibraryButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:30.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_useLibraryButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:30.0f]];
        
        _useCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useCameraButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _useCameraButton.backgroundColor = [UIColor clearColor];
        [_useCameraButton setImage:[UIImage imageNamed:@"icon_fncamera"] forState:UIControlStateNormal];
        [_useCameraButton addTarget:self action:@selector(useCameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseAttachmentView addSubview:_useCameraButton];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_useCameraButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_useLibraryButton
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:-15.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_useCameraButton
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0f constant:0.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_useCameraButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:30.0f]];
        [attachmentViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_useCameraButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:30.0f]];
        
        
        
        
        [self.view addConstraints:attachmentViewConstaint];
    }
}

- (void) initContentContainer {
    if (!_contentContainer) {
        _contentContainer = [[UIView alloc] initForAutolayout];
        _contentContainer.backgroundColor = [UIColor whiteColor];
        _contentContainer.layer.borderWidth = 1.0f;
        _contentContainer.layer.borderColor = [UIColor colorWithHexString:kPostDiscussionViewBorderColorHexString].CGColor;
        [_scrollContentView addSubview:_contentContainer];
        NSMutableArray *contentContainerConstaint = @[].mutableCopy;
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentContainer
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_scrollContentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:15.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_titleView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:15.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentContainer
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_scrollContentView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-15.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentContainer
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_scrollContentView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:-5.0f]];
        
        // Attachment View
        [self initChooseAttachmentView];
        
        // Content TextView
        _contentTextView = [[UITextView alloc] initForAutolayout];
        _contentTextView.delegate = self;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.font = [UIFont systemFontOfSize:14.0f];
        _contentTextView.scrollEnabled = NO;
        [_contentContainer addSubview:_contentTextView];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentContainer
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:5.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:0.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentContainer
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-5.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:30.0f]];
        _contentTextViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_contentTextView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:0.0f];
        
        // placeholder
        _contentPlaceHolderLabel = [[UILabel alloc] initForAutolayout];
        _contentPlaceHolderLabel.backgroundColor = [UIColor clearColor];
        _contentPlaceHolderLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentPlaceHolderLabel.textColor = [UIColor colorWithHexString:@"#C7C7CD"];
        _contentPlaceHolderLabel.text = @"What are you thinking(max 140)...";
        [_contentContainer addSubview:_contentPlaceHolderLabel];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentPlaceHolderLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentContainer
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:9.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentPlaceHolderLabel
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:7.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentPlaceHolderLabel
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_contentContainer
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-9.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_contentPlaceHolderLabel
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:21.0f]];
        
        
        [self.view addConstraints:contentContainerConstaint];
        [self.view addConstraint:_contentTextViewBottomConstraint];
    }
}

- (void) initAttachmentPreview {
    if (!_attachmentPreviewBackground) {
        _attachmentPreviewBackground = [[UIView alloc] initForAutolayout];
        _attachmentPreviewBackground.backgroundColor = [UIColor clearColor];
        [_contentContainer addSubview:_attachmentPreviewBackground];
        NSMutableArray *attachmentPreviewConstaint = @[].mutableCopy;
        [attachmentPreviewConstaint addObject:[NSLayoutConstraint constraintWithItem:_attachmentPreviewBackground
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_contentContainer
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0f constant:10.0f]];
        [attachmentPreviewConstaint addObject:[NSLayoutConstraint constraintWithItem:_attachmentPreviewBackground
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_chooseAttachmentView
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0f constant:-10.0f]];
        [attachmentPreviewConstaint addObject:[NSLayoutConstraint constraintWithItem:_attachmentPreviewBackground
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_contentContainer
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0f constant:-10.0f]];
        [attachmentPreviewConstaint addObject:[NSLayoutConstraint constraintWithItem:_attachmentPreviewBackground
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0f constant:50.0f]];
        [self.view addConstraints:attachmentPreviewConstaint];
    }
    
    for (UIView *subview in _attachmentPreviewBackground.subviews) {
        [subview removeFromSuperview];
    }
    
    NSUInteger index = 0;
    for (NSMutableDictionary *imageData in _imageArray) {
        UIImageView *attachmentImageView = [[UIImageView alloc] initForAutolayout];
        attachmentImageView.backgroundColor = [UIColor clearColor];
        attachmentImageView.layer.borderWidth = 0.5f;
        attachmentImageView.layer.borderColor = [UIColor colorWithHexString:kListTableViewImageBorderColorHexString].CGColor;
        attachmentImageView.contentMode = UIViewContentModeScaleAspectFill;
        attachmentImageView.clipsToBounds = YES;
        [_attachmentPreviewBackground addSubview:attachmentImageView];
        NSMutableArray *imageConstaint = @[].mutableCopy;
        [imageConstaint addObject:[NSLayoutConstraint constraintWithItem:attachmentImageView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_attachmentPreviewBackground
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0f constant:index * (45 + 15)]];
        [imageConstaint addObject:[NSLayoutConstraint constraintWithItem:attachmentImageView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_attachmentPreviewBackground
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0f constant:0.0f]];
        [imageConstaint addObject:[NSLayoutConstraint constraintWithItem:attachmentImageView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f constant:45.0f]];
        [imageConstaint addObject:[NSLayoutConstraint constraintWithItem:attachmentImageView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f constant:45.0f]];
        [self.view addConstraints:imageConstaint];
        
        [attachmentImageView setImage:[imageData objectForKey:@"image"]];
        
        if ([[imageData objectForKey:@"imageUrl"] isNotEmpty]) {
            [attachmentImageView setImage:[imageData objectForKey:@"image"]];
        } else {
            [attachmentImageView addActivityIndicatorWithActivityStyle:UIActivityIndicatorViewStyleGray];
            UIImageView *alphaImageView = [[UIImageView alloc] initForAutolayout];
            alphaImageView.backgroundColor = [UIColor clearColor];
            alphaImageView.contentMode = UIViewContentModeScaleAspectFill;
            alphaImageView.clipsToBounds = YES;
            alphaImageView.alpha = 0.3;
            [attachmentImageView insertSubview:alphaImageView atIndex:0];
            NSMutableArray *alphaImageViewConstaint = @[].mutableCopy;
            [alphaImageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:alphaImageView
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:attachmentImageView
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0f constant:0.0f]];
            [alphaImageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:alphaImageView
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:attachmentImageView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f constant:0.0f]];
            [alphaImageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:alphaImageView
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:attachmentImageView
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:0.0f]];
            [alphaImageViewConstaint addObject:[NSLayoutConstraint constraintWithItem:alphaImageView
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:attachmentImageView
                                                                            attribute:NSLayoutAttributeTop
                                                                           multiplier:1.0f constant:0.0f]];
            [self.view addConstraints:alphaImageViewConstaint];
            [alphaImageView setImage:imageData[@"image"]];
        }

        // delete button
        UIButton *deleteImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteImageButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        deleteImageButton.tag = index;
        deleteImageButton.backgroundColor = [UIColor clearColor];
        [deleteImageButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [deleteImageButton addTarget:self action:@selector(deleteImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_attachmentPreviewBackground addSubview:deleteImageButton];
        NSMutableArray *buttonConstaint = @[].mutableCopy;
        [buttonConstaint addObject:[NSLayoutConstraint constraintWithItem:deleteImageButton
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:attachmentImageView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0f constant:10.0f]];
        [buttonConstaint addObject:[NSLayoutConstraint constraintWithItem:deleteImageButton
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:attachmentImageView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f constant:-10.0f]];
        [buttonConstaint addObject:[NSLayoutConstraint constraintWithItem:deleteImageButton
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f constant:25.0f]];
        [buttonConstaint addObject:[NSLayoutConstraint constraintWithItem:deleteImageButton
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f constant:25.0f]];
        [self.view addConstraints:buttonConstaint];
        
        
        index++;
    }
}

#pragma mark - notifications
- (void) initNotificationObservers
{
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

- (void) removeNotificationObservers
{
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
                         [self.view removeConstraint:_scrollViewBottomConstraint];
                         _scrollViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1.0f constant:-keyboardEndFrame.size.height];
                         [self.view addConstraint:_scrollViewBottomConstraint];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void) keyboardWillHide:(NSNotification *) notification
{
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
                         [self.view removeConstraint:_scrollViewBottomConstraint];
                         _scrollViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_backgroundScrollView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1.0f constant:0.0f];
                         [self.view addConstraint:_scrollViewBottomConstraint];
                     }
                     completion:^(BOOL finished) {}];
}

#pragma mark - button actions
- (void) rightBarButtonPressed:(id)sender {
    if ([_titleTextField.text isNotEmpty] && [_contentTextView.text isNotEmpty]) {
        [self postNewDiscussion];
    }
    else if ([_titleTextField.text isEmpty] && [_contentTextView.text isNotEmpty]) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter the title..." delayToHide:1];
    }
    else if ([_titleTextField.text isNotEmpty] && [_contentTextView.text isEmpty]) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter the content..." delayToHide:1];
    }
    else if ([_titleTextField.text isEmpty] && [_contentTextView.text isEmpty]) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Please enter the title and content..." delayToHide:1];
    }
}

- (void) backButtonPressed:(id) sender {
    if ([_titleTextField isFirstResponder]) {
        [_titleTextField endEditing:YES];
    }
    if ([_contentTextView isFirstResponder]) {
        [_contentTextView endEditing:YES];
    }
    
    _notFinishedAlert = [[CustomizedAlertView alloc] initWithTitle:@"Warning" andMessage:@"Not done yet，\n Are you sure？"];
    [_notFinishedAlert addButtonWithTitle:@"Stay"
                                     type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                  handler:nil];
    
    [_notFinishedAlert addButtonWithTitle:@"Exit"
                                     type:CustomizedAlertViewButtonTypeDefaultGreen
                                  handler:^(CustomizedAlertView *alertView) {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }];
    
    [_notFinishedAlert show];
    
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意"
    //                                                                   message:@"尚未完成，\n您確定要離開了嗎？"
    //                                                            preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *stayAction = [UIAlertAction actionWithTitle:@"停留"
    //                                                         style:UIAlertActionStyleCancel
    //                                                       handler:^(UIAlertAction * action) {
    //                                                           [alert dismissViewControllerAnimated:YES completion:nil];
    //                                                       }];
    //    UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:@"離開"
    //                                                          style:UIAlertActionStyleDefault
    //                                                        handler:^(UIAlertAction * action) {
    //                                                            [self.navigationController popViewControllerAnimated:YES];
    //                                                        }];
    //    [alert addAction:stayAction];
    //    [alert addAction:leaveAction];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
}

- (void) deleteImageButtonPressed:(id)sender {
    UIButton *deleteButton = sender;
    
    NSString *imageUri = [_imageArray objectAtIndex:deleteButton.tag][@"uri"];
    if ([imageUri isNotEmpty]) {
        // remove image from server
        //        [self removeImageFromServerByUri:imageUri];
    }
    
    [_imageArray removeObjectAtIndex:deleteButton.tag];
    if ([_imageArray isEmpty]) {
        [self.view removeConstraint:_contentTextViewBottomConstraint];
        _contentTextViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_contentTextView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_chooseAttachmentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:0.0f];
        [self.view addConstraint:_contentTextViewBottomConstraint];
        
        [_attachmentPreviewBackground removeFromSuperview];
        _attachmentPreviewBackground = nil;
        
    }
    else {
        [self initAttachmentPreview];
    }
}

- (void)useCameraButtonPressed:(id)sender {
    if (_imageArray.count == 5) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"At most 5 pictures..." delayToHide:1];
    }
    else {
        [self useCamera];
    }
}

- (void)useLibraryButtonPressed:(id)sender {
    if (_imageArray.count == 5) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"At most 5 pictures..." delayToHide:1];
    }
    else {
        [self usePhotoLibrary];
    }
}


#pragma mark - methods
- (void) uploadImage:(UIImage *)image {
    if (!_chatroomModel) {
        _chatroomModel = [[ChatroomModel alloc] init];
    }
    NSData *imageFile = UIImageJPEGRepresentation([image scaledWithMaxLength:1000], 0.6);
    [_chatroomModel uploadImageWithBlock:imageFile completeBlock:^(NSString *imageUrl) {
        BOOL imageIsSteelThere = NO;
        for (NSMutableDictionary *imageData in _imageArray) {
            if (imageData[@"image"] == image) {
                imageIsSteelThere = YES;
                [imageData setObject:imageUrl forKey:@"imageUrl"];
            }
        }
        if (imageIsSteelThere) {
            NSLog(@"Image Is Steel There, refresh image!");
            [self initAttachmentPreview];
        } else {
            NSLog(@"Image Is Not There... Do nothing...");
        }
    }];
}

//- (void) removeImageFromServerByUri:(NSString *)uri {
//    if (!_discussionModel) {
//        _discussionModel = [[DiscussionModel alloc] init];
//        _discussionModel.delegate = self;
//    }
//    [_discussionModel deleteImageFromServerByUri:uri];
//}

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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera is not authorized"
                                                            message:@"Camera is not authorized. Please authorize it"
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
        //        if (self.appdelegate.isVoteActivitiesInProgress) {
        //            [self.appdelegate.voteView setHidden:YES];
        //        }
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        //        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can not use camera"
                                                            message:@"Sorry, you don't have camera."
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (void) usePhotoLibrary {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    //    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    //    if (self.appdelegate.isVoteActivitiesInProgress) {
    //        [self.appdelegate.voteView setHidden:YES];
    //    }
}

#pragma mark - image picker delegate
- (void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    UIImage *croppedImage = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^(){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
    if (croppedImage) {
        NSMutableDictionary *imageData = @{@"image":croppedImage,@"imageUrl":@""}.mutableCopy;
        [_imageArray addObject:imageData];
        [self initAttachmentPreview];
        
        [self.view removeConstraint:_contentTextViewBottomConstraint];
        _contentTextViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_contentTextView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_attachmentPreviewBackground
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:-5.0f];
        [self.view addConstraint:_contentTextViewBottomConstraint];
        
        dispatch_async(dispatch_get_main_queue(),^{
            CGPoint bottomOffset = CGPointMake(0, _backgroundScrollView.contentSize.height - _backgroundScrollView.bounds.size.height);
            [_backgroundScrollView setContentOffset:bottomOffset animated:YES];
        });
        
        [self uploadImage:croppedImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    if (self.appdelegate.isVoteActivitiesInProgress) {
    //        [self.appdelegate.voteView setHidden:NO];
    //    }
    [picker dismissViewControllerAnimated:YES completion:^(){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _titleTextField && isNullValue([textField markedTextRange])) {
        
        if (textField.text.length - range.length + string.length  > kDiscussionTitleTextLimitLength) {
            return NO;
        }
        else {
            return YES;
        }
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == _titleTextField) {
        [_contentTextView becomeFirstResponder];
    }
    
    return NO;
}

- (void) textFieldDidChange:(id)sender {
    UITextField *textField = sender;
    if (textField == _titleTextField && isNullValue([textField markedTextRange])) {
        if (textField.text.length > kDiscussionTitleTextLimitLength) {
            NSRange oversteppedRange = NSMakeRange(kDiscussionTitleTextLimitLength, textField.text.length - kDiscussionTitleTextLimitLength);
            textField.text = [textField.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
    }
}

#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _contentTextView && isNullValue([textView markedTextRange])) {
        if (textView.text.length - range.length + text.length  > kDiscussionContentTextLimitLength) {
            return NO;
        }
        else {
            if (range.location == textView.text.length) {
                _needScrollToBottom = YES;
            }
            return YES;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _contentTextView && isNullValue([textView markedTextRange])) {
        if (textView.text.length > 0) {
            _contentPlaceHolderLabel.hidden = YES;
        }
        else {
            _contentPlaceHolderLabel.hidden = NO;
        }
        
        if (textView.text.length > kDiscussionContentTextLimitLength) {
            NSRange oversteppedRange = NSMakeRange(kDiscussionContentTextLimitLength, textView.text.length - kDiscussionContentTextLimitLength);
            textView.text = [textView.text stringByReplacingCharactersInRange:oversteppedRange withString:@""];
        }
    }
    dispatch_async(dispatch_get_main_queue(),^{
        [textView sizeThatFits:CGSizeMake(kScreenWidth - 30, 0)];
        [self.view layoutIfNeeded];
        if (_needScrollToBottom) {
            _needScrollToBottom = NO;
            CGPoint bottomOffset = CGPointMake(0, _backgroundScrollView.contentSize.height - _backgroundScrollView.bounds.size.height);
            [_backgroundScrollView setContentOffset:bottomOffset animated:YES];
        }
        
    });
    
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    dispatch_async(dispatch_get_main_queue(),^{
        CGPoint bottomOffset = CGPointMake(0, _backgroundScrollView.contentSize.height - _backgroundScrollView.bounds.size.height);
        [_backgroundScrollView setContentOffset:bottomOffset animated:YES];
    });
}

#pragma mark - petitionModel method & delegate
- (void) postNewDiscussion {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Posting..." delayToHide:-1];
    NSMutableArray *imageArray = @[].mutableCopy;
    for (NSDictionary *imageData in _imageArray) {
        [imageArray addObject:imageData[@"imageUrl"]];
    }
    if (!_discussionModel) {
        _discussionModel = [[DiscussionModel alloc] init];
        _discussionModel.delegate = self;
    }
    [_discussionModel postNewDiscussionWithBlock:_category
                                     currentUser:_currentUser
                                           title:_titleTextField.text
                                         content:_contentTextView.text
                                      imageArray:imageArray completeBlock:^() {
                                          [self.hud hide:YES];
                                          [self.navigationController popViewControllerAnimated:YES];
    }];
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
                                                         }];
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.hud hide:YES];
                                                              [self postNewDiscussion];
                                                          }];
    [alert addAction:cancelAction];
    [alert addAction:refreshAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void) noNetworkAlertRefreshButtonPressed {
    [self postNewDiscussion];
}

- (void) noNetworkAlertCancelButtonPressed {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

@end
