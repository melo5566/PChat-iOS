//
//  GameTableViewCell.m
//  493_Project
//
//  Created by Wu Peter on 2015/12/9.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "GameTableViewCell.h"

@interface GameTableViewCell()
@property (nonatomic, strong) UIImageView       *coverPhoto;
@property (nonatomic, strong) UILabel           *departmentLabel;
@property (nonatomic, strong) UILabel           *courseLabel;
@property (nonatomic, strong) NSString          *department;
@property (nonatomic, strong) NSString          *course;
@end

@implementation GameTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCategoryObject:(CategoryObject *)categoryObject {
    _categoryObject = categoryObject;
    UIGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    [self.contentView addGestureRecognizer:longPress];
    [self initImageView:@""];
}

- (void)setCategory:(NSString *)category {
    _category = category;
    NSRange range = [_category rangeOfString:@"_"];
    _department = [_category substringToIndex:range.location];
    _course = [_category substringFromIndex:range.location+1];
    UIGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed1:)];
    [self.contentView addGestureRecognizer:longPress];
    [self initImageView:@"Academic"];
}

- (void) initImageView:(NSString *)type {
    if (!_coverPhoto) {
        _coverPhoto = [[UIImageView alloc] initForAutolayout];
        [self.contentView addSubview:_coverPhoto];
        
        NSMutableArray *coverImageViewConstraint = [[NSMutableArray alloc] init];
        
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_coverPhoto
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0f constant:10.0f]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_coverPhoto
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0f constant:5.0f]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_coverPhoto
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0f constant:-5.0]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_coverPhoto
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f constant:-10.0f]];
        
        [self addConstraints:coverImageViewConstraint];
        
    }
    if ([type isEqualToString:@"Academic"]) {
        [_coverPhoto setImage:[UIImage imageNamed:@"Course"]];
        [self initDepartmentLabel];
        [self initCourseLabel];
    } else {
        __block __typeof (UIImageView *) coverPhoto = _coverPhoto;
        [_coverPhoto setImageWithURL:[NSURL URLWithString:_categoryObject.imageUrl]
                     withPlaceholderImage:[UIImage imageNamed:kImageNamePlaceholderSquare]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    if (!image) {
                                        [coverPhoto setImage:[UIImage imageNamed:kImageNamePresetAvatar]];
                                    }
                                }
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
}

- (void) initDepartmentLabel {
    if (!_departmentLabel) {
        _departmentLabel = [[UILabel alloc] initForAutolayout];
        _departmentLabel.backgroundColor = [UIColor clearColor];
        [_departmentLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        _departmentLabel.textColor = [UIColor whiteColor];
        [_coverPhoto addSubview:_departmentLabel];
        
        NSMutableArray *coverImageViewConstraint = [[NSMutableArray alloc] init];
        
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_departmentLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:20.0f]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_departmentLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_coverPhoto
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f constant:5.0f]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_departmentLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:25.0]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_departmentLabel
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:100.0f]];
        
        [self addConstraints:coverImageViewConstraint];
    }
    _departmentLabel.text = _department;
}

- (void) initCourseLabel {
    if (!_courseLabel) {
        _courseLabel = [[UILabel alloc] initForAutolayout];
        _courseLabel.backgroundColor = [UIColor clearColor];
        [_courseLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        _courseLabel.textColor = [UIColor whiteColor];
        [_coverPhoto addSubview:_courseLabel];
        
        NSMutableArray *coverImageViewConstraint = [[NSMutableArray alloc] init];
        
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_courseLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f constant:70.0f]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_courseLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_departmentLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0f constant:0.0f]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_courseLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:25.0]];
        [coverImageViewConstraint addObject:[NSLayoutConstraint constraintWithItem:_courseLabel
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0f constant:100.0f]];
        
        [self addConstraints:coverImageViewConstraint];
    }
    _courseLabel.text = _course;
}

- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(handleLongPress:)]) {
        [self.delegate handleLongPress:_categoryObject.name];
    }
}

- (void)handleLongPressed1:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(handleLongPress:)]) {
        [self.delegate handleLongPress:_category];
    }
}

@end
