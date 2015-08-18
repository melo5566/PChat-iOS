//
//  ConnoisseurSingleViewController.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/14.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ConnoisseurSingleViewController.h"

@interface ConnoisseurSingleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong)UITableView                 *connoisseurSingleTableView;
@property (nonatomic,strong)ConnoisseurModel            *connoisseurSinglePageModel;
@property (nonatomic,strong)ConnoisseurSinglePageObject *connoisseurSinglePageObject;
@property (nonatomic) BOOL                              isFirstLoad;
@property (nonatomic) BOOL                              hasMoreDicussionData;
@property (nonatomic) BOOL                              hasMoreRecommendData;
@property (nonatomic) BOOL                              hasMoreFacebookData;
@property (nonatomic) CGFloat                           relativeDiscussionListCellHeight;
@property (nonatomic) CGFloat                           aboutListCellHeight;
@property (nonatomic) CGFloat                           recommendListCellHeight;
@property (nonatomic) CGFloat                           facebookListCellHeight;

@end

@implementation ConnoisseurSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@-%@",_connoisseurDataObject.connoisseurSubtitle,_connoisseurDataObject.connoisseurName];
    _isFirstLoad = YES;
    [self initModels];

    // Do any additional setup after loading the view.
}
- (void)setConnoisseurDataObject:(ConnoisseurDataObject *)connoisseurDataObject {
    _connoisseurDataObject = connoisseurDataObject;
}

- (void)viewWillAppear:(BOOL)animated{
    if(_isFirstLoad) {
        _isFirstLoad = NO;
        [self initConnoisseurSingleTableView];
        [self firstLoadData];
    }
}

- (void)initModels {
    if(!_connoisseurSinglePageModel){
        _connoisseurSinglePageModel = [[ConnoisseurModel alloc]init];
    }
}

- (void)initConnoisseurSingleTableView {
    if(!_connoisseurSingleTableView) {
        _connoisseurSingleTableView = [[UITableView alloc]initForAutolayout];
        _connoisseurSingleTableView.delegate   = self;
        _connoisseurSingleTableView.dataSource = self;
        _connoisseurSingleTableView.backgroundColor = [UIColor colorWithHexString:kColorAllBackgrounfColorHexString];
        _connoisseurSingleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_connoisseurSingleTableView];
        NSMutableArray *tableviewconstraints = @[].mutableCopy;
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_connoisseurSingleTableView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_connoisseurSingleTableView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_connoisseurSingleTableView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_connoisseurSingleTableView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        [self.view addConstraints:tableviewconstraints];
        
    }
}

- (void)firstLoadData {
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"讀取中..." delayToHide:-1];
    [_connoisseurSinglePageModel loadConnoisseurSinglePageDataWithBlock:^(ConnoisseurSinglePageObject *connoisseurObject, BOOL hasMoreDiscussion,BOOL hasMoreRecommend, BOOL hasMoreFacebook) {
        [self.hud hide:YES];
        _connoisseurSinglePageObject = connoisseurObject;
        _hasMoreDicussionData = hasMoreDiscussion;
        _hasMoreRecommendData = hasMoreRecommend;
        _hasMoreFacebookData = hasMoreFacebook;
        [self calcCellHeight];
        [_connoisseurSingleTableView reloadData];
    }];
}


- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section{
    return 2 ;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID;
    if( indexPath.row == 0) {
        cellID = @"ConnoisseurImageTableViewCell";
        ConnoisseurImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ConnoisseurImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.connoisseurDataObject = _connoisseurDataObject;
        return cell;
    }
    else if( indexPath.row == 1) {
        cellID = @"ConnoisseurRelativeViewCell";
        RelativeDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[RelativeDiscussionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.hasMoreDicussion = _hasMoreDicussionData;
        cell.relativeDiscussionList = _connoisseurSinglePageObject.discussionArray;
        return cell;
    }
    else if( indexPath.row == 2) {
        cellID = @"ConnoisseurAboutViewCell";
        RelativeDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[RelativeDiscussionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.relativeDiscussionList = _connoisseurSinglePageObject.discussionArray;
        return cell;
    }
    else if( indexPath.row == 3) {
        cellID = @"ConnoisseurRecommendViewCell";
        RelativeDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[RelativeDiscussionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.relativeDiscussionList = _connoisseurSinglePageObject.discussionArray;
        return cell;
    }
    else {
        cellID = @"ConnoisseurFacebookViewCell";
        RelativeDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[RelativeDiscussionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.relativeDiscussionList = _connoisseurSinglePageObject.discussionArray;
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 285;
    }
    else if(indexPath.row == 1) {
        return _relativeDiscussionListCellHeight;
    }
    else if (indexPath.row == 2) {
        return _aboutListCellHeight;
    }
    else if (indexPath.row == 3) {
        return _recommendListCellHeight;
    }
    else {
        return _facebookListCellHeight;
    }
}

- (void) calcCellHeight {
    if(_hasMoreDicussionData) {
        _relativeDiscussionListCellHeight = 400;
    }
    else {
        _relativeDiscussionListCellHeight = 400-100/3;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
