//
//  WorkloadViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/12/1.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "WorkloadViewController.h"
#import "PersonalSettingViewController.h"
#import "SignUpAndSignInModel.h"
#import "DiscussionModel.h"
#import "CustomizedAlertView.h"

#define workload        @[@"Light",@"Moderate",@"Heavy",@"Extremely Heavy"]

@interface WorkloadViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel                       *titleLabel;
@property (nonatomic, strong) UIButton                      *voteButton;
@property (nonatomic, strong) UIView                        *voteButtonView;
@property (nonatomic, strong) CustomizedAlertView           *loginAlertView;
@property (nonatomic, strong) SignUpAndSignInModel          *loginModel;
@property (nonatomic) BOOL                                  hasVoted;
@property (nonatomic, strong) NSString                      *voteObjectId;
@property (nonatomic) NSUInteger                            votedIndex;
@property (nonatomic, strong) NSString                      *userUri;
@property (nonatomic, strong) UIButton                      *voteViewStatusButton;
@property (nonatomic, strong) NSString                      *voteViewStatus;
@property (nonatomic, strong) UIProgressView                *voteResultBar;
@property (nonatomic, strong) UIView                        *voteResultView;
@property (nonatomic, strong) UILabel                       *choiceLabel;
@property (nonatomic, strong) UILabel                       *percentageLabel;
@property (nonatomic) NSUInteger                            totalResult;
@property (nonatomic, strong) DiscussionModel               *discussionModel;
@property (nonatomic, strong) UILabel                       *averageScoreLabel;
@property (nonatomic, strong) PFUser                        *currentUser;
@property (nonatomic, strong) NSString                      *votedChoice;
@end

@implementation WorkloadViewController

- (void)setWorkloadObject:(WorkloadObject *)workloadObject {
    _workloadObject = workloadObject;
    self.title = [NSString stringWithFormat:@"%@_%@",workloadObject.department, workloadObject.course];
    _totalResult = _workloadObject.light + _workloadObject.moderate + _workloadObject.heavy + _workloadObject.exHeavy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _voteViewStatus = @"vote";
    self.view.backgroundColor = [UIColor colorWithR:250 G:250 B:250];
    // Do any additional setup after loading the view.
    _discussionModel = [DiscussionModel new];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userStatusChanged:)
                                                 name:kEventUserStatusChanged
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _currentUser = [PFUser currentUser];
    [self initNavigationBarBackButtonAtLeft];
    if (_currentUser)
        [self checkIsVoted];
    else {
        _hasVoted = NO;
        _votedChoice = @"";
        [self initLayout];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

- (void)checkIsVoted {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Loading..." delayToHide:-1];
    [_discussionModel checkIfVotedWithBlock:_currentUser.objectId courseID:_workloadObject.courseID completeBlock:^(BOOL isVoted, NSString *choice) {
        [self.hud hide:YES];
        _hasVoted = isVoted;
        _votedChoice = choice;
        [self initLayout];
    }];
}

#pragma mark - init
- (void) initLayout {
    [self initVoteTitleLabel];
    [self initVoteViewStatusButton];
    [self initVoteButtonView];
}

- (void) initVoteTitleLabel {
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc] initForAutolayout];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor       = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _titleLabel.font            = [UIFont fontWithName:@"STHeitiTC-Light" size:18.0];
        [self.view addSubview:_titleLabel];
        
        NSMutableArray *titleLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0f constant:0.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:15.5f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:120.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:30.0f]];
        
        [self.view addConstraints:titleLabelViewConstraint];
        
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@ %@",_workloadObject.season, _workloadObject.year];
    _titleLabel.numberOfLines   = 0;
    _titleLabel.lineBreakMode   = NSLineBreakByCharWrapping;
    [_titleLabel sizeToFit];
}

- (void) initVoteViewStatusButton {
    if (!_voteViewStatusButton) {
        _voteViewStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voteViewStatusButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_voteViewStatusButton addTarget:self action:@selector(voteViewStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
        _voteButton.backgroundColor = [UIColor clearColor];
        [_voteViewStatusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _voteButton.titleLabel.font     = [UIFont systemFontOfSize:12];
        [self.view addSubview:_voteViewStatusButton];
        
        NSMutableArray *voteViewStatusLabelConstaint = @[].mutableCopy;
        
        [voteViewStatusLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteViewStatusButton
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0f constant:0.0f]];
        [voteViewStatusLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteViewStatusButton
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_titleLabel
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f constant:0.0f]];
        [voteViewStatusLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteViewStatusButton
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:100.0f]];
        [voteViewStatusLabelConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteViewStatusButton
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:20.0f]];
        
        [self.view addConstraints:voteViewStatusLabelConstaint];
        
    }
    if ([_voteViewStatus isEqualToString:@"result"])
        [_voteViewStatusButton setTitle:@"Voting" forState:UIControlStateNormal];
    else
        [_voteViewStatusButton setTitle:@"Result" forState:UIControlStateNormal];
}

- (void) initVoteButton:(NSString *)votedChoice {
    for (int i = 0; i < workload.count; i++) {
        _voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _voteButton.tag = i;
        [_voteButton addTarget:self action:@selector(voteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([workload[i] isEqualToString:votedChoice]) {
            _voteButton.backgroundColor = [UIColor colorWithHexString:kNavigationBarColorHexString];
        } else {
            _voteButton.backgroundColor = [UIColor colorWithHexString:kDefaultYellowColorHexString];
        }
        [_voteButton setTitle:workload[i] forState:UIControlStateNormal];
        [_voteButton setTitleColor:[UIColor colorWithR:255 G:255 B:255] forState:UIControlStateNormal];
        _voteButton.titleLabel.font     = [UIFont systemFontOfSize:18];
        _voteButton.layer.cornerRadius  = 35 / 4;
        [_voteButtonView addSubview:_voteButton];
        NSMutableArray *voteButtonConstaint = @[].mutableCopy;
        [voteButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteButton
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_voteButtonView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:10.0f]];
        [voteButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteButton
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_voteButtonView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:15 + i*(kFrameHeight*3/40 +15)]];
        [voteButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteButton
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:kFrameHeight*3/40]];
        [voteButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteButton
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_voteButtonView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:-10.0f]];
        
        [self.view addConstraints:voteButtonConstaint];
    }
    
}

- (void) initVoteButtonView {
    if (!_voteButtonView) {
        _voteButtonView = [[UIView alloc] initForAutolayout];
        _voteButtonView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_voteButtonView];
        
        [self initVoteButton:_votedChoice];
        
        NSMutableArray *contentContainerConstaint = @[].mutableCopy;
        
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteButtonView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:5.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteButtonView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_voteViewStatusButton
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:0.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteButtonView
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-5.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteButtonView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:30 + 4*(kFrameHeight*3.0f/40.0f) + (4 - 1) * 15.0f]];
        
        
        [self.view addConstraints:contentContainerConstaint];
    }
    [self initVoteButton:_votedChoice];
}


- (void) initVoteResultView {
    if (!_voteResultView) {
        _voteResultView = [[UIView alloc] initForAutolayout];
        _voteResultView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_voteResultView];
        
        NSMutableArray *contentContainerConstaint = @[].mutableCopy;
        
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteResultView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:5.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteResultView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_voteViewStatusButton
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:0.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteResultView
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-5.0f]];
        [contentContainerConstaint addObject:[NSLayoutConstraint constraintWithItem:_voteResultView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:4 * 70 + 30]];
        
        [self.view addConstraints:contentContainerConstaint];
    }
}

- (void) initVoteChoiceLabel {
    for (int i = 0; i < workload.count; i++) {
        NSUInteger j = 0;
        if (i == 0)
            j = _workloadObject.light;
        else if (i == 1)
            j = _workloadObject.moderate;
        else if (i == 2)
            j = _workloadObject.heavy;
        else
            j = _workloadObject.exHeavy;
        _choiceLabel                 = [[UILabel alloc] initForAutolayout];
        _choiceLabel.lineBreakMode   = UILineBreakModeWordWrap;
        _choiceLabel.lineBreakMode   = NSLineBreakByTruncatingTail;
        _choiceLabel.text            = [NSString stringWithFormat:@"%@(%d)",workload[i], j];
        _choiceLabel.backgroundColor = [UIColor clearColor];
        _choiceLabel.numberOfLines   = 2;
        _choiceLabel.textColor       = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _choiceLabel.font            = [UIFont fontWithName:@"Arial" size:18.0];
        [_choiceLabel sizeToFit];
        [_voteResultView addSubview:_choiceLabel];
        
        NSMutableArray *titleLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_choiceLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_voteResultView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:8.5f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_choiceLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_voteResultView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:i*70]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_choiceLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:30.0f]];
        
        
        _voteResultBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [_voteResultBar setTranslatesAutoresizingMaskIntoConstraints:NO];
        _voteResultBar.backgroundColor      = [UIColor lightGrayColor];
        _voteResultBar.clipsToBounds        = YES;
        _voteResultBar.layer.cornerRadius   = 10.0f;
        _voteResultBar.progress = _totalResult == 0 ? 0:(float)j/_totalResult;
        [_voteResultView addSubview:_voteResultBar];
        
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_voteResultBar
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_voteResultView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:8.5f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_voteResultBar
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_choiceLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:5.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_voteResultBar
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:20.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_voteResultBar
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_voteResultView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-45.0f]];
        
        
        _percentageLabel                  = [[UILabel alloc] initForAutolayout];
        _percentageLabel.text             = _totalResult == 0 ? @"0%" : [NSString stringWithFormat:@"%d%%",(int)roundf(((float)j/_totalResult*100))];
        _percentageLabel.backgroundColor  = [UIColor clearColor];
        _percentageLabel.textColor        = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _percentageLabel.font             = [UIFont fontWithName:@"Arial" size:15.0];
        [_voteResultView addSubview:_percentageLabel];
        
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_percentageLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_voteResultBar
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:5.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_percentageLabel
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_voteResultBar
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0f constant:0.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_percentageLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-5.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_percentageLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:30.0f]];
        
        if (!_averageScoreLabel) {
            _averageScoreLabel                 = [[UILabel alloc] initForAutolayout];
            _averageScoreLabel.backgroundColor = [UIColor clearColor];
            _averageScoreLabel.textColor       = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
            _averageScoreLabel.font            = [UIFont fontWithName:@"STHeitiTC-Light" size:18.0];
            [self.view addSubview:_averageScoreLabel];
            
            NSMutableArray *titleLabelViewConstraint = [[NSMutableArray alloc] init];
            
            [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_averageScoreLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0f constant:15.0f]];
            [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_averageScoreLabel
                                                                             attribute:NSLayoutAttributeBottom
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_voteResultView
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f constant:0.0f]];
            [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_averageScoreLabel
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0f constant:-15.0f]];
            [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_averageScoreLabel
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:30.0f]];
            
            [self.view addConstraints:titleLabelViewConstraint];
            
        }
        float average = _totalResult == 0 ? 0 : (float)(_workloadObject.light + _workloadObject.moderate*2 + _workloadObject.heavy*3 + _workloadObject.exHeavy*4)/_totalResult;
        _averageScoreLabel.text = [NSString stringWithFormat:@"Average Score: %.3f",average];
        _averageScoreLabel.numberOfLines   = 0;

        
        if (i == _votedIndex) {
            UIImageView *imageView = [[UIImageView alloc] initForAutolayout];
            imageView.image = [UIImage imageNamed:@"iocn_official"];
            [_voteResultView addSubview:imageView];
            
            [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_choiceLabel
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0f constant:5.0f]];
            [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_choiceLabel
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1.0f constant:0.0f]];
            [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:25.0f]];
            [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:25.0f]];
        }
        
        [self.view addConstraints:titleLabelViewConstraint];
    }
}

#pragma mark - button clicked
- (void)voteButtonClicked:(id)sender {
    if (_currentUser) {
        if (!_hasVoted) {
            UIButton *button = sender;
            [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"Uploading..." delayToHide:-1];
            [_discussionModel uploadVoteDataWithBlock:_workloadObject.courseID voterID:_currentUser.objectId choice:workload[button.tag] completeBlock:^() {
                [self.hud hide:YES];
                _hasVoted = YES;
                _votedChoice = workload[button.tag];
                if (button.tag == 0)
                    _workloadObject.light ++;
                else if (button.tag == 1)
                    _workloadObject.moderate ++;
                else if (button.tag == 2)
                    _workloadObject.heavy ++;
                else
                    _workloadObject.exHeavy ++;
                _totalResult ++;
                [self initLayout];
                [_voteResultView removeFromSuperview];
                _voteResultView = nil;
                [_choiceLabel removeFromSuperview];
                _choiceLabel = nil;
                [_percentageLabel removeFromSuperview];
                _percentageLabel = nil;
                [_averageScoreLabel removeFromSuperview];
                _averageScoreLabel = nil;
                [_voteResultBar removeFromSuperview];
                _voteResultBar = nil;
            }];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Voting" message:@"You have voted！！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } else {
        [self askToLogIn];
    }
}

- (void) voteViewStatusChanged:(id)sender {
    if (!_voteResultView) {
        [self initVoteResultView];
        [self initVoteChoiceLabel];
        _voteResultView.alpha = 0;
    }
    if ([_voteViewStatus isEqualToString:@"vote"]) {
        _voteViewStatusButton.alpha = 0;
        _voteButtonView.alpha       = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 animations:^(){
                [_voteViewStatusButton setTitle:@"Vote" forState:UIControlStateNormal];
                _voteViewStatusButton.alpha = 1;
                _voteResultView.alpha       = 1;
                _averageScoreLabel.alpha    = 1;
            }];
        });
        _voteViewStatus = @"result";
    } else {
        _voteViewStatusButton.alpha = 0;
        _voteResultView.alpha       = 0;
        _averageScoreLabel.alpha    = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 animations:^(){
                [_voteViewStatusButton setTitle:@"Result" forState:UIControlStateNormal];
                _voteViewStatusButton.alpha = 1;
                _voteButtonView.alpha       = 1;
            }];
        });
        _voteViewStatus = @"vote";
    }
}

#pragma mark - hasNoNetwork method
- (void) noNetworkAlertRefreshButtonPressed {
    [self.hud hide:YES];
//    [self loadVoteData];
}

- (void) noNetworkAlertCancelButtonPressed {
    [self.hud hide:YES];
}



#pragma mark - login method
- (void) askToLogIn {
    _loginAlertView = [[CustomizedAlertView alloc] initWithTitle:@"Warning" andMessage:@"Please login first..."];
    [_loginAlertView addButtonWithTitle:@"No Thanks"
                                   type:CustomizedAlertViewButtonTypeDefaultLightGreen
                                handler:nil];
    
    [_loginAlertView addButtonWithTitle:@"Login"
                                   type:CustomizedAlertViewButtonTypeDefaultGreen
                                handler:^(CustomizedAlertView *alertView) {
                                    PersonalSettingViewController *controller = [[PersonalSettingViewController alloc] init];
                                    [self.navigationController pushViewController:controller animated:YES];
                                }];
    [_loginAlertView show];

}

//- (void) userStatusChanged:(NSNotification *) notification {
//    if ([notification.object isEqualToString:@"LOGGED_IN"]) {
//        _userUri      = [KiiUser currentUser].objectURI;
//        [_voteModel checkVoteDataWithBlock:_voteObject.objectId userUri:_userUri CompleteBlock:^(BOOL hasVoted, NSUInteger votedIndex) {
//            [self.hud hide:YES];
//            _votedIndex = votedIndex;
//            _hasVoted = hasVoted;
//            [self initLayout];
//        }];
//    }
//}

@end
