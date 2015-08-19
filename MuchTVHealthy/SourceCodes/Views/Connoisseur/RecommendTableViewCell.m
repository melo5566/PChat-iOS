//
//  RecommendTableViewCell.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/18.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "RecommendTableViewCell.h"
@interface RecommendTableViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView        *recommendListTableView;
@property (nonatomic,strong) UIView             *topBorder;
@property (nonatomic,strong) UILabel            *recommendListTitleLabel;
@property (nonatomic,strong) UIImageView        *productRightButtonImage;
@property (nonatomic,strong) UIImageView        *productImageView;
@property (nonatomic,strong) UILabel            *productTitleLabel;
@property (nonatomic,strong) UILabel            *productSizeLabel;
@property (nonatomic,strong) UILabel            *productPriceLabel;

@end


@implementation RecommendTableViewCell

- (void) setRecommendList:(NSMutableArray *)recommendList {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    _recommendList = recommendList;
    [self initRecommendListTableView];
    
}

- (void) setConnoisseurRecommendDataObject:(ConnoisseurRecommendDataObject *)connoisseurRecommendDataObject {
    _connoisseurRecommendDataObject = connoisseurRecommendDataObject;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initProductImageView];
    [self initProductTitleLabel];
    [self initProductSizeLabel];
    [self initProductPriceLabel];
    [self initProductRightButtonImage];
    [self initTopBorder];
    
}

- (void) initProductImageView {
    if(!_productImageView) {
        _productImageView = [[UIImageView alloc]initForAutolayout];
        _productImageView.contentMode        = UIViewContentModeScaleAspectFill;
        _productImageView.clipsToBounds      = YES;
        [self.contentView insertSubview:_productImageView atIndex:0];
        NSMutableArray *productImageConstraint = [[NSMutableArray alloc] init];
        [productImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_productImageView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:0.0f]];
        [productImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_productImageView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kConnoisseurRecommendListCellheight]];
        [productImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_productImageView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:0.0f]];
        [productImageConstraint addObject:[NSLayoutConstraint constraintWithItem:_productImageView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f constant:kConnoisseurRecommendListCellheight]];
        [self.contentView addConstraints:productImageConstraint];
    }
    __block __typeof (UIImageView *)ConnoisseurProductImageView = _productImageView;
    [_productImageView setImageWithURL:[NSURL URLWithString:_connoisseurRecommendDataObject.productImage]
                     withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderWide]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    if(!image) {
                                        [ConnoisseurProductImageView setImage:[UIImage imageNamed: kImageNamePresetNormal]];
                                    }}
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}
- (void) initProductTitleLabel {
    if(!_productTitleLabel) {
        _productTitleLabel                  = [[UILabel alloc]initForAutolayout];
        _productTitleLabel.backgroundColor  = [UIColor clearColor];
        _productTitleLabel.textColor        = [UIColor colorWithHexString:kConnoisseurRecommendTitleColor];
        _productTitleLabel.font             = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurRecommendTitleFontSize];
        [self.contentView addSubview:_productTitleLabel];
        NSMutableArray *productTitleConstraints = @[].mutableCopy;
        [productTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productTitleLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:15.0f]];
        [productTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productTitleLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_productImageView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:25/3]];
        [productTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productTitleLabel
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0f constant:16.0]];
        [productTitleConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productTitleLabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:-kConnoisseurRecommendLabelRightPadding]];
        [self.contentView addConstraints:productTitleConstraints];

    }
    _productTitleLabel.text = _connoisseurRecommendDataObject.productName;
}

- (void) initProductSizeLabel {
    if(!_productSizeLabel) {
        _productSizeLabel = [[UILabel alloc]initForAutolayout];
        _productSizeLabel.backgroundColor  = [UIColor clearColor];
        _productSizeLabel.textColor        = [UIColor colorWithHexString:kConnoisseurRecommendTitleColor];
        _productSizeLabel.font             = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurRecommendTitleFontSize];
        [self.contentView addSubview:_productSizeLabel];
        NSMutableArray *productSizeConstraints = @[].mutableCopy;
        [productSizeConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productSizeLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_productTitleLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:20/3]];
        [productSizeConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productSizeLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_productImageView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:25/3]];
        [productSizeConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productSizeLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:16.0]];
        [productSizeConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productSizeLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-kConnoisseurRecommendLabelRightPadding]];
        [self.contentView addConstraints:productSizeConstraints];

    }
    _productSizeLabel.text = _connoisseurRecommendDataObject.productSize;
}

- (void) initProductPriceLabel {
    if(!_productPriceLabel) {
        _productPriceLabel = [[UILabel alloc]initForAutolayout];
        _productPriceLabel.backgroundColor  = [UIColor clearColor];
        _productPriceLabel.textColor        = [UIColor colorWithHexString:kConnoisseurRecommendPriceColor];
        _productPriceLabel.font             = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurRecommendPriceFontSize];
        [self.contentView addSubview:_productPriceLabel];
        NSMutableArray *productPriceConstraints = @[].mutableCopy;
        [productPriceConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productPriceLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_productSizeLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:20/3]];
        [productPriceConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productPriceLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_productImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:25/3]];
        [productPriceConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productPriceLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:16.0]];
        [productPriceConstraints addObject:[NSLayoutConstraint  constraintWithItem:_productPriceLabel
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-kConnoisseurRecommendLabelRightPadding]];
        [self.contentView addConstraints:productPriceConstraints];

    }
    _productPriceLabel.text = _connoisseurRecommendDataObject.productPrice;
}

- (void) initProductRightButtonImage {
    if(!_productRightButtonImage) {
        _productRightButtonImage = [[UIImageView alloc]initForAutolayout];
        _productRightButtonImage.image = [UIImage imageNamed:@"icon_go"];
        [self.contentView addSubview:_productRightButtonImage];
        NSMutableArray *productRightButtonImageViewConstraint = [[NSMutableArray alloc] init];
        [productRightButtonImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_productRightButtonImage
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:-18.0f]];
        [productRightButtonImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_productRightButtonImage
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:32.0f]];
        [productRightButtonImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_productRightButtonImage
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kConnoisseurRecommendLabelRightPadding-18]];
        [productRightButtonImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_productRightButtonImage
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kConnoisseurRecommendLabelRightPadding-13]];
        
        [self.contentView addConstraints:productRightButtonImageViewConstraint];

    }
}
- (void) initRecommendListTableView {
    if(!_recommendListTableView) {
        _recommendListTableView = [[UITableView alloc]initForAutolayout];
        _recommendListTableView.backgroundColor = [UIColor clearColor];
        _recommendListTableView.delegate = self;
        _recommendListTableView.dataSource = self;
        _recommendListTableView.scrollEnabled = NO;
        _recommendListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_recommendListTableView.layer setShadowColor:[UIColor blackColor].CGColor];
        _recommendListTableView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        _recommendListTableView.layer.shadowOpacity = 0.5;
        
        [self.contentView addSubview:_recommendListTableView];
        NSMutableArray *tableviewconstraints = @[].mutableCopy;
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_recommendListTableView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_recommendListTableView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:0.0f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_recommendListTableView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:-9.3f]];
        [tableviewconstraints addObject:[NSLayoutConstraint  constraintWithItem:_recommendListTableView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        [self.contentView addConstraints:tableviewconstraints];

    }
}

- (void) initRecommendListTitleLabel {
    if(!_recommendListTitleLabel) {
        _recommendListTitleLabel = [[UILabel alloc]initForAutolayout];
        _recommendListTitleLabel.backgroundColor = [UIColor clearColor];
        _recommendListTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:kConnoisseurPostDiscussionTitleFontSize];
        _recommendListTitleLabel.textColor = [UIColor colorWithHexString:kConnoisseurSinglePagePostDicussionTextColor];
        [self.contentView addSubview:_recommendListTitleLabel];
        NSMutableArray *recommendTitleLabelconstraints = @[].mutableCopy;
        [recommendTitleLabelconstraints addObject:[NSLayoutConstraint  constraintWithItem:_recommendListTitleLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f constant:20/3]];
        [recommendTitleLabelconstraints addObject:[NSLayoutConstraint  constraintWithItem:_recommendListTitleLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f constant:10.0f]];
        [recommendTitleLabelconstraints addObject:[NSLayoutConstraint  constraintWithItem:_recommendListTitleLabel
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0f constant:0.0f]];
        [recommendTitleLabelconstraints addObject:[NSLayoutConstraint  constraintWithItem:_recommendListTitleLabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f constant:0.0f]];
        _recommendListTitleLabel.text = @"達人推薦";
        [self.contentView addConstraints:recommendTitleLabelconstraints];

    }
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (_hasMoreRecommend) {
        return _recommendList.count + 2;
    } else {
        return _recommendList.count + 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0||indexPath.row == _recommendList.count + 1) {
        return 100/3;
    }
    else {
        return kConnoisseurRecommendListCellheight;
    }
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        static NSString *cellID = @"recommendTitleTableViewCell";
        RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        if (!cell) {
            cell = [[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initRecommendListTitleLabel];
        return cell;
    }
    else if (indexPath.row == _recommendList.count+1) {
        static NSString *cellID = @"recommendMoreTableViewCell";
        RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.contentMode = UIViewContentModeCenter;
            UIImageView *loadMoreImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kDiscussionCardLeftAndRightPadding * 2 - 20) / 2, 12, 20, 15)];
            loadMoreImage.backgroundColor = [UIColor clearColor];
            [loadMoreImage setImage:[UIImage imageNamed:@"icon_more"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:loadMoreImage];
            [cell initTopBorder];
        }
        return cell;
    }
    else {
        static NSString *cellID = @"recommendTableViewCell";
        RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        if (!cell) {
            cell = [[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell initTopBorder];
        cell.connoisseurRecommendDataObject = _recommendList[indexPath.row-1];
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
