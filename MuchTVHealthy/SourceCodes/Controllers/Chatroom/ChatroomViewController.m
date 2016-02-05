//
//  ChatroomViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/10/31.
//  Copyright (c) 2015年  All rights reserved.


#import "ChatroomViewController.h"
#import "ChatroomSpeakerView.h"
#import "ChatroomTableViewCell.h"
#import "MessageObject.h"
#import "PhotoViewerViewController.h"
#import "ChatroomStickerView.h"
#import "CustomizedAlertView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Parse/Parse.h>
#import "ChatroomModel.h"
#import "PersonalSettingViewController.h"
#import "UserModel.h"
#import <MapKit/MapKit.h>


#define kSelfSentContentMaxWidth            kScreenWidth - 3 * kChatroomContentPadding - kChatroomBubbleTriangleGapPadding - kChatroomTimeLabelMinimumWidth - 2 * kGlobalDefaultPadding

@interface ChatroomViewController () <UITableViewDataSource, UITableViewDelegate, ChatroomSpeakerViewDelegate, chatroomTableViewCellDelegate, ChatroomStickerViewDelegate, OrtcClientDelegate, MKMapViewDelegate>
@property (nonatomic, strong) UITableView               *chatroomTableView;
@property (nonatomic, strong) ChatroomSpeakerView       *speakerView;
@property (nonatomic, strong) NSLayoutConstraint        *speakerViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint        *speakerViewHeightConstraint;
@property (nonatomic) CGFloat                           speakerViewHeight;
@property (nonatomic, strong) MessageObject             *messageObject;
@property (nonatomic, strong) NSMutableArray            *messageObjectArray;
@property (nonatomic, strong) ChatroomStickerView       *stickerView;
@property (nonatomic, strong) CustomizedAlertView       *alertView;
@property (nonatomic, strong) TableRef                  *tableRef;
@property (nonatomic, strong) StorageRef                *storageRef;
@property (nonatomic, strong) NSString                  *message;
@property (nonatomic, strong) PFUser                    *currentLoginUser;
@property (nonatomic, strong) ChatroomModel             *chatroomModel;
@property (nonatomic) BOOL                              isLoadingPicture;
@property (nonatomic, strong) CustomizedAlertView       *loginAlertView;
@property (nonatomic, strong) MKMapView                 *mapView;
@property (nonatomic, strong) NSLayoutConstraint        *mapViewBottomConstraint;
@property (nonatomic) BOOL                              showMapView;
@property (nonatomic, strong) UIButton                  *mapViewButton;
@end

@implementation ChatroomViewController

- (void)setChatroomObject:(ChatroomListObject *)chatroomObject {
    _chatroomObject = chatroomObject;
    [self initMapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _chatroomObject.chatroomName;
    [self initNavigationBarBackButtonAtLeft];
    _messageObjectArray = @[].mutableCopy;
    if ([PFUser currentUser])
        _currentLoginUser = [PFUser currentUser];
    [self setUpChatroomConnection];
    _isLoadingPicture = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userStatusChanged:)
                                                 name:kEventUserStatusChanged
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_chatroomModel) {
        _chatroomModel = [[ChatroomModel alloc] init];
    }
    [self initNotificationObservers];
    if (!_isLoadingPicture) {
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Loading..." delayToHide:-1];
    }
    _isLoadingPicture = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotificationObservers];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kEventUserStatusChanged
                                                  object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notifications
- (void) userStatusChanged:(NSNotification *) notification {
    if ([notification.object isEqualToString:@"LOGGED_IN"]) {
        _currentLoginUser = [PFUser currentUser];
        [_speakerView removeLoginButton];
        [_chatroomTableView reloadData];
    }
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

- (void) keyboardWillShow:(NSNotification *) notification {
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
                         // move speaker view
                         [self.view removeConstraint:_speakerViewBottomConstraint];
                         _speakerViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_speakerView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0f constant:-keyboardEndFrame.size.height];
                         [self.view addConstraint:_speakerViewBottomConstraint];
                         [self.view layoutIfNeeded];
                         
                         
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void) keyboardWillHide:(NSNotification *) notification {
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
                         [self.view removeConstraint:_speakerViewBottomConstraint];
                         _speakerViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_speakerView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.0f constant:0.0f];
                         [self.view addConstraint:_speakerViewBottomConstraint];
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}


#pragma mark - inits
- (void) initChatroomTableView {
    if (!_chatroomTableView) {
        _chatroomTableView                    = [[UITableView alloc] initForAutolayout];
        _chatroomTableView.delegate           = self;
        _chatroomTableView.dataSource         = self;
        _chatroomTableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
        _chatroomTableView.clipsToBounds      = YES;
        [_chatroomTableView setLayoutMargins:UIEdgeInsetsZero];
        [self.view addSubview:_chatroomTableView];
        
        NSMutableArray *chatroomTableViewConstraint = [[NSMutableArray alloc] init];
        
        [chatroomTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_chatroomTableView
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0f constant:0.0f]];
        [chatroomTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_chatroomTableView
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_mapView
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0f constant:0.0f]];
        [chatroomTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_chatroomTableView
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0f constant:0.0f]];
        [chatroomTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_chatroomTableView
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_speakerView
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0f constant:0.0f]];
        
        
        [self.view addConstraints:chatroomTableViewConstraint];
        [self.view layoutIfNeeded];
        
    }
    [_chatroomTableView reloadData];
}


- (void) initSpeakerView {
    if (!_speakerView) {
        _speakerView = [[ChatroomSpeakerView alloc] initForAutolayout];
        _speakerView.delegate = self;
        [self.view addSubview:_speakerView];
        
        NSMutableArray *speakerViewConstaint = @[].mutableCopy;
        
        [speakerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [speakerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_speakerView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        _speakerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_speakerView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:51.0f];
        _speakerViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_speakerView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0f constant:0.0f];

        [self.view addConstraints:speakerViewConstaint];
        [self.view addConstraint:_speakerViewBottomConstraint];
        [self.view addConstraint:_speakerViewHeightConstraint];
    }

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    circleRenderer.fillColor = [UIColor greenColor];
    circleRenderer.alpha = 0.5f;
    return circleRenderer;
}

- (MKCoordinateRegion )getRegion {
    double miles = (float)_chatroomObject.distance/1600;
    double scalingFactor = ABS( (cos(2 * M_PI * _chatroomObject.geoPoint.latitude / 360.0) ));
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = CLLocationCoordinate2DMake(_chatroomObject.geoPoint.latitude, _chatroomObject.geoPoint.longitude);
    return region;
}

- (void) initMapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initForAutolayout];
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
        [newAnnotation setCoordinate:CLLocationCoordinate2DMake(_chatroomObject.geoPoint.latitude, _chatroomObject.geoPoint.longitude)];
        newAnnotation.title = _chatroomObject.chatroomName;
        [_mapView setRegion:[self getRegion] animated:YES];
        [_mapView addAnnotation:newAnnotation];
        [self.view addSubview:_mapView];
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(_chatroomObject.geoPoint.latitude, _chatroomObject.geoPoint.longitude) radius:_chatroomObject.distance];
        [_mapView addOverlay:circle];
        
        NSMutableArray *mapViewConstraint = [[NSMutableArray alloc] init];
        
        [mapViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_mapView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f constant:0.0f]];
        [mapViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_mapView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f constant:0.0f]];
        [mapViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_mapView
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0f constant:0.0f]];
        _mapViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_mapView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f constant:self.view.bounds.size.height/3];
        
        [self.view addConstraints:mapViewConstraint];
        [self.view addConstraint:_mapViewBottomConstraint];
        _showMapView = YES;
    }
    [self initMapBarButton];
}

- (void)initMapBarButton {
    _mapViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mapViewButton.backgroundColor = [UIColor clearColor];
    _mapViewButton.frame = CGRectMake(10, 0, 50, 17);
    [_mapViewButton setTitle:@"Hide" forState:UIControlStateNormal];
    _mapViewButton.lineBreakMode = NSLineBreakByTruncatingTail;
    [_mapViewButton setTitleColor:[UIColor colorWithR:255 G:255 B:255] forState:UIControlStateNormal];
    [_mapViewButton addTarget:self action:@selector(mapBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_mapViewButton];
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
}

- (void)mapBarButtonClicked:(id)sender {
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view removeConstraint:_mapViewBottomConstraint];
                         _mapViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_mapView
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeTop
                                                                                multiplier:1.0f constant:_showMapView ? 0.0f:self.view.bounds.size.height/3];
                         
                         [self.view addConstraint:_mapViewBottomConstraint];
                         [self.view layoutIfNeeded];
                         _showMapView = _showMapView ? NO:YES;
                         [_mapViewButton setTitle:_showMapView ? @"Hide":@"Open" forState:UIControlStateNormal];
                     }];
    
}



#pragma mark - UITableView data source and delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _messageObjectArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageObject *messageObject = _messageObjectArray[indexPath.row];
    if (messageObject.messageType == 1 || messageObject.messageType == 2) {
        if (messageObject.userId != _currentLoginUser.objectId) {
            return 150;
        } else {
            return 120;
        }
    } else {
        if (![messageObject.userId isEqualToString:_currentLoginUser.objectId]) {
            return [self calculateCellHeght:messageObject.content] + 30;
        } else {
            return [self calculateCellHeght:messageObject.content] + 5;
        }
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ChatroomTableViewCell";
    ChatroomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[ChatroomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MessageObject *messageObject = _messageObjectArray[indexPath.row];
    cell.delegate = self;
    cell.messageObject = messageObject;
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (void) viewPhoto:(MessageObject *)messageObject type:(NSString *)type {
    PhotoViewerViewController *controller = [PhotoViewerViewController new];
    controller.messageObject = messageObject;
    controller.type = type;
    _isLoadingPicture = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Layout methods
- (void) scrollChatroomTableViewToBottomAnimated:(BOOL) animate{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_messageObjectArray count] - 1 inSection:0];
    [_chatroomTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animate];
}

- (CGFloat) calculateCellHeght:(NSString *)content {
    return [self bubbleHeightWithChatroomMessageObject:content] + 15;
}

- (CGFloat) bubbleHeightWithChatroomMessageObject:(NSString *) content {
    CGFloat contentLabelHeight = [content sizeOfStringWithSystemFontSize:kChatroomContentFontSize andMaxLength:kSelfSentContentMaxWidth].height;
    return kChatroomContentPadding + contentLabelHeight + kChatroomContentPadding;
}

#pragma mark - ChatroomSpeakerViewDelegate
- (void)askToLogin {
    _loginAlertView = [[CustomizedAlertView alloc] initWithTitle:@"Warning" andMessage:@"Please login first..."];
    [_loginAlertView addButtonWithTitle:@"No Thanks"
                                   type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                handler:^(CustomizedAlertView *alertView) {
                                }];
    
    [_loginAlertView addButtonWithTitle:@"Login"
                                   type:CustomizedAlertViewButtonTypeDefaultGreen
                                handler:^(CustomizedAlertView *alertView) {
                                    PersonalSettingViewController *controller = [[PersonalSettingViewController alloc] init];
                                    _isLoadingPicture = YES;
                                    [self.navigationController pushViewController:controller animated:YES];
                                }];
    [_loginAlertView show];

}

- (void) increaseSpeakerViewHeight {
    if (_speakerViewHeightConstraint.constant == 51) {
        _speakerViewHeightConstraint.constant = 70;
        _speakerViewHeight = _speakerViewHeightConstraint.constant;
        [self.view layoutIfNeeded];
    }
}

- (void) decreaseSpeakerViewHeight {
    if (_speakerViewHeightConstraint.constant == 70) {
        _speakerViewHeightConstraint.constant = 51;
        _speakerViewHeight = _speakerViewHeightConstraint.constant;
        [self.view layoutIfNeeded];
    }
}

- (void) submitMessage:(NSString *)message {
    MessageObject *messageObject = [[MessageObject alloc] initWithCurrentUser:_currentLoginUser
                                                                      Content:message
                                                                  MessageType:0];
    messageObject.contentIndexPath = _messageObjectArray.count;
    [_messageObjectArray addObject:messageObject];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_chatroomTableView reloadData];
        [self scrollChatroomTableViewToBottomAnimated:YES];
    });
    [self pushMessageToTableRef:messageObject];
}


- (void) openStickerView {
    [_speakerView endEditing:YES];
    
    if (!_stickerView) {
        _stickerView = [[ChatroomStickerView alloc] initForAutolayout];
        _stickerView.delegate = self;
        [self.view insertSubview:_stickerView aboveSubview:_chatroomTableView];
        NSMutableArray *stickerViewConstaint = @[].mutableCopy;
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute: NSLayoutAttributeCenterY
                                                                    multiplier:1.0f constant:0.0f]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_speakerView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:0.0f]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0]];
        [stickerViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_stickerView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0]];
        [self.view addConstraints:stickerViewConstaint];
    }
}

- (void) closeStickerView {
    if (_stickerView) {
        [_stickerView removeFromSuperview];
        _stickerView = nil;
        _speakerView.attachmentButton.tag = 0;
    }
}

- (void)sendStickerWithImageName:(NSString *)stickerImageName {
    MessageObject *messageObject = [[MessageObject alloc] initWithCurrentUser:_currentLoginUser
                                                                      Content:stickerImageName
                                                                  MessageType:1];
    messageObject.contentIndexPath = _messageObjectArray.count;
    [_messageObjectArray addObject:messageObject];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_chatroomTableView reloadData];
        [self scrollChatroomTableViewToBottomAnimated:YES];
    });
    [self closeStickerView];
    [self pushMessageToTableRef:messageObject];
}

- (void) showAddAlertView {
    [_speakerView endEditing:YES];
    _alertView = [[CustomizedAlertView alloc] initWithTitle:@"Add" andMessage:@"Add picture"];
    [_alertView addButtonWithTitle:@"Camera"
                              type:CustomizedAlertViewButtonTypeDefaultGreen
                           handler:^(CustomizedAlertView *alertView) {
                               [self useCamera];
                           }];
    
    [_alertView addButtonWithTitle:@"Library"
                                     type:CustomizedAlertViewButtonTypeDefaultGreen
                                  handler:^(CustomizedAlertView *alertView) {
                                      [self usePhotoLibrary];
                                  }];
    
    [_alertView show];

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
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera is not authorized"
                                                            message:@"Camera is not authorized.Please authorize it"
                                                           delegate:nil
                                                  cancelButtonTitle:@"YES"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        [self openCamera];
    }
}

- (void) openCamera {
    // check if camera is available
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can not use camera"
                                                            message:@"Sorry, you don't have camera"
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
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - image picker delegate
- (void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
    UIImage *croppedImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (croppedImage) {
        [self addPicture:croppedImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

- (void) addPicture:(UIImage *) image {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Uploading..." delayToHide:-1];
    _isLoadingPicture = YES;
    NSData *imageData = UIImageJPEGRepresentation([image scaledWithMaxLength:1000], 0.6);
    [_chatroomModel uploadImageWithBlock:imageData completeBlock:^(NSString *imageUrl) {
        MessageObject *messageObject = [[MessageObject alloc] initWithCurrentUser:_currentLoginUser Content:imageUrl MessageType:2];
        messageObject.contentIndexPath = _messageObjectArray.count;
        [_messageObjectArray addObject:messageObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hide:YES];
            [_chatroomTableView reloadData];
            [self scrollChatroomTableViewToBottomAnimated:YES];
        });
        [self pushMessageToTableRef:messageObject];
    }];
}


#pragma mark - ChatroomModel method
- (void) didcheckChatroomReachability:(BOOL)reachable {
    if (reachable) {
        [self setUpChatroomConnection];
    } else {
        [self.hud hide:YES];
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"此聊天室目前已關閉" delayToHide:1];
    }
}


#pragma mark - Message methods
// Connect to chatroom
- (void) setUpChatroomConnection {
    // Instantiate Messaging Client
    ortcClient = [OrtcClient ortcClientWithConfig:self];
    
    // Set connection properties
    [ortcClient setConnectionMetadata:@"clientConnMeta"];
    [ortcClient setClusterUrl:@"http://ortc-developers.realtime.co/server/2.1/"];
    
    // Connect
    [ortcClient connect:@"6YHPJX"
    authenticationToken:@"my_authentication_token"];
}

- (NSDictionary *) jsonStringToDictionary:(NSString *)jsonString {
    NSData *strData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    return [NSJSONSerialization JSONObjectWithData:strData options:0 error:&error];
}



- (void) pushMessageToTableRef:(MessageObject *)messageObject {
    double timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    NSDictionary *messageDic = @{@"content":messageObject.content,
                                 @"messageID":@(timestamp),
                                 @"sendTime":messageObject.sendTime,
                                 @"messageType":@(messageObject.messageType),
                                 @"userID":messageObject.userId};
    [_tableRef push:messageDic
            success:^(ItemSnapshot *itemSnapshot){
                NSLog(@"message saved to db");
            }
              error:^(NSError *error){
                  NSLog(@"message save to db failed");
              }];
}


#pragma mark - OrtcClientDelegate
- (void) onConnected:(OrtcClient*) ortc {
    NSLog(@"onConnected");
    if (!_storageRef) {
        _storageRef = [[StorageRef alloc] init:@"6YHPJX"
                                    privateKey:@"depfTd53tlqu"
                           authenticationToken:@"chatuser"];
    }
    _tableRef = [_storageRef table:_chatroomObject.chatroomID];
    if (!_chatroomObject.isCreated) {
        [_tableRef create:@"messageID" primaryKeyDataType:StorageDataType_NUMBER provisionType:ProvisionType_LIGHT provisionLoad:ProvisionLoad_BALANCED success:^(NSDictionary *data) {
            NSLog(@"Table created: %@", [data objectForKey:@"table"]);
            [_chatroomModel setChatroomIsCreatedWithBlock:_chatroomObject.chatroomID completeBlock:^() {
                NSLog(@"Success");
            }];
        } error:^(NSError *error) {
            NSLog(@"Error creating table: %@", error.description);
        }];
    }
    
    [_tableRef limit:20];
    [_tableRef asc];
    [self setupMessageStorageListener];
    [_tableRef getItems:^(ItemSnapshot *itemSnapshot){
        if(itemSnapshot) {
            NSLog(@"Item retrieved: %@", [itemSnapshot val]);
            MessageObject *messageObject = [[MessageObject alloc] initWithReceivedMessage:[itemSnapshot val]];
            [_messageObjectArray addObject:messageObject];
        } else {
            [self.hud hide:YES];
            [self initSpeakerView];
            [self sortMessageObjectArray];
            [self initChatroomTableView];
        }
    } error:^(NSError *error) {
        NSLog(@"Error");
        [self.hud hide:YES];
        [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Can not get message..." delayToHide:1];
        [self initSpeakerView];
        [self initChatroomTableView];
        NSLog(@"Oops, error retrieving items: %@", [error localizedDescription]);
    }];
}


- (void) setupMessageStorageListener {
    [_tableRef on:StorageEvent_UPDATE callback:^(ItemSnapshot *itemSnapshot){
        NSLog(@"Item updated: %@", [itemSnapshot val]);
        MessageObject *messageObject = [[MessageObject alloc] initWithReceivedMessage:[itemSnapshot val]];
        if (![messageObject.userId isEqualToString:_currentLoginUser.objectId]) {
            [_messageObjectArray addObject:messageObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_chatroomTableView reloadData];
                [self scrollChatroomTableViewToBottomAnimated:YES];
            });
        }
    }];
}

- (void)sortMessageObjectArray {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contentIndexPath"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [_messageObjectArray sortedArrayUsingDescriptors:sortDescriptors];
    [_messageObjectArray removeAllObjects];
    [_messageObjectArray addObjectsFromArray:sortedArray];
}


@end
