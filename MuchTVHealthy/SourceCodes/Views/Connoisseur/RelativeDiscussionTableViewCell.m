//
//  RelativeDiscussionTableViewCell.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/14.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "RelativeDiscussionTableViewCell.h"

@interface RelativeDiscussionTableViewCell() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView        *relativeDiscussionListTableView;
@property (nonatomic,strong) UILabel            *postRelativeDiscussion;
@property (nonatomic,strong) UIButton           *postRelativeDiscussionButton;
@property (nonatomic,strong) UIImageView        *postRelativeDiscussionButtonIcon;
@property (nonatomic,strong) UILabel            *postRelativeDiscussionButtonTitle;
@property (nonatomic,strong) UIImageView        *discussionImageView;
@property (nonatomic,strong) UIImageView        *discussionDateImageView;
@property (nonatomic,strong) UILabel            *discussionTitleLabel;
@property (nonatomic,strong) UILabel            *discussionDateLabel;
@property (nonatomic,strong) UIView             *topBorder;


@end

@implementation RelativeDiscussionTableViewCell

- (void) setRelativeDiscussionList:(NSMutableArray *)relativeDiscussionList {
    _relativeDiscussionList = relativeDiscussionList ;
    self.backgroundColor=[UIColor clearColor];
    [self initRelativeDicussionListTableview];
}

- (void) setConnoisseurDiscussionDataObject:(ConnoisseurDiscussionDataObject *)connoisseurDiscussionDataObject {
    _connoisseurDiscussionDataObject = connoisseurDiscussionDataObject;
    [self initDiscussionImageView];
    [self initDiscussionTitleLabel];
    [self initDiscussionDateImageView];
    [self initDiscussionDateLabel];
}

- (void) initDiscussionImageView {
    if(!_discussionImageView) {
        _discussionImageView = [[UIImageView alloc]initForAutolayout];
        _discussionImageView.contentMode        = UIViewContentModeScaleAspectFill;
        _discussionImageView.clipsToBounds      = YES;
        [self.contentView addSubview:_discussionImageView];
        NSMutableArray *discussionImageConstraint = [[NSMutableArray alloc] init];
        [discussionImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionImageView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:kConnoisseurDiscussionImageViewLeftPadding]];
        [discussionImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionImageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:kConnoisseurDiscussionImageViewWidth]];
        [discussionImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionImageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:kConnoisseurDiscussionImageViewTopPadding]];
        [discussionImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionImageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:kConnoisseurDiscussionImageViewHeight]];
        _discussionImageView.layer.cornerRadius = kConnoisseurDiscussionImageViewHeight/2;
        [self.contentView addConstraints:discussionImageConstraint];
    }
    __block __typeof (UIImageView *)ConnoisseurDiscussionImageView = _discussionImageView;
    [_discussionImageView setImageWithURL:[NSURL URLWithString:_connoisseurDiscussionDataObject.discussionImageUrl]
           withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderWide]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                          if(!image) {
                              [ConnoisseurDiscussionImageView setImage:[UIImage imageNamed: kImageNamePresetNormal]];
                          }}
    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void) initDiscussionTitleLabel {
    if (!_discussionTitleLabel) {
        _discussionTitleLabel           = [[UILabel alloc]initForAutolayout];
        _discussionTitleLabel.backgroundColor = [UIColor clearColor];
        _discussionTitleLabel.text      = _connoisseurDiscussionDataObject.discussionTitle;
        _discussionTitleLabel.textColor = [UIColor colorWithHexString:kConnoisseurDiscussionTitleColor];
        _discussionTitleLabel.font      = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurDiscussionTitleFontSize];
        NSLog(@"%@",_connoisseurDiscussionDataObject.discussionTitle);
        _discussionTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:_discussionTitleLabel];
        NSMutableArray *discussionTitleLabelConstraint = [[NSMutableArray alloc] init];
        [discussionTitleLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionTitleLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_discussionImageView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:10.0f]];
        [discussionTitleLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionTitleLabel
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-kConnoisseurDiscussionTitleLabelRightPadding]];
        [discussionTitleLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionTitleLabel
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:kConnoisseurDiscussionTitleLabelTopPadding]];
        [discussionTitleLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionTitleLabel
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kConnoisseurDiscussionTitleLabelHeight]];
        [self.contentView addConstraints:discussionTitleLabelConstraint];
    }
}

- (void) initDiscussionDateImageView {
    if(!_discussionDateImageView) {
        _discussionDateImageView = [[UIImageView alloc]initForAutolayout];
        _discussionDateImageView.image = [UIImage imageNamed:@"icon_time"];
        [self.contentView addSubview:_discussionDateImageView];
        NSMutableArray *timeImageViewConstraint = [[NSMutableArray alloc] init];
        [timeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionDateImageView
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_discussionImageView
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:10.0f]];
        [timeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionDateImageView
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_discussionTitleLabel
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f constant:10.0f]];
        [timeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionDateImageView
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:10.5f]];
        [timeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionDateImageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:10.5f]];
        
        [self.contentView addConstraints:timeImageViewConstraint];
    }
}
- (void) initDiscussionDateLabel {
    if (!_discussionDateLabel) {
        _discussionDateLabel        = [[UILabel alloc]initForAutolayout];
        _discussionDateLabel.text  = _connoisseurDiscussionDataObject.discussionDate;
        _discussionDateLabel.textColor = [UIColor colorWithHexString:kConnoisseurDiscussionDateColor];
        _discussionDateLabel.font      = [UIFont fontWithName:@"Arial" size:kConnoisseurDiscussionDateFontSize];
         [self.contentView addSubview:_discussionDateLabel];
        NSMutableArray *discussionDateLabelConstraint = [[NSMutableArray alloc] init];
        [discussionDateLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionDateLabel
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_discussionDateImageView
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:7.0f]];
        [discussionDateLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionDateLabel
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_discussionTitleLabel
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f constant:10.0f]];
        [discussionDateLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionDateLabel
                                                                            attribute:NSLayoutAttributeRight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.contentView
                                                                            attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:0.0f]];
        [discussionDateLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_discussionDateLabel
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:10.5f]];
        
        [self.contentView addConstraints:discussionDateLabelConstraint];

    }
    
}


- (void) initRelativeDicussionListTableview {
    if(!_relativeDiscussionListTableView) {
        _relativeDiscussionListTableView = [[UITableView alloc]initForAutolayout];
        _relativeDiscussionListTableView.backgroundColor = [UIColor clearColor];
        _relativeDiscussionListTableView.delegate = self;
        _relativeDiscussionListTableView.dataSource = self;
        _relativeDiscussionListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_relativeDiscussionListTableView.layer setShadowColor:[UIColor blackColor].CGColor];
        _relativeDiscussionListTableView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        _relativeDiscussionListTableView.layer.shadowOpacity = 0.5;

        [self.contentView addSubview:_relativeDiscussionListTableView];
        NSMutableArray *tableviewconstraints = @[].mutableCopy;
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_relativeDiscussionListTableView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_relativeDiscussionListTableView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_relativeDiscussionListTableView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:-9.3f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_relativeDiscussionListTableView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraints:tableviewconstraints];
    }
}

- (void)initPostDicussionButtonLayout {
    if(!_postRelativeDiscussion) {
        _postRelativeDiscussion = [[UILabel alloc]initForAutolayout];
        _postRelativeDiscussion.text = @"相關討論";
        _postRelativeDiscussion.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurPostDiscussionTitleFontSize];
        _postRelativeDiscussion.backgroundColor = [UIColor clearColor];
        _postRelativeDiscussion.textColor = [UIColor colorWithHexString:kConnoisseurSinglePagePostDicussionTextColor];
        [self.contentView addSubview:_postRelativeDiscussion];
        NSMutableArray *postRelativeDiscussionConstraint = [[NSMutableArray alloc] init];
        
        [postRelativeDiscussionConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussion
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:10.0f]];
        [postRelativeDiscussionConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussion
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:-10.0f]];
        [postRelativeDiscussionConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussion
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:20/3]];
        [postRelativeDiscussionConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussion
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:23.0f]];
        [self.contentView addConstraints:postRelativeDiscussionConstraint];
    }
    if(!_postRelativeDiscussionButton) {
        _postRelativeDiscussionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postRelativeDiscussionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _postRelativeDiscussionButton.backgroundColor = [UIColor whiteColor];
        _postRelativeDiscussionButton.layer.borderWidth  = 1.0f;
        _postRelativeDiscussionButton.layer.borderColor  = [UIColor colorWithHexString:kConnoisseurSinglePagePostDicussionTextColor].CGColor;
        _postRelativeDiscussionButton.layer.cornerRadius = 20.0f;

        [self.contentView addSubview:_postRelativeDiscussionButton];
        
        NSMutableArray *postButtonConstraint = [[NSMutableArray alloc] init];
        
        [postButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:25/3]];
        [postButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButton
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:-25/3]];
        [postButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButton
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_postRelativeDiscussion
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:35/3]];
        [postButtonConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButton
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f constant:40.0f]];
        
        [self.contentView addConstraints:postButtonConstraint];
    }
    if(!_postRelativeDiscussionButtonTitle) {
        _postRelativeDiscussionButtonTitle = [[UILabel alloc]initForAutolayout];
        _postRelativeDiscussionButtonTitle.text = @"發表討論";
        _postRelativeDiscussionButtonTitle.textColor = [UIColor colorWithHexString: kConnoisseurSinglePagePostDicussionTextColor];
        _postRelativeDiscussionButtonTitle.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurPostDiscussionButtonTitleFontSize];
        _postRelativeDiscussionButtonTitle.backgroundColor = [UIColor clearColor];
        [_postRelativeDiscussionButton addSubview:_postRelativeDiscussionButtonTitle];
        NSMutableArray *postButtonTitleConstraint = [[NSMutableArray alloc] init];
        [postButtonTitleConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButtonTitle
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_postRelativeDiscussionButton
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:kScreenWidth/2-kConnousseurPostDiscussionButtonTitleLeftPadding]];
        [postButtonTitleConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButtonTitle
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_postRelativeDiscussionButton
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:0.0f]];
        [postButtonTitleConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButtonTitle
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_postRelativeDiscussionButton
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:-35/3]];
        [postButtonTitleConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButtonTitle
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_postRelativeDiscussionButton
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:35/3]];
        
        [_postRelativeDiscussionButton addConstraints:postButtonTitleConstraint];
        
    }
    if(!_postRelativeDiscussionButtonIcon) {
        _postRelativeDiscussionButtonIcon = [[UIImageView alloc]initForAutolayout];
        _postRelativeDiscussionButtonIcon.backgroundColor = [UIColor clearColor];
        _postRelativeDiscussionButtonIcon.contentMode        = UIViewContentModeScaleAspectFill;
        _postRelativeDiscussionButtonIcon.clipsToBounds      = YES;
        [_postRelativeDiscussionButtonIcon setImage:[UIImage imageNamed:@"icon_issue"]];
        [_postRelativeDiscussionButton addSubview:_postRelativeDiscussionButtonIcon];
        NSMutableArray *postButtonIconConstraint = [[NSMutableArray alloc] init];
        
        [postButtonIconConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButtonIcon
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_postRelativeDiscussionButtonTitle
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:-10.0f]];
        [postButtonIconConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButtonIcon
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f constant:40-2*35/3]];
        [postButtonIconConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButtonIcon
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_postRelativeDiscussionButton
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:35/3]];
        [postButtonIconConstraint addObject:[NSLayoutConstraint constraintWithItem:_postRelativeDiscussionButtonIcon
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_postRelativeDiscussionButton
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:-35/3]];
        
        [_postRelativeDiscussionButton addConstraints:postButtonIconConstraint];

    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (_hasMoreDicussion) {
        return _relativeDiscussionList.count + 2;
    } else {
        return _relativeDiscussionList.count + 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _relativeDiscussionList.count + 1) {
        return 100/3;
    }
    else {
        return 265/3;
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row == 0) {
        static NSString *cellID = @"postDiscussionTableViewCell";
        RelativeDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        if (!cell) {
            cell = [[RelativeDiscussionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initPostDicussionButtonLayout];
        return cell;
    }
    else if (indexPath.row == _relativeDiscussionList.count+1) {
        static NSString *cellID = @"relativeDiscussionMoreTableViewCell";
        RelativeDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[RelativeDiscussionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cell initTopBorder];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.contentMode = UIViewContentModeCenter;
            UIImageView *loadMoreImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kDiscussionCardLeftAndRightPadding * 2 - 20) / 2, 12, 20, 15)];
            loadMoreImage.backgroundColor = [UIColor clearColor];
            [loadMoreImage setImage:[UIImage imageNamed:@"icon_more"]];
            [cell.contentView addSubview:loadMoreImage];
        }
        return cell;
    }
    else {
        static NSString *cellID = @"relativeDiscussionTableViewCell";
        RelativeDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        if (!cell) {
            cell = [[RelativeDiscussionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initTopBorder];
        cell.connoisseurDiscussionDataObject = _relativeDiscussionList[indexPath.row-1];
        return cell;
    }
    
}

- (void) initTopBorder {
    if(!_topBorder) {
        _topBorder = [[UIView alloc]initForAutolayout];
        _topBorder.frame = CGRectMake(0, 0,kScreenWidth, 2);
        _topBorder.backgroundColor = [UIColor colorWithHexString:kConnoisseurSinglePageDiscussionCellBorderColor];
        [self.contentView addSubview:_topBorder];
    }
}

@end
