//
//  InformationCardTableViewCell.m
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/8/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "InformationCardTableViewCell.h"

#import "InformationCardTableViewCell.h"

@interface InformationCardTableViewCell ()
@property (strong, nonatomic)  UIImageView              *mainImageView;
@property (strong, nonatomic)  UILabel                  *titleLabel;
@property (strong, nonatomic)  UILabel                  *authorLabel;
@property (strong, nonatomic)  UILabel                  *createTimeLabel;
@property (strong, nonatomic)  NSAttributedString       *attachmentString;

@end

@implementation InformationCardTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self){
        self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void) setRecipeVideoObject:(RecipeVideoObject *)recipeVideoObject {
    _recipeVideoObject = recipeVideoObject;
    _videourl = _recipeVideoObject.link;
    _createTime = _recipeVideoObject.time;
    _title = _recipeVideoObject.content;
    _imageURL= [_videourl getYoutubeVieoMqDefaultImage];
    [self initVideoLayout];
    
}
- (void) initTitle {
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]initForAutolayout];}
    [self.contentView addSubview:_titleLabel];
    NSLayoutConstraint *constraint_e = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:10.0f];
    NSLayoutConstraint *constraint_f = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:kkGlobalCardCellHeight+kkGlobalDefaultPadding+3];
    NSLayoutConstraint *constraint_g = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:kScreenWidth-kkGlobalCardCellHeight-kkGlobalDefaultPadding*3];
    NSLayoutConstraint *constraint_h = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:40.0f];
    [self addConstraints:@[constraint_e,constraint_f,constraint_g,constraint_h]];
}
- (void) initContentAndAuthor{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]initForAutolayout];}
    [self.contentView addSubview:_titleLabel];
    NSLayoutConstraint *constraint_e = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:25.0f];
    NSLayoutConstraint *constraint_f = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:kkGlobalCardCellHeight+kkGlobalDefaultPadding+3];
    NSLayoutConstraint *constraint_g = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:kScreenWidth-kkGlobalCardCellHeight-kkGlobalDefaultPadding*3];
    NSLayoutConstraint *constraint_h = [NSLayoutConstraint constraintWithItem:_titleLabel
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:30.0f];
    [self addConstraints:@[constraint_e,constraint_f,constraint_g,constraint_h]];
    
    if(!_authorLabel){
        _authorLabel=[[UILabel alloc]initForAutolayout];
        [self.contentView addSubview:_authorLabel];
        NSLayoutConstraint *constraint_e = [NSLayoutConstraint constraintWithItem:_authorLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:10.0f];
        NSLayoutConstraint *constraint_f = [NSLayoutConstraint constraintWithItem:_authorLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:kkGlobalCardCellHeight+kkGlobalDefaultPadding+3];
        NSLayoutConstraint *constraint_g = [NSLayoutConstraint constraintWithItem:_authorLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kScreenWidth-kkGlobalCardCellHeight-kkGlobalDefaultPadding*3];
        NSLayoutConstraint *constraint_h = [NSLayoutConstraint constraintWithItem:_authorLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:15.0f];
        [self addConstraints:@[constraint_e,constraint_f,constraint_g,constraint_h]];
    }
}
- (void) initTime{
    
    if (!_createTimeLabel) {
        _createTimeLabel=[[UILabel alloc]initForAutolayout];
        
        [self.contentView addSubview:_createTimeLabel];
        NSLayoutConstraint *constraint_i = [NSLayoutConstraint constraintWithItem:_createTimeLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:55.0f];
        NSLayoutConstraint *constraint_j = [NSLayoutConstraint constraintWithItem:_createTimeLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:kkGlobalCardCellHeight+kkGlobalDefaultPadding+3];
        
        [self addConstraints:@[constraint_i,constraint_j]];}
    if(!_attachmentString){
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image=[UIImage imageWithImage:[UIImage imageNamed:@"icon_time.png"] scaledToSize:CGSizeMake(10, 10)];
        _attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];}
    
    NSMutableAttributedString *attachmentTimeString = [[NSMutableAttributedString alloc] initWithAttributedString:_attachmentString];
    NSAttributedString *myText = [[NSMutableAttributedString alloc] initWithString:_createTime];
    [attachmentTimeString appendAttributedString:myText];
    
    _createTimeLabel.attributedText = attachmentTimeString;
    _createTimeLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:12];
    _createTimeLabel.textColor=[UIColor colorWithHexString:kTimeLabelHexColor];
}

- (void) modifytext{
    _titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Medium" size:18];
    _titleLabel.textColor=[UIColor grayColor];
    [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_titleLabel setNumberOfLines:2];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    _titleLabel.text = _title;

}

- (void) initImageView{
    if (!_mainImageView) {
        _mainImageView=[[UIImageView alloc]initForAutolayout];
        _mainImageView.clipsToBounds = YES;
        [self.contentView addSubview:_mainImageView];
        //        _mainImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        _mainImageView.layer.borderWidth = 0.5;
        _mainImageView.layer.shouldRasterize=YES;
        NSLayoutConstraint *constraint_a = [NSLayoutConstraint constraintWithItem:_mainImageView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *constraint_b = [NSLayoutConstraint constraintWithItem:_mainImageView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *constraint_c = [NSLayoutConstraint constraintWithItem:_mainImageView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kkGlobalCardCellHeight];
        NSLayoutConstraint *constraint_d = [NSLayoutConstraint constraintWithItem:_mainImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kkGlobalCardCellHeight];
        [self addConstraints:@[constraint_a,constraint_b,constraint_c,constraint_d]];
    }
    
    __block __typeof (UIImageView *)picture = _mainImageView;
    [_mainImageView setImageWithURL:[NSURL URLWithString:_imageURL]
               withPlaceholderImage:nil
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                              if (!image) {
                                  [picture setImage:[UIImage imageNamed:@"preset.png"]];
                              }
                          }
        usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
}



- (void) initVideoLayout {
    [self initImageView];
    [self initTitle];
    [self initTime];
    [self modifytext];
    
}



@end