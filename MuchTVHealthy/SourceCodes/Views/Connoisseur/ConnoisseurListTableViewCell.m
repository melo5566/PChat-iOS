//
//  ConnoisseurListTableViewCell.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/13.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ConnoisseurListTableViewCell.h"
@interface ConnoisseurListTableViewCell()
@property (strong, nonatomic)  UIView         *frameView;
@property (strong, nonatomic)  UIImageView    *ImageView;
@property (strong, nonatomic)  UILabel        *nameLabel;
@property (strong, nonatomic)  UILabel        *subtitleLabel;
@end


@implementation ConnoisseurListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setConnoisseurDataObject:(ConnoisseurDataObject *)connoisseurDataObject {
    self.backgroundColor = [UIColor clearColor];
    _connoisseurDataObject = connoisseurDataObject;
    [self initFrameView];
    [self initImageView];
    [self initLabelView];
}


- (void) initFrameView {
    if(!_frameView) {
    _frameView = [[UIView alloc]initForAutolayout];
    _frameView.backgroundColor = [UIColor whiteColor];
    _frameView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _frameView.layer.borderWidth = 1.0;
    [_frameView.layer setShadowColor:[UIColor blackColor].CGColor];
    _frameView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    _frameView.layer.shadowOpacity = 0.5;
    NSMutableArray *frameViewConstraint = @[].mutableCopy;
    [self.contentView addSubview:_frameView];

    
    [frameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frameView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
    [frameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frameView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:5.0f]];
    [frameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frameView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
    [frameViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frameView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:-5.0f]];
    
    [self.contentView addConstraints:frameViewConstraint];
    }
}

- (void) initImageView {
    if(!_ImageView) {
        _ImageView = [[UIImageView alloc]initForAutolayout];
        _ImageView.contentMode = UIViewContentModeScaleAspectFill;
        _ImageView.clipsToBounds = YES;
        [_frameView addSubview:_ImageView];
        NSMutableArray *imageViewConstraint = @[].mutableCopy;
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_ImageView
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_frameView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:5.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_ImageView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_frameView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:5.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_ImageView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_frameView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:-5.0f]];
        [imageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_ImageView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_frameView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:-61.0f]];
        [_frameView addConstraints:imageViewConstraint];

    }
    __block __typeof (UIImageView *)ConnoisseurImageView = _ImageView;
    [_ImageView setImageWithURL:[NSURL URLWithString:_connoisseurDataObject.imageUrl]
           withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderWide]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                          if(!image) {
                              [ConnoisseurImageView setImage:[UIImage imageNamed: kImageNamePresetNormal]];
                          }}
    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
}

- (void) initLabelView {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc]initForAutolayout];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithHexString:kConnoisseurCellNameTextColor];
        _nameLabel.font      = [UIFont fontWithName:@"STHeitiTC-Light" size:17];
        [_frameView addSubview:_nameLabel];
        NSMutableArray *nameLabelConstraint = @[].mutableCopy;
        [nameLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_frameView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:5.0f]];
        [nameLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_ImageView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:10.0f]];
        [nameLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_frameView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:-5.0f]];
        [nameLabelConstraint addObject:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:17.0f]];
        [_frameView addConstraints:nameLabelConstraint];

    }
    
    if(!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc]initForAutolayout];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = [UIColor colorWithHexString:kConnoisseurCellSubtitleTextColor];
        _subtitleLabel.font      = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
        [_frameView addSubview:_subtitleLabel];
        NSMutableArray *subtitleConstraint = @[].mutableCopy;
        [subtitleConstraint addObject:[NSLayoutConstraint constraintWithItem:_subtitleLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_frameView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:5.0f]];
        [subtitleConstraint addObject:[NSLayoutConstraint constraintWithItem:_subtitleLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_nameLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:7.0f]];
        [subtitleConstraint addObject:[NSLayoutConstraint constraintWithItem:_subtitleLabel
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_frameView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:-5.0f]];
        [subtitleConstraint addObject:[NSLayoutConstraint constraintWithItem:_subtitleLabel
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:15.0f]];
        [_frameView addConstraints:subtitleConstraint];
        

    }
    
    _nameLabel.text = _connoisseurDataObject.connoisseurName;
    _subtitleLabel.text = _connoisseurDataObject.connoisseurSubtitle;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
