//
//  RecipeViewController.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/14.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "RecipeViewController.h"
#import "RecipeTableViewCell.h"

@interface RecipeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView                       *recipeTableView;
@property (nonatomic, strong) UIButton                          *collectionButton;
@property (nonatomic, strong) UIButton                          *totalButton;
@property (nonatomic, strong) UIImageView                       *totalImageView;
@property (nonatomic, strong) UIImageView                       *collectionImageView;
@property (nonatomic, strong) UIView                            *recipeMenuView;
@property (nonatomic, strong) UIView                            *fanzytvLogoView;
@property (nonatomic, strong) UIView                            *classifiedView;
@property (nonatomic, strong) UIButton                          *recipeMenuButton;
@property (nonatomic, strong) UIImageView                       *fanzytvLogo;
@property (nonatomic, strong) NSLayoutConstraint                *recipeMenuViewLeftLayoutConstraint;
@property (nonatomic) BOOL                                      isShownRecipeMenuView;
@property (nonatomic, strong) NSMutableArray                    *recipeDataArray;
@property (nonatomic, strong) NSString                          *recipeType;
@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"食譜"];
    [self initListButton];
    _recipeType = @"total";
    
    UIButton *customizedButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    customizedButton.backgroundColor = [UIColor clearColor];
    customizedButton.frame           = CGRectMake(0, 0, 25, 25);
    UIImage *iconImage               = [UIImage imageNamed:[NSString stringWithFormat:@"icon_category"]];
    [customizedButton setImage:iconImage forState:UIControlStateNormal];
    [customizedButton addTarget:self action:@selector(recipeMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customizedButton];
    navigatinBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _recipeDataArray = @[].mutableCopy;
    for (int i = 0; i < 10; i ++) {
        [_recipeDataArray addObject:@"total"];
    }
    
    [self initLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initMenuLayout];
    [self initRecipeMenuLayout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dismissMenu];
    [self dismissRecipeMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init
- (void) initLayout {
    [self initTotalButton];
    [self initCollectionButton];
    [self initTotalImageView];
    [self initCollectionImageView];
    [self initRecipeTableView];
}

- (void) initTotalButton {
    if (!_totalButton) {
        _totalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_totalButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_totalButton addTarget:self action:@selector(totalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_totalButton setTitle:@"全 部" forState:UIControlStateNormal];
        [_totalButton.layer setShadowColor:[UIColor blackColor].CGColor];
        [_totalButton.layer setShadowOpacity:0.5];
        [_totalButton.layer setShadowOffset:CGSizeMake(0, 0.5)];
        [_totalButton setBackgroundColor:[UIColor whiteColor]];
        [_totalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _totalButton.titleLabel.font     = [UIFont systemFontOfSize:18];
        [self.view addSubview:_totalButton];

        
        NSMutableArray *buttonConstraint = [[NSMutableArray alloc] init];
        
        [buttonConstraint addObject:[NSLayoutConstraint constraintWithItem:_totalButton
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0.0f]];
        [buttonConstraint addObject:[NSLayoutConstraint constraintWithItem:_totalButton
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:0.0f]];
        [buttonConstraint addObject:[NSLayoutConstraint constraintWithItem:_totalButton
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f constant:0.0f]];
        [buttonConstraint addObject:[NSLayoutConstraint constraintWithItem:_totalButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:40.0f]];
        
        [self.view addConstraints:buttonConstraint];

    }
}

- (void) initCollectionButton {
    if (!_collectionButton) {
        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_collectionButton addTarget:self action:@selector(collectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_collectionButton setTitle:@"收 藏" forState:UIControlStateNormal];
        [_collectionButton.layer setShadowColor:[UIColor blackColor].CGColor];
        [_collectionButton.layer setShadowOpacity:0.5];
        [_collectionButton.layer setShadowOffset:CGSizeMake(0, 0.5)];
        [_collectionButton setBackgroundColor:[UIColor whiteColor]];
        [_collectionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _collectionButton.titleLabel.font     = [UIFont systemFontOfSize:18];
        [self.view addSubview:_collectionButton];

        
        NSMutableArray *buttonConstraint = [[NSMutableArray alloc] init];
        
        [buttonConstraint addObject:[NSLayoutConstraint constraintWithItem:_collectionButton
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0.0f]];
        [buttonConstraint addObject:[NSLayoutConstraint constraintWithItem:_collectionButton
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_totalButton
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f constant:0.0f]];
        [buttonConstraint addObject:[NSLayoutConstraint constraintWithItem:_collectionButton
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f constant:0.0f]];
        [buttonConstraint addObject:[NSLayoutConstraint constraintWithItem:_collectionButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:40.0f]];
        
        [self.view addConstraints:buttonConstraint];
        
    }
}

- (void) initTotalImageView {
    if (!_totalImageView) {
        _totalImageView = [[UIImageView alloc] initForAutolayout];
        _totalImageView.image = [UIImage imageNamed:@"icon_whole"];
        [_totalButton addSubview:_totalImageView];
        
        NSMutableArray *imageViewConstraint = [[NSMutableArray alloc] init];
        
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_totalImageView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_totalButton
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_totalImageView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_totalButton
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f constant:-25.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_totalImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:20.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_totalImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_totalImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:imageViewConstraint];
        
    }
}

- (void) initCollectionImageView {
    if (!_collectionImageView) {
        _collectionImageView = [[UIImageView alloc] initForAutolayout];
        _collectionImageView.image = [UIImage imageNamed:@"icon_collect"];
        [_collectionButton addSubview:_collectionImageView];
        
        NSMutableArray *imageViewConstraint = [[NSMutableArray alloc] init];
        
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_collectionImageView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_collectionButton
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_collectionImageView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_collectionButton
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f constant:-25.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_collectionImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:20.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_collectionImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_collectionImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:imageViewConstraint];
        
    }

}

- (void) initRecipeTableView {
    if (!_recipeTableView) {
        _recipeTableView                 = [[UITableView alloc] initForAutolayout];
        _recipeTableView.backgroundColor = [UIColor colorWithHexString:@"#ecf8f7"];
        _recipeTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _recipeTableView.dataSource      = self;
        _recipeTableView.delegate        = self;
        [self.view addSubview:_recipeTableView];
        
        NSMutableArray *tableViewConstraint = [[NSMutableArray alloc] init];
        
        [tableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeTableView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_totalButton
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:0.0f]];
        [tableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeTableView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0f constant:0.0f]];
        [tableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeTableView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f constant:0.0f]];
        [tableViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeTableView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:tableViewConstraint];
    }
    [_recipeTableView reloadData];
}

- (void) initRecipeMenuLayout {
    [self initRecipeMenuView];
    [self initRecipeMenuButton];
    [self initRecipeFanzytvLogoView];
    [self initRecipeFanzytvLogo];
}


- (void) initRecipeMenuView {
    if (!_recipeMenuView) {
        _recipeMenuView                 = [[UIView alloc] initForAutolayout];
        _recipeMenuView.backgroundColor = [UIColor colorWithHexString:@"#2a7372"];
        
        [self.view addSubview:_recipeMenuView];
        
        NSMutableArray *menuViewConstraint = [[NSMutableArray alloc] init];
        
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeMenuView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kScreenWidth*3/5]];
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeMenuView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f constant:0.0f]];
        [menuViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeMenuView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0f constant:0.0f]];
        
        _recipeMenuViewLeftLayoutConstraint = [NSLayoutConstraint constraintWithItem:_recipeMenuView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f];
        
        [self.view addConstraints:menuViewConstraint];
        [self.view addConstraint:_recipeMenuViewLeftLayoutConstraint];
        
    }
}


- (void)initRecipeMenuButton {
    NSArray *buttonArray = @[@"分類",@"全 部",@"西 式",@"中華料理",@"甜 點",@"家 常"];
    for (int i = 0; i < buttonArray.count; i++) {
        _recipeMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recipeMenuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _recipeMenuButton.tag = i;
        [_recipeMenuButton addTarget:self action:@selector(recideMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _recipeMenuButton.layer.borderWidth = 0.5f;
        _recipeMenuButton.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
        [_recipeMenuButton setTitle:buttonArray[i] forState:UIControlStateNormal];
        [_recipeMenuButton setTitleColor:[UIColor colorWithR:255 G:255 B:255] forState:UIControlStateNormal];
        _recipeMenuButton.titleLabel.font     = [UIFont systemFontOfSize:18];
        [_recipeMenuView addSubview:_recipeMenuButton];
        
        NSMutableArray *menuButtonConstaint = @[].mutableCopy;
        
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_recipeMenuButton
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_recipeMenuView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:0.0f]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_recipeMenuButton
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_recipeMenuView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:i*kFrameHeight*55/600]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_recipeMenuButton
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:kFrameHeight*55/600]];
        [menuButtonConstaint addObject:[NSLayoutConstraint constraintWithItem:_recipeMenuButton
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_recipeMenuView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:menuButtonConstaint];
        
    }
    
}

- (void) initRecipeFanzytvLogoView {
    if (!_fanzytvLogoView) {
        _fanzytvLogoView                 = [[UIView alloc] initForAutolayout];
        [_recipeMenuView addSubview:_fanzytvLogoView];
        
        NSMutableArray *fanzytvLogoConstaint = @[].mutableCopy;
        
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_recipeMenuView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_recipeMenuView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:100.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_recipeMenuView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        
        [self.view addConstraints:fanzytvLogoConstaint];
        
        
    }
}


- (void) initRecipeFanzytvLogo {
    if (!_fanzytvLogo) {
        _fanzytvLogo = [[UIImageView alloc] initForAutolayout];
        _fanzytvLogo.backgroundColor = [UIColor clearColor];
        _fanzytvLogo.image = [UIImage imageNamed:@"fanzytv_btn@2x"];
        
        [_fanzytvLogoView addSubview:_fanzytvLogo];
        
        NSMutableArray *fanzytvLogoConstaint = @[].mutableCopy;
        
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogo
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:20.0f]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogo
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:kFrameHeight*20/600]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogo
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:-kFrameHeight*20/600]];
        [fanzytvLogoConstaint addObject:[NSLayoutConstraint constraintWithItem:_fanzytvLogo
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_fanzytvLogoView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:-20.0f]];
        
        [self.view addConstraints:fanzytvLogoConstaint];
        
    }
}

#pragma mark - button action
- (void)recideMenuButtonClicked:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            NSLog(@"%lu",button.tag);
            break;
        } case 1: {
            NSLog(@"%lu",button.tag);
            break;
        } case 2: {
            NSLog(@"%lu",button.tag);
            break;
        } case 3: {
            NSLog(@"%lu",button.tag);
            break;
        } case 4: {
            NSLog(@"%lu",button.tag);
            break;
        } case 5: {
            NSLog(@"%lu",button.tag);
            break;
        }
        default:
            break;
    }
    
}


- (void)recipeMenuButtonPressed:(id)sender {
    [self.view removeConstraint:_recipeMenuViewLeftLayoutConstraint];
    if (_isShownRecipeMenuView) {
        [self dismissRecipeMenu];
    } else {
        if (self.isShownMenuView) {
            [self dismissMenu];
        }
        [self showRecipeMenu];
    }
    
}

- (void) dismissRecipeMenu {
    _isShownRecipeMenuView = NO;
    [self.view removeConstraint:_recipeMenuViewLeftLayoutConstraint];
    [UIView animateWithDuration:0.5
                     animations:^{
                         _recipeMenuViewLeftLayoutConstraint = [NSLayoutConstraint constraintWithItem:_recipeMenuView
                                                                                       attribute:NSLayoutAttributeLeft
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.view
                                                                                       attribute:NSLayoutAttributeRight
                                                                                      multiplier:1.0f constant:0.0f];
                         
                         [self.view addConstraint:_recipeMenuViewLeftLayoutConstraint];
                         [self.view layoutIfNeeded];
                     }];
    
}

- (void) showRecipeMenu {
    _isShownRecipeMenuView = YES;
    [UIView animateWithDuration:0.5
                     animations:^{
                         _recipeMenuViewLeftLayoutConstraint = [NSLayoutConstraint constraintWithItem:_recipeMenuView
                                                                                            attribute:NSLayoutAttributeLeft
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:self.view
                                                                                            attribute:NSLayoutAttributeRight
                                                                                           multiplier:1.0f constant:-kScreenWidth*3/5];
                         
                         [self.view addConstraint:_recipeMenuViewLeftLayoutConstraint];
                         [self.view layoutIfNeeded];
                     }];

}

- (void) showMenu {
    if (_isShownRecipeMenuView) {
        [self dismissRecipeMenu];
    }
    self.isShownMenuView = YES;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.menuViewRightLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.menuView
                                                                                       attribute:NSLayoutAttributeRight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self.view
                                                                                       attribute:NSLayoutAttributeLeft
                                                                                      multiplier:1.0f constant:kScreenWidth*3/5];
                         
                         [self.view addConstraint:self.menuViewRightLayoutConstraint];
                         [self.view layoutIfNeeded];
                     }];

}

- (void) totalButtonPressed:(id)sender {
    if ([_recipeType isEqualToString:@"collection"]) {
        _recipeDataArray = @[].mutableCopy;
        for (int i = 0; i < 10; i ++) {
            [_recipeDataArray addObject:@"total"];
        }
        _recipeType = @"total";
        [_recipeTableView reloadData];
    }
}

- (void) collectionButtonPressed:(id)sender {
    if ([_recipeType isEqualToString:@"total"]) {
        _recipeDataArray = @[].mutableCopy;
        for (int i = 0; i < 10; i ++) {
            [_recipeDataArray addObject:@"collection"];
        }
        _recipeType = @"collection";
        [_recipeTableView reloadData];
    }
}

#pragma mark - UITableView data source and delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return _recipeDataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 15 + (kScreenWidth-30-5)*3.0f/4.0f + 7.8f + 43.0f + 5.0f + 30.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FrontpageTableViewCell";
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[RecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.string = _recipeDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
