//
//  RecipeTableViewCell.m
//  MuchTVHealthy
//
//  Created by Peter on 2015/8/18.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "RecipeTableViewCell.h"

@interface RecipeTableViewCell()

@property (nonatomic, strong) UIImageView           *recipeImageView;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UILabel               *timeLabel;
@property (nonatomic, strong) UIView                *recipeView;
@property (nonatomic, strong) UIImageView           *timeImageView;

@end

@implementation RecipeTableViewCell

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


- (void) setString:(NSString *)string {
    _string = string;
    [self initRecipeView];
    [self initRecipeImageView];
    [self initRecipeTitleLabel];
    [self initRecipeTimeImageView];
    [self initRecipeTimeLabel];
}

- (void) initRecipeView {
    if (!_recipeView) {
        _recipeView = [[UIView alloc] initForAutolayout];
        _recipeView.backgroundColor     = [UIColor whiteColor];
        _recipeView.layer.borderColor   = [UIColor colorWithHexString:kFrontpageCardBoderColorHexString].CGColor;
        _recipeView.layer.borderWidth   = 1.0f;
        _recipeView.layer.shadowColor   = [UIColor blackColor].CGColor;
        _recipeView.layer.shadowOpacity = 0.5;
        _recipeView.layer.shadowOffset  = CGSizeMake(0, 0.5);
        [self.contentView addSubview:_recipeView];
        
        NSMutableArray *recipeViewConstraint = [[NSMutableArray alloc] init];
        
        [recipeViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:0.0f]];
        [recipeViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:7.5f]];
        [recipeViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:0.0f]];
        [recipeViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:-7.5f]];
        
        [self addConstraints:recipeViewConstraint];
        
    }
}

- (void) initRecipeImageView {
    if (!_recipeImageView) {
        _recipeImageView = [[UIImageView alloc] initForAutolayout];
        _recipeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _recipeImageView.clipsToBounds = YES;
        [_recipeView addSubview:_recipeImageView];
        
        NSMutableArray *recipeImageViewConstraint = [[NSMutableArray alloc] init];
        
        [recipeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeImageView
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_recipeView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.0f constant:10.0f]];
        [recipeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeImageView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_recipeView
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0f constant:10.0f]];
        [recipeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeImageView
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:_recipeView
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0f constant:-10.0f]];
        [recipeImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_recipeImageView
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f constant:(kScreenWidth- 30 - 5)*3/4]];
        
        [self addConstraints:recipeImageViewConstraint];
        
    }
    [_recipeImageView setImageWithURL:[NSURL URLWithString:@""]
                    withPlaceholderImage:[UIImage imageNamed:@"image_placeholder_4x3"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                   if (image) {
                                       [_recipeImageView setImage:image];
                                       _recipeImageView.alpha = 0;
                                       [UIView animateWithDuration:0.3 animations:^(){
                                           [_recipeImageView setImage:image];
                                           _recipeImageView.alpha = 0.9;
                                       }];
                                   } else {
                                       NSLog(@"Error");
                                   }
                               }
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}


- (void) initRecipeTitleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initForAutolayout];
        _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor colorWithHexString:kListTableViewTitleColorHexString];
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:17.0];
        [_recipeView addSubview:_titleLabel];
        NSMutableArray *titleLabelViewConstraint = [[NSMutableArray alloc] init];
        
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_recipeView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:9.8f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_recipeImageView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:7.8f]];
        [titleLabelViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_recipeView
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
    _titleLabel.text = _string;
}

- (void) initRecipeTimeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initForAutolayout];
        _timeLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
        _timeLabel.textColor = [UIColor colorWithHexString:kListTableViewTimeColorHexString];
        [_recipeView addSubview:_timeLabel];
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
    _timeLabel.text = @"2015/08/18";
    
}

- (void) initRecipeTimeImageView {
    if (!_timeImageView) {
        _timeImageView       = [[UIImageView alloc] initForAutolayout];
        _timeImageView.image = [UIImage imageNamed:@"icon_time"];
        [_recipeView addSubview:_timeImageView];
        NSMutableArray *timeImageViewViewConstraint = [[NSMutableArray alloc] init];
        
        [timeImageViewViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_timeImageView
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_recipeView
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
