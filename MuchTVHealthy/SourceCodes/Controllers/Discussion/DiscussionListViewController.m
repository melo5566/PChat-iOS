//
//  DiscussionListViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "DiscussionListViewController.h"
#import "DiscussionLDetailListViewController.h"
#import "ChatroomViewController.h"
#import "MessageObject.h"
#import "CreateChatroomViewController.h"
#import "ChatroomModel.h"
#import <Parse/Parse.h>
#import "CourseListViewController.h"
#import "CustomizedAlertView.h"
#import "UserModel.h"
#import "PersonalSettingViewController.h"
#import "ChatroomListTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "GameTableViewCell.h"
#import "DiscussionModel.h"
#import "IntroductionViewController.h"


@interface DiscussionListViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, GameTableViewCellDelegate, ChatroomListTableViewCellDelegate>
@property (nonatomic, strong) UITableView           *discussionListTableView;
@property (nonatomic, strong) NSMutableArray        *listArray;
@property (nonatomic, strong) NSMutableArray        *chatroomListArray;
@property (nonatomic, strong) NSString              *currentPage;
@property (nonatomic, strong) ChatroomModel         *chatroomModel;
@property (nonatomic, strong) NSMutableDictionary   *academicDic;
@property (nonatomic, strong) NSMutableArray        *academicListArray;
@property (nonatomic, strong) NSMutableDictionary   *departmentDic;
@property (nonatomic, strong) CustomizedAlertView   *alertView;
@property (nonatomic, strong) CustomizedAlertView   *resetLocationAlertView;
@property (nonatomic) BOOL                          isAdding;
@property (nonatomic, strong) PFUser                *currentUser;
@property (nonatomic, strong) UserModel             *userModel;
@property (nonatomic, strong) CustomizedAlertView   *loginAlertView;
@property (nonatomic) BOOL                          hasCreatedChatroom;
@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (nonatomic, strong) DiscussionModel       *discussionModel;
@property (nonatomic, strong) NSMutableArray        *categoryArray;
@end

@implementation DiscussionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults stringForKey:@"firstLaunch"] isEqualToString:@"YES"]) {
        IntroductionViewController *controller = [IntroductionViewController new];
        [self.navigationController pushViewController:controller animated:NO];
        [defaults setObject:@"NO" forKey:@"firstLaunch"];
        [defaults synchronize];
    }
    [self initListButton];
    [self initListArray];
    [self setTitle:@"Chatroom"];
    _currentPage = @"Chatroom";
    [self initCreateButton];
    _chatroomModel = [ChatroomModel new];
    _chatroomModel.delegate = self;
    _userModel = [UserModel new];
    _userModel.delegate = self;
    _discussionModel = [DiscussionModel new];
    [self loadAcademic];
    [self loadCategory];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _currentUser = [PFUser currentUser];
    if ([_currentPage isEqualToString:@"Chatroom"]) {
        [self loadChatroomList];
    } else if ([_currentPage isEqualToString:@"Favorites"] && _currentUser) {
        [self loadFavorites];
    }
    [self initDiscussionListTableView];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initMenuLayout];
    [self initGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
    if ([_currentPage isEqualToString:@"Favorites"])
        [_listArray removeAllObjects];
}

#pragma init
- (void)initCreateButton {
    UIButton *customizedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame = CGRectMake(0, 0, 20, 20);
    UIImage *iconImage = [UIImage imageNamed:@"icon_create"];
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
}

- (void)initListArray {
    _listArray = @[].mutableCopy;
    _academicListArray = @[].mutableCopy;
    _departmentDic = [NSMutableDictionary new];
}

- (void) initDiscussionListTableView {
    if (!_discussionListTableView) {
        _discussionListTableView = [[UITableView alloc] initForAutolayout];
        _discussionListTableView.delegate        = self;
        _discussionListTableView.dataSource      = self;
        _discussionListTableView.backgroundColor = [UIColor clearColor];
        _discussionListTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _discussionListTableView.alwaysBounceVertical = NO;
        
        [self.view addSubview:_discussionListTableView];
        
        NSMutableArray *discussionTableViewConstraint = [[NSMutableArray alloc] init];
        
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionListTableView
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionListTableView
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionListTableView
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:0.0f]];
        [discussionTableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionListTableView
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:discussionTableViewConstraint];
    }
    [_discussionListTableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if ([_currentPage isEqualToString:@"Chatroom"])
        return _chatroomListArray.count;
    else
        return _listArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentPage isEqualToString:@"Academics"])
        return 60;
    else
        return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if ([_currentPage isEqualToString:@"Chatroom"]) {
        static NSString *cell = @"cell";
        ChatroomListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:nil];
        if (!listCell) {
            listCell = [[ChatroomListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        ChatroomListObject *chatroomObject = _chatroomListArray[indexPath.row];
        listCell.delegate = self;
        listCell.chatroomListObject = chatroomObject;
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return listCell;
    } else if ([_currentPage isEqualToString:@"Academics"]) {
        [cell.textLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        cell.textLabel.text = _listArray[indexPath.row];
    } else {
        static NSString *cell = @"cell";
        GameTableViewCell *gameCell = [tableView dequeueReusableCellWithIdentifier:nil];
        if (!gameCell) {
            gameCell = [[GameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        gameCell.delegate = self;
        if ([_listArray[indexPath.row] isKindOfClass:[CategoryObject class]])
            gameCell.categoryObject = _listArray[indexPath.row];
        else
            gameCell.category = _listArray[indexPath.row];
        gameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return gameCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentPage isEqualToString:@"Academics"]) {
        if ([[_academicDic allKeys] containsObject:_listArray[indexPath.row]]) {
            if ([_academicDic[_listArray[indexPath.row]] boolValue] == NO) {
                for (int i = 0; i < _academicListArray.count; i++) {
                    NSRange range = [_academicListArray[i] rangeOfString:@"_"];
                    if ([_listArray[indexPath.row] isEqualToString:[_academicListArray[i] substringToIndex:range.location]]) {
                        [_listArray insertObject:[NSString stringWithFormat:@"    -%@",[_academicListArray[i] substringFromIndex:range.location+1]] atIndex:indexPath.row+1];
                    }
                }
                _academicDic[_listArray[indexPath.row]] = @YES;
            } else {
                _academicDic[_listArray[indexPath.row]] = @NO;
                [_listArray removeAllObjects];
                [_listArray addObjectsFromArray:[_academicDic allKeys]];
                for (int i = 0; i < _listArray.count; i++) {
                    if ([_academicDic[_listArray[i]] boolValue] == YES) {
                        for (int j = 0; j < _academicListArray.count; j ++) {
                            NSRange range = [_academicListArray[j] rangeOfString:@"_"];
                            if ([_listArray[i] isEqualToString:[_academicListArray[j] substringToIndex:range.location]]) {
                                [_listArray insertObject:[NSString stringWithFormat:@"    -%@",[_academicListArray[j] substringFromIndex:range.location+1]] atIndex:i+1];
                            }
                        }
                    }
                }
            }
        } else {
            CourseListViewController *controller = [CourseListViewController new];
            controller.department = _listArray[indexPath.row];
            [self.navigationController pushViewController:controller animated:YES];
        }
                [UIView transitionWithView:_discussionListTableView
                          duration:0.35f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void) {
                        [_discussionListTableView  reloadData];
         } completion:nil];
    } else if ([_currentPage isEqualToString:@"Chatroom"]) {
        ChatroomViewController *chatroomViewController = [[ChatroomViewController alloc] init];
        chatroomViewController.chatroomObject = _chatroomListArray[indexPath.row];
        [self.navigationController pushViewController:chatroomViewController animated:YES];
    } else {
        DiscussionLDetailListViewController *controller = [DiscussionLDetailListViewController new];
        if ([_listArray[indexPath.row] isKindOfClass:[CategoryObject class]]) {
            CategoryObject *object = _listArray[indexPath.row];
            controller.category = object.name;
        } else
            controller.category = _listArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void) loadChatroomList {
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            _chatroomListArray = @[].mutableCopy;
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Loading..." delayToHide:-1];
            [_chatroomModel loadChatroomListWithBlock:geoPoint completeBlock:^(NSArray *chatroomListArray) {
                if (chatroomListArray.count == 0) {
                    [self.hud hide:YES];
                    [self initDiscussionListTableView];
                    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"No chatroom available..." delayToHide:1];
                } else {
                    [_chatroomListArray addObjectsFromArray:chatroomListArray];
                    [self sortChatroomListArray];
                    [self.hud hide:YES];
                    [self initDiscussionListTableView];
                }
            }];
        } else {
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Can't get your location..." delayToHide:1];
            [_listArray removeAllObjects];
            [_discussionListTableView reloadData];
        }
    }];
}

- (void) loadCategory {
    _categoryArray = @[].mutableCopy;
    [_discussionModel loadCategoryWihtBlock:^(NSArray *array) {
        [_categoryArray addObjectsFromArray:array];
    }];
}

- (void) loadFavorites {
    _listArray = @[].mutableCopy;
    [_userModel loadFavoriteWithBlock:_currentUser completeBlock:^(NSArray *array) {
        for (NSString *name in array) {
            if ([name containsString:@"_"]) {
                [_listArray addObject:name];
            } else {
                for (CategoryObject *object in _categoryArray) {
                    if ([name isEqualToString:object.name])
                        [_listArray addObject:object];
                }
            }
        }
    }];
}

- (void) loadAcademic {
    [_discussionModel loadAcademicListWithBlock:^(NSArray *array) {
        _academicDic = [NSMutableDictionary new];
        [_academicListArray addObjectsFromArray:array];
        for (NSString *string in array) {
            NSRange range = [string rangeOfString:@"_"];
            _academicDic[[string substringToIndex:range.location]] = @NO;
        }
    }];
        
}

- (void)menuButtonClicked:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            if (![_currentPage isEqualToString:@"Chatroom"]) {
                [self setTitle:@"Chatroom"];
                _currentPage = @"Chatroom";
                [self loadChatroomList];
                [self initCreateButton];
                [self dismissMenu];
            } else
                [self dismissMenu];
            break;
        }
        case 1: {
            if (![_currentPage isEqualToString:@"Sports"]) {
                [self setTitle:@"Sports"];
                _currentPage = @"Sports";
                [_listArray removeAllObjects];
                for (CategoryObject *object in _categoryArray) {
                    if ([object.category isEqualToString:@"Sport"])
                        [_listArray addObject:object];
                }
                [_discussionListTableView reloadData];
                self.navigationItem.rightBarButtonItem = nil;
                [self dismissMenu];
            } else
                [self dismissMenu];
            break;
        }
        case 2: {
            if (![_currentPage isEqualToString:@"Academics"]) {
                [self setTitle:@"Academics"];
                _currentPage = @"Academics";
                [_listArray removeAllObjects];
                [_listArray addObjectsFromArray:[_academicDic allKeys]];
                for (int i = 0; i < _listArray.count; i++) {
                    if ([_academicDic[_listArray[i]] boolValue] == YES) {
                        for (int j = 0; j < _academicListArray.count; j ++) {
                            NSRange range = [_academicListArray[j] rangeOfString:@"_"];
                            if ([_listArray[i] isEqualToString:[_academicListArray[j] substringToIndex:range.location]]) {
                                [_listArray insertObject:[NSString stringWithFormat:@"    -%@",[_academicListArray[j] substringFromIndex:range.location+1]] atIndex:i+1];
                            }
                        }
                    }
                }
                [_discussionListTableView reloadData];
                self.navigationItem.rightBarButtonItem = nil;
                [self dismissMenu];
            } else
                [self dismissMenu];
            break;
        }
        case 3: {
            if (![_currentPage isEqualToString:@"Games"]) {
                [self setTitle:@"Games"];
                _currentPage = @"Games";
                [_listArray removeAllObjects];
                for (CategoryObject *object in _categoryArray) {
                    if ([object.category isEqualToString:@"Game"])
                        [_listArray addObject:object];
                }
                [_discussionListTableView reloadData];
                self.navigationItem.rightBarButtonItem = nil;
                [self dismissMenu];
            } else
                [self dismissMenu];
            break;
        }
        case 4: {
            if (![_currentPage isEqualToString:@"Favorites"]) {
                [self setTitle:@"Favorites"];
                _currentPage = @"Favorites";
                [self loadFavorites];
                [_discussionListTableView reloadData];
                self.navigationItem.rightBarButtonItem = nil;
                [self dismissMenu];
            } else
                [self dismissMenu];
            break;
        }
        default:
            break;
    }
}

- (void)createButtonPressed:(id)sender {
    if (_currentUser) {
        if ([_currentUser[@"chatroomID"] isNotEmpty]) {
            _resetLocationAlertView = [[CustomizedAlertView alloc] initWithTitle:@"Already got one" andMessage:@"Do you want to update your information?"];
            [_resetLocationAlertView addButtonWithTitle:@"NO"
                                      type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                   handler:^(CustomizedAlertView *alertView) {
                                       
                                   }];
            [_resetLocationAlertView addButtonWithTitle:@"YES"
                                      type:CustomizedAlertViewButtonTypeDefaultGreen
                                   handler:^(CustomizedAlertView *alertView) {
                                       CreateChatroomViewController *controller = [CreateChatroomViewController new];
                                       [self.navigationController pushViewController:controller animated:YES];
                                   }];
            [_resetLocationAlertView show];

        } else {
            CreateChatroomViewController *controller = [CreateChatroomViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        [self askToLogIn];
    }
}

- (void) handleLongPress:(NSString *)category {
    if ([_currentPage isEqualToString:@"Sports"] || [_currentPage isEqualToString:@"Games"]) {
        if (!_isAdding) {
            if (_currentUser) {
                _isAdding = YES;
                _alertView = [[CustomizedAlertView alloc] initWithTitle:@"Add to my favorites" andMessage:@"Are you sure?"];
                [_alertView addButtonWithTitle:@"NO"
                                          type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                       handler:^(CustomizedAlertView *alertView) {
                                           _isAdding = NO;
                                       }];
                [_alertView addButtonWithTitle:@"YES"
                                          type:CustomizedAlertViewButtonTypeDefaultGreen
                                       handler:^(CustomizedAlertView *alertView) {
                                           _isAdding = NO;
                                           [_userModel updateFavorites:category ForUser:_currentUser completeBlock:^(BOOL isExist) {
                                               if (isExist) {
                                                   [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Already on favorites..." delayToHide:1];
                                               } else {
                                                   [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeText text:@"Successfully add to my favorites..." delayToHide:1];
                                                   [self loadFavorites];
                                               }
                                           }];
                                       }];
                [_alertView show];
            } else {
                _isAdding = YES;
                [self askToLogIn];
            }
        }
    } else if ([_currentPage isEqualToString:@"Favorites"]) {
        if (!_isAdding) {
            _isAdding = YES;
            _alertView = [[CustomizedAlertView alloc] initWithTitle:@"Delete from my favorites" andMessage:@"Are you sure?"];
            [_alertView addButtonWithTitle:@"NO"
                                      type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                   handler:^(CustomizedAlertView *alertView) {
                                       _isAdding = NO;
                                   }];
            [_alertView addButtonWithTitle:@"YES"
                                      type:CustomizedAlertViewButtonTypeDefaultGreen
                                   handler:^(CustomizedAlertView *alertView) {
                                       _isAdding = NO;
                                       [_userModel deleteFromMyFavorite:_currentUser category:category completeBlock:^() {
                                           [self loadFavorites];
                                           [_discussionListTableView reloadData];
                                       }];
                                   }];
            [_alertView show];
        }
    }
}

- (void)handleLongPressD:(NSString *)creatorID {
    if ([creatorID isEqualToString:_currentUser.objectId]) {
        if (!_isAdding) {
            _isAdding = YES;
            _alertView = [[CustomizedAlertView alloc] initWithTitle:@"Delete your chatroom" andMessage:@"Are you sure?"];
            [_alertView addButtonWithTitle:@"NO"
                                      type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                   handler:^(CustomizedAlertView *alertView) {
                                       _isAdding = NO;
                                   }];
            [_alertView addButtonWithTitle:@"YES"
                                      type:CustomizedAlertViewButtonTypeDefaultGreen
                                   handler:^(CustomizedAlertView *alertView) {
                                       _isAdding = NO;
                                       [_chatroomModel deleteChatroomWithBlock:_currentUser completeBlock:^() {
                                           [self loadChatroomList];
                                           [_discussionListTableView reloadData];
                                       }];
                                   }];
            [_alertView show];
        }
    }
}

- (void) askToLogIn {
    _loginAlertView = [[CustomizedAlertView alloc] initWithTitle:@"Warning" andMessage:@"Please login first..."];
    [_loginAlertView addButtonWithTitle:@"No Thanks"
                                   type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                handler:^(CustomizedAlertView *alertView) {
                                    _isAdding = NO;
                                }];
    
    [_loginAlertView addButtonWithTitle:@"Login"
                                   type:CustomizedAlertViewButtonTypeDefaultGreen
                                handler:^(CustomizedAlertView *alertView) {
                                    _isAdding = NO;
                                    PersonalSettingViewController *controller = [[PersonalSettingViewController alloc] init];
                                    [self.navigationController pushViewController:controller animated:YES];
                                }];
    [_loginAlertView show];
}

- (void)hasNoNetworkConnection {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can not connect to the Internet. Please check the connection. "
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [self.hud hide:YES];
                                                             [_discussionListTableView reloadData];
                                                             
                                                         }];
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.hud hide:YES];
                                                              [self loadChatroomList];
                                                          }];
    [alert addAction:cancelAction];
    [alert addAction:refreshAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)sortChatroomListArray {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"range"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [_chatroomListArray sortedArrayUsingDescriptors:sortDescriptors];
    [_chatroomListArray removeAllObjects];
    [_chatroomListArray addObjectsFromArray:sortedArray];
}


@end
