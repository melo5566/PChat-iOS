//
//  ConnoisseurListViewController.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/12.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ConnoisseurListViewController.h"
#import "ConnoisseurModel.h"
#import "ConnoisseurListTableViewCell.h"
@interface ConnoisseurListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView                *connoisseurListTableView;
@property (nonatomic,strong) ConnoisseurModel           *connoisseurModel;
@property (nonatomic,strong) ConnoisseurObject          *connoisseurObject;
@property (nonatomic) BOOL                              isFirstLoad;
@property (nonatomic) BOOL                              hadMoreConnoisseurData;
@property (nonatomic) NSUInteger                        loadingStartIndex;
@end

@implementation ConnoisseurListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"達人專區";
    _isFirstLoad = YES;
    [self initModels];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    if(_isFirstLoad) {
        _isFirstLoad = NO;
        [self initConnoisseurTableView];
        [self firstLoadData];
    }
}


- (void)initConnoisseurTableView {
    if(!_connoisseurListTableView) {
        _connoisseurListTableView = [[UITableView alloc]initForAutolayout];
        _connoisseurListTableView.delegate = self;
        _connoisseurListTableView.dataSource = self;
        _connoisseurListTableView.backgroundColor =  [UIColor colorWithHexString:kConnoisseurListBackgroundColor];
        _connoisseurListTableView.hidden = YES;
        _connoisseurListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_connoisseurListTableView];
        NSMutableArray *tableviewconstraints = @[].mutableCopy;
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_connoisseurListTableView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_connoisseurListTableView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_connoisseurListTableView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_connoisseurListTableView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        [self.view addConstraints:tableviewconstraints];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetParams {
    _loadingStartIndex = 0;
    _hadMoreConnoisseurData = YES;
    if(!_connoisseurObject) {
        _connoisseurObject = nil;
    }
    if(!_connoisseurModel.connoisseurObject) {
        _connoisseurModel.connoisseurObject = nil;
    }
}

- (void)initModels {
    if(!_connoisseurModel) {
        _connoisseurModel = [[ConnoisseurModel alloc]init];
        _connoisseurModel.delegate = self;
    }
}

- (void)firstLoadData {
    [self resetParams];
    [self showHUDAddedTo:self.view animated:YES HUDMode:MBProgressHUDModeIndeterminate text:@"讀取中..." delayToHide:-1];
    [_connoisseurModel loadConnoisseurDataWithBlock:^(ConnoisseurObject *connoisseurObject, BOOL hasMore) {
        [self.hud hide:YES];
        _connoisseurObject = connoisseurObject;
        _hadMoreConnoisseurData = hasMore;
        _connoisseurListTableView.hidden = NO;
        [_connoisseurListTableView reloadData];
    }];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section{
    return _connoisseurObject.dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ConnoisseurListTableViewCell";
    ConnoisseurListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[ConnoisseurListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.connoisseurDataObject = _connoisseurObject.dataArray[indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  kScreenWidth;
}

- (void) initLeftBarButton {
    UIButton *customizedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame = CGRectMake(0, 0, 25, 25);
    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_whole"]];
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(leftBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;
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
