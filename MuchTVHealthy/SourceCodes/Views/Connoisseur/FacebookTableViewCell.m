//
//  FacebookTableViewCell.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/19.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "FacebookTableViewCell.h"
@interface FacebookTableViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView        *facebookListTableView;
@property (nonatomic,strong) UIView             *topBorder;
@property (nonatomic,strong) UILabel            *facebookListTitleLabel;
@property (nonatomic,strong) UIImageView        *facebookImageView;
@property (nonatomic,strong) UILabel            *facebookTitleLabel;
@property (nonatomic,strong) UILabel            *facebookTimeLabel;
@property (nonatomic,strong) UIImageView        *facebookTimeImageView;


@end
@implementation FacebookTableViewCell

- (void) setFacebookList:(NSMutableArray *)facebookList {
    _facebookList = facebookList;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    _facebookList = facebookList;
    [self initFacebookListTablelView];
    
}

- (void) setConnoisseurFacebookDataObject:(ConnoisseurFacebookDataObject *)connoisseurFacebookDataObject {
    _connoisseurFacebookDataObject = connoisseurFacebookDataObject;
    [self initFacebookImageView];
    [self initFacebookTitleLabel];
    [self initFacebookTimeImageView];
    [self initFacebookTimeLabel];
    [self initTopBorder];
}

- (void) initFacebookListTablelView {
    if (!_facebookListTableView) {
        _facebookListTableView = [[UITableView alloc]initForAutolayout];
        _facebookListTableView.backgroundColor = [UIColor clearColor];
        _facebookListTableView.delegate = self;
        _facebookListTableView.dataSource = self;
        _facebookListTableView.scrollEnabled = NO;
        _facebookListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_facebookListTableView.layer setShadowColor:[UIColor blackColor].CGColor];
        _facebookListTableView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        _facebookListTableView.layer.shadowOpacity = 0.5;
        [self.contentView addSubview:_facebookListTableView];
        NSMutableArray *tableviewconstraints = @[].mutableCopy;
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookListTableView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookListTableView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookListTableView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:-9.3f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookListTableView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraints:tableviewconstraints];
    }
}

- (void) initFacebookListTitleLabel {
    if(!_facebookListTitleLabel) {
        _facebookListTitleLabel = [[UILabel alloc]initForAutolayout];
        _facebookListTitleLabel.backgroundColor = [UIColor clearColor];
        _facebookListTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurPostDiscussionTitleFontSize];
        _facebookListTitleLabel.textColor = [UIColor colorWithHexString:kConnoisseurSinglePagePostDicussionTextColor];
        [self.contentView addSubview:_facebookListTitleLabel];
        NSMutableArray *facebookTitleLabelconstraints = @[].mutableCopy;
        [facebookTitleLabelconstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookListTitleLabel
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.contentView
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.0f constant:20/3]];
        [facebookTitleLabelconstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookListTitleLabel
                                                                                attribute:NSLayoutAttributeLeft
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.contentView
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:1.0f constant:10.0f]];
        [facebookTitleLabelconstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookListTitleLabel
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.contentView
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1.0f constant:0.0f]];
        [facebookTitleLabelconstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookListTitleLabel
                                                                                attribute:NSLayoutAttributeRight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.contentView
                                                                                attribute:NSLayoutAttributeRight
                                                                               multiplier:1.0f constant:0.0f]];
        _facebookListTitleLabel.text = @"達人Facebook";
        [self.contentView addConstraints:facebookTitleLabelconstraints];
        
    }
}


- (void) initFacebookImageView {
    if (!_facebookImageView) {
        _facebookImageView = [[UIImageView alloc]initForAutolayout];
        _facebookImageView.contentMode        = UIViewContentModeScaleAspectFill;
        _facebookImageView.clipsToBounds      = YES;
        [self.contentView insertSubview:_facebookImageView atIndex:0];
        NSMutableArray *facebookImageConstraint = [[NSMutableArray alloc] init];
        [facebookImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookImageView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.contentView
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0f constant:0.0f]];
        [facebookImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookImageView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0f constant:kConnoisseurFacebookListCellheight]];
        [facebookImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookImageView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.contentView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0f constant:0.0f]];
        [facebookImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookImageView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0f constant:kConnoisseurFacebookListCellheight]];
        [self.contentView addConstraints:facebookImageConstraint];
    }
    __block __typeof (UIImageView *)ConnoisseurProductImageView = _facebookImageView;
    [_facebookImageView setImageWithURL:[NSURL URLWithString:_connoisseurFacebookDataObject.facebookImage]
                  withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderWide]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                 if(!image) {
                                     [ConnoisseurProductImageView setImage:[UIImage imageNamed: kImageNamePresetNormal]];
                                 }}
           usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

}

- (void) initFacebookTitleLabel {
    if (!_facebookTitleLabel) {
        _facebookTitleLabel = [[UILabel alloc]initForAutolayout];
        _facebookTitleLabel.backgroundColor  = [UIColor clearColor];
        _facebookTitleLabel.textColor        = [UIColor colorWithHexString:kConnoisseurRecommendTitleColor];
        _facebookTitleLabel.font             = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurRecommendTitleFontSize];
        _facebookTitleLabel.numberOfLines    = 2;
        [self.contentView addSubview:_facebookTitleLabel];
        NSMutableArray *facebookTitleConstraints = @[].mutableCopy;
        [facebookTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookTitleLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:15.0f]];
        [facebookTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookTitleLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_facebookImageView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:25/3]];
        [facebookTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookTitleLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:40.0]];
        [facebookTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_facebookTitleLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-30.0]];
        [self.contentView addConstraints:facebookTitleConstraints];
    }
    _facebookTitleLabel.text = _connoisseurFacebookDataObject.facebookTitle;
}

- (void) initFacebookTimeImageView {
    if(!_facebookTimeImageView) {
        _facebookTimeImageView = [[UIImageView alloc]initForAutolayout];
        _facebookTimeImageView.image = [UIImage imageNamed:@"icon_time"];
        [self.contentView addSubview:_facebookTimeImageView];
        NSMutableArray *timeImageViewConstraint = [[NSMutableArray alloc] init];
        [timeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookTimeImageView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_facebookImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:10.0f]];
        [timeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookTimeImageView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_facebookTitleLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:20/3]];
        [timeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookTimeImageView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:10.5f]];
        [timeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookTimeImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:10.5f]];
        
        [self.contentView addConstraints:timeImageViewConstraint];
    }
}


- (void) initFacebookTimeLabel {
    if (!_facebookTimeLabel) {
        _facebookTimeLabel = [[UILabel alloc]initForAutolayout];
        _facebookTimeLabel.text  = _connoisseurFacebookDataObject.facebookTime;
        _facebookTimeLabel.textColor = [UIColor colorWithHexString:kConnoisseurDiscussionDateColor];
        _facebookTimeLabel.font      = [UIFont fontWithName:@"Arial" size:kConnoisseurDiscussionDateFontSize];
        [self.contentView addSubview:_facebookTimeLabel];
        NSMutableArray *facebookTimeLabelConstraint = [[NSMutableArray alloc] init];
        [facebookTimeLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookTimeLabel
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                               toItem:_facebookTimeImageView
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:7.0f]];
        [facebookTimeLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookTimeLabel
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:_facebookTitleLabel
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0f constant:20/3]];
        [facebookTimeLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookTimeLabel
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0f constant:0.0f]];
        [facebookTimeLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_facebookTimeLabel
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.0f constant:10.5f]];
        
        [self.contentView addConstraints:facebookTimeLabelConstraint];
        

    }
}


- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (_hasMoreFacebook) {
        return _facebookList.count + 2;
    } else {
        return _facebookList.count + 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0||indexPath.row == _facebookList.count + 1) {
        return 100/3;
    }
    else {
        return kConnoisseurFacebookListCellheight;
    }
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        static NSString *cellID = @"facebookTitleTableViewCell";
        FacebookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        if (!cell) {
            cell = [[FacebookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initFacebookListTitleLabel];
        return cell;
    }
    else if (indexPath.row == _facebookList.count+1) {
        static NSString *cellID = @"facebookMoreTableViewCell";
        FacebookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[FacebookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.contentMode = UIViewContentModeCenter;
            UIImageView *loadMoreImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kDiscussionCardLeftAndRightPadding * 2 - 20) / 2, 12, 20, 15)];
            loadMoreImage.backgroundColor = [UIColor clearColor];
            [loadMoreImage setImage:[UIImage imageNamed:@"icon_more"]];
            [cell.contentView addSubview:loadMoreImage];
            [cell initTopBorder];
        }
        return cell;
    }
    else {
        static NSString *cellID = @"facebookTableViewCell";
        FacebookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        if (!cell) {
            cell = [[FacebookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell initTopBorder];
        cell.connoisseurFacebookDataObject = _facebookList[indexPath.row-1];
        return cell;
    }
    
}

- (void) initTopBorder {
    if(!_topBorder) {
        _topBorder = [[UIView alloc]initForAutolayout];
        _topBorder.frame = CGRectMake(0, 0,kScreenWidth, 2);
        _topBorder.backgroundColor = [UIColor colorWithHexString:kConnoisseurSinglePageDiscussionCellBorderColor];
        [self.contentView insertSubview:_topBorder atIndex:1];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
