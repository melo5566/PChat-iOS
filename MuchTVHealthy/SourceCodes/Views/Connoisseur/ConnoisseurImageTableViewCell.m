//
//  ConnoisseurImageTableViewCell.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/14.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ConnoisseurImageTableViewCell.h"
@interface ConnoisseurImageTableViewCell()

@property (nonatomic,strong)UIImageView     *connoisseurImageView;
@property (nonatomic,strong)CALayer         *upBorderlayer;
@end

@implementation ConnoisseurImageTableViewCell

- (void)setConnoisseurDataObject:(ConnoisseurDataObject *)connoisseurDataObject {
    self.backgroundColor = [UIColor clearColor];
    _connoisseurDataObject = connoisseurDataObject;
    [self initImageView];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)initImageView {
    if(!_connoisseurImageView) {
        _connoisseurImageView = [[UIImageView alloc]initForAutolayout];
        _connoisseurImageView.contentMode = UIViewContentModeScaleAspectFill;
        _connoisseurImageView.clipsToBounds = YES;
        [self.contentView addSubview:_connoisseurImageView];
        NSMutableArray *imageViewConstraint = @[].mutableCopy;
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_connoisseurImageView
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:0.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_connoisseurImageView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:0.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_connoisseurImageView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:0.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_connoisseurImageView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:-13.3f]];
        [self.contentView addConstraints:imageViewConstraint];
        _upBorderlayer        = [CALayer layer];
        _upBorderlayer.backgroundColor = [UIColor whiteColor].CGColor;
        _upBorderlayer.frame           = CGRectMake(0, 0,kScreenWidth, 1.0f);
        [_connoisseurImageView.layer addSublayer:_upBorderlayer];
    }
    __block __typeof (UIImageView *)ConnoisseurSingleImageView = _connoisseurImageView;
    [_connoisseurImageView setImageWithURL:[NSURL URLWithString:_connoisseurDataObject.imageUrl]
                      withPlaceholderImage:[UIImage imageNamed:@"image_placeholder_4x3"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                     if(!image) {
                                         [ConnoisseurSingleImageView setImage:[UIImage imageNamed: kImageNamePresetNormal]];
                                     }}
               usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
