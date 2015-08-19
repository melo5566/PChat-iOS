//
//  AboutTableViewCell.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/18.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "AboutTableViewCell.h"
@interface AboutTableViewCell()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView        *aboutTableView;
@property (nonatomic,strong) UIView             *topBorder;
@property (nonatomic,strong) UILabel            *aboutTitleLabel;
@property (nonatomic,strong) UILabel            *aboutContentLabel;


@end



@implementation AboutTableViewCell


- (void) setAboutList:(NSMutableArray *)aboutList {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _aboutList = aboutList;
    self.backgroundColor = [UIColor clearColor];
    [self initAboutTableView];
}

- (void) initAboutTableView {
    if(!_aboutTableView) {
        _aboutTableView = [[UITableView alloc]initForAutolayout];
        _aboutTableView.delegate = self;
        _aboutTableView.dataSource = self;
        _aboutTableView.backgroundColor = [UIColor clearColor];
        _aboutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_aboutTableView.layer setShadowColor:[UIColor blackColor].CGColor];
        _aboutTableView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        _aboutTableView.layer.shadowOpacity = 0.5;
        _aboutTableView.scrollEnabled = NO;
        [self.contentView addSubview:_aboutTableView];
        NSMutableArray *tableviewconstraints = @[].mutableCopy;
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_aboutTableView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_aboutTableView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_aboutTableView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:-9.3f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_aboutTableView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraints:tableviewconstraints];        
    }
}

- (void) initTitleLabel {
    if(!_aboutTitleLabel) {
        _aboutTitleLabel = [[UILabel alloc]initForAutolayout];
        _aboutTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurAboutTitleFontSize];
        _aboutTitleLabel.textColor = [UIColor colorWithHexString:kConnoisseurAboutTitleColor];
        _aboutTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_aboutTitleLabel];
        NSMutableArray *aboutTitleConstraints = @[].mutableCopy;
        [aboutTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_aboutTitleLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:20/3]];
        [aboutTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_aboutTitleLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:10.0f]];
        [aboutTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_aboutTitleLabel
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:0.0f]];
        [aboutTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_aboutTitleLabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraints:aboutTitleConstraints];

        
    }
    _aboutTitleLabel.text = _connoisseurAboutDataObject.aboutTitle;
}

- (void) initContentLabel {
     if(!_aboutContentLabel) {
     CGFloat constrainedWidth = kScreenWidth-30;//YOU CAN PUT YOUR DESIRED ONE,THE MAXIMUM WIDTH OF YOUR LABEL.
     //CALCULATE THE SPACE FOR THE TEXT SPECIFIED.
        
     CGSize sizeOfText=[_connoisseurAboutDataObject.aboutContent sizeWithFont:[UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurAboutContentFontSize] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
         _aboutContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,constrainedWidth,sizeOfText.height)];
         _aboutContentLabel.textColor = [UIColor colorWithHexString:kConnoisseurAboutContentColor];
         _aboutContentLabel.backgroundColor = [UIColor clearColor];
         _aboutContentLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurAboutContentFontSize];
         _aboutContentLabel.numberOfLines=0;
         [self.contentView addSubview:_aboutContentLabel];
     }
     _aboutContentLabel.text = _connoisseurAboutDataObject.aboutContent;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100/3;
    }
    else {
        CGFloat constrainedWidth = kScreenWidth-30;
        ConnoisseurAboutDataObject *tmp = _aboutList[indexPath.row-1] ;
            CGSize sizeOfText=[tmp.aboutContent sizeWithFont:[UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurAboutContentFontSize] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        return sizeOfText.height+20;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row%2 == 0) {
        static NSString *cellID = @"AboutTitleTableViewCell";
        AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        if (!cell) {
            cell = [[AboutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.connoisseurAboutDataObject = _aboutList[indexPath.row];
        [cell initTitleLabel];
        return cell;
    }
    else {
        static NSString *cellID = @"AboutTableViewCell";
        AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        if (!cell) {
            cell = [[AboutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.connoisseurAboutDataObject = _aboutList[indexPath.row-1];
        [cell initTopBorder];
        [cell initContentLabel];
        return cell;
    }
    
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
        return _aboutList.count*2;
}


- (void) initTopBorder {
    if(!_topBorder) {
        _topBorder = [[UIView alloc]initForAutolayout];
        _topBorder.frame = CGRectMake(0, 0,kScreenWidth, 2);
        _topBorder.backgroundColor = [UIColor colorWithHexString:kConnoisseurSinglePageDiscussionCellBorderColor];
        [self.contentView addSubview:_topBorder];
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
