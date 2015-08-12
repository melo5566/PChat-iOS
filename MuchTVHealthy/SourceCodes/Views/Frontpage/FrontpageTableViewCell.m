//
//  FrontpageTableViewCell.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/7/29.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "FrontpageTableViewCell.h"

@interface FrontpageTableViewCell()

@property (nonatomic, strong) UIImageView           *frontpageImageView;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UILabel               *timeLabel;
@property (nonatomic, strong) UIView                *frontpageView;
@property (nonatomic, strong) UIImageView           *timeImageView;

@end

@implementation FrontpageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) setFrontpageObject:(FrontpageObject *)frontpageObject {
    _frontpageObject = frontpageObject;
    [self initFrontpageView];
    [self initFrontpageImageView];
    [self initFrontpageTitleLabel];
    [self initFrontpageTimeImageView];
    [self initFrontpageTimeLabel];
}

- (void) initFrontpageView {
    if (!_frontpageView) {
        _frontpageView = [[UIView alloc] initForAutolayout];
        _frontpageView.backgroundColor = [UIColor clearColor];
        _frontpageView.layer.borderColor = [UIColor colorWithHexString:kFrontpageCardBoderColorHexString].CGColor;
        _frontpageView.layer.borderWidth = 1.0f;
        [self.contentView addSubview:_frontpageView];
        
        NSMutableArray *frontpageViewConstraint = [[NSMutableArray alloc] init];
        
        [frontpageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:0.0f]];
        [frontpageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:7.5f]];
        [frontpageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:0.0f]];
        [frontpageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:-7.5f]];
        
        [self addConstraints:frontpageViewConstraint];
        
    }
}

- (void) initFrontpageImageView {
    if (!_frontpageImageView) {
        _frontpageImageView = [[UIImageView alloc] initForAutolayout];
        _frontpageImageView.contentMode = UIViewContentModeScaleAspectFill;
        _frontpageImageView.clipsToBounds = YES;
        [_frontpageView addSubview:_frontpageImageView];
        
        NSMutableArray *frontpageImageViewConstraint = [[NSMutableArray alloc] init];
        
        [frontpageImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageImageView
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_frontpageView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0f constant:2.5f]];
        [frontpageImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageImageView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_frontpageView
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0f constant:2.5f]];
        [frontpageImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageImageView
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_frontpageView
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0f constant:-2.5f]];
        [frontpageImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_frontpageImageView
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:(kScreenWidth- 30 - 5)*3/4]];
        
        [self addConstraints:frontpageImageViewConstraint];
        
    }
    [_frontpageImageView setImageWithURL:[NSURL URLWithString:_frontpageObject.imageUrl]
                    withPlaceholderImage:[UIImage imageNamed:@"image_placeholder_4x3"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                   if (image) {
                                       [_frontpageImageView setImage:image];
                                       _frontpageImageView.alpha = 0;
                                       [UIView animateWithDuration:0.3 animations:^(){
                                           [_frontpageImageView setImage:image];
                                           _frontpageImageView.alpha = 0.9;
                                       }];
                                   } else {
                                       NSLog(@"Error");
                                   }
                               }
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}


- (void) initFrontpageTitleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initForAutolayout];
        _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
        [_frontpageView addSubview:_titleLabel];
        NSMutableArray *titleLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_frontpageView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:9.8f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_frontpageImageView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:7.8f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_frontpageView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f constant:-10.0f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:43.0f]];
        
        [self addConstraints:titleLabelViewConstraint];
        
    }
    _titleLabel.text = _frontpageObject.title;
}

- (void) initFrontpageTimeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initForAutolayout];
        _timeLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        _timeLabel.textColor = [UIColor colorWithHexString:kColorHexStringGlobalTimeLabelText];
        [_frontpageView addSubview:_timeLabel];
        NSMutableArray *timeLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_timeImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:3.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_titleLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:5.0f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:108.7f]];
        [timeLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:21.5f]];
        
        [self addConstraints:timeLabelViewConstraint];
    }
    _timeLabel.text = _frontpageObject.time;
    
}

- (void) initFrontpageTimeImageView {
    if (!_timeImageView) {
        _timeImageView       = [[UIImageView alloc] initForAutolayout];
        _timeImageView.image = [UIImage imageNamed:@"icon_time"];
        [_frontpageView addSubview:_timeImageView];
        NSMutableArray *timeImageViewViewConstraint = [[NSMutableArray alloc] init];
        
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_frontpageView
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0f constant:9.8f]];
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_titleLabel
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f constant:10.0f]];
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:10.5f]];
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0f constant:10.5f]];
        
        [self addConstraints:timeImageViewViewConstraint];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
