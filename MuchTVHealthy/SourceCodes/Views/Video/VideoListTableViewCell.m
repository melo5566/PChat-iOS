//
//  VideoListTableViewCell.m
//  MuchTVHealthy
//
//  Created by Steven Liu on 2015/8/20.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "VideoListTableViewCell.h"

@interface VideoListTableViewCell()

@property (strong, nonatomic)  UIView         *imageFrameview;
@property (strong, nonatomic)  UIImageView    *cellImageView;
@property (strong, nonatomic)  UILabel        *nameLabel;
@property (strong, nonatomic)  UILabel        *timeLabel;
@property (strong, nonatomic)  UIImageView    *playIcon;
@property (strong, nonatomic)  NSAttributedString   *attachmentString;

@end

@implementation VideoListTableViewCell

- (void)setVideoDataObject:(VideoDataObject *)videoDataObject {
    self.backgroundColor = [UIColor clearColor];
    _videoDataObject = videoDataObject;
    NSLog(@"test");
    [self initVideoCellLayout];
}

- (void)awakeFromNib {
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initVideoCellLayout{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initCellImageView];
    [self initMenuLabelsView];
    [self initMenuLabel];
    [self addIcon];
}

- (void) addIcon{
    if(!_playIcon){
        _playIcon=[[UIImageView alloc]initForAutolayout];
        _playIcon.image=[UIImage imageNamed:@"icon_play.png"];
        [self addSubview:_playIcon];
        NSLayoutConstraint *constraint_m = [NSLayoutConstraint constraintWithItem:_playIcon
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.cellImageView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0f constant:0];//kScreenHeight/2-114+3
        
        NSLayoutConstraint *constraint_n = [NSLayoutConstraint constraintWithItem:_playIcon
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.cellImageView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0f constant:0];
        NSLayoutConstraint *constraint_o = [NSLayoutConstraint constraintWithItem:_playIcon
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:50];
        
        NSLayoutConstraint *constraint_p = [NSLayoutConstraint constraintWithItem:_playIcon
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:50];
        [self addConstraints:@[constraint_m,constraint_n,constraint_o,constraint_p]];}
    
    
}

- (void) initMenuLabelsView{
    if(!_nameLabel){
        _nameLabel=[[UILabel alloc]initForAutolayout];
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.backgroundColor=[UIColor clearColor];
        _nameLabel.numberOfLines=2;
        [self addSubview:_nameLabel];
        NSLayoutConstraint *constraint_m = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.cellImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0];//kScreenHeight/2-114+3
        
        NSLayoutConstraint *constraint_n = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:40];
        NSLayoutConstraint *constraint_o = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:kkGlobalDefaultPadding];
        
        NSLayoutConstraint *constraint_p = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kScreenWidth-kkGlobalDefaultPadding*2];
        [self addConstraints:@[constraint_m,constraint_n,constraint_o,constraint_p]];}
    if(!_timeLabel){
        _timeLabel=[[UILabel alloc]initForAutolayout];
        _timeLabel.textColor=[UIColor blackColor];
        _timeLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:_timeLabel];
        
        NSLayoutConstraint *constraint_q = [NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.cellImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:41];
        NSLayoutConstraint *constraint_r = [NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:12];
        NSLayoutConstraint *constraint_s = [NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:kkGlobalDefaultPadding];
        
        NSLayoutConstraint *constraint_t = [NSLayoutConstraint constraintWithItem:_timeLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kScreenWidth-kkGlobalDefaultPadding*2];
        [self addConstraints:@[constraint_q,constraint_r,constraint_s,constraint_t]];
    }
    
    
    
}

- (void) initMenuLabel {
    if(!_attachmentString){
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image=[UIImage imageWithImage:[UIImage imageNamed:@"icon_time.png"] scaledToSize:CGSizeMake(10, 10)];
        _attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];}
    
    NSMutableAttributedString *attachmentTimeString = [[NSMutableAttributedString alloc] initWithAttributedString:_attachmentString];
    NSAttributedString *myText = [[NSMutableAttributedString alloc] initWithString:_videoDataObject.time];
    [attachmentTimeString appendAttributedString:myText];
    _timeLabel.attributedText = attachmentTimeString;
    
    _timeLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:11];
    _timeLabel.textColor=[UIColor colorWithHexString:kTimeLabelHexColor];
    
    _nameLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:17];
    _nameLabel.text = _videoDataObject.title;
    _nameLabel.textColor=[UIColor grayColor];
    
}

- (void) initCellImageView {
    if(!_imageFrameview)
    {_imageFrameview = [[UIView alloc] initForAutolayout];
        [self addSubview:_imageFrameview];
        
        NSLayoutConstraint *constraint_a = [NSLayoutConstraint constraintWithItem:_imageFrameview
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:kkGlobalDefaultPadding];
        NSLayoutConstraint *constraint_b = [NSLayoutConstraint constraintWithItem:_imageFrameview
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:_videoDataObject.title?kScreenWidth/4*3+40-kkGlobalDefaultPadding:kScreenWidth/4*3+30-kkGlobalDefaultPadding];//kScreenHeight/2-66
        NSLayoutConstraint *constraint_c = [NSLayoutConstraint constraintWithItem:_imageFrameview
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:0.0];
        NSLayoutConstraint *constraint_d = [NSLayoutConstraint constraintWithItem:_imageFrameview
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kScreenWidth];
        [self addConstraints:@[constraint_a,constraint_b,constraint_c,constraint_d]];
        
        
        _imageFrameview.backgroundColor=[UIColor colorWithR:255 G:255 B:255];
        [_imageFrameview.layer setShadowColor:[UIColor blackColor].CGColor];
        [_imageFrameview.layer setShadowOpacity:0.5];
        [_imageFrameview.layer setShadowOffset:CGSizeMake(0, 0.5)];
        _imageFrameview.layer.shouldRasterize=YES;}
    if(!_cellImageView)
    {
        _cellImageView = [[UIImageView alloc] initForAutolayout];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        _cellImageView.clipsToBounds = YES;
        [self addSubview:_cellImageView];
        NSLayoutConstraint *constraint_e = [NSLayoutConstraint constraintWithItem:_cellImageView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:kkGlobalDefaultPadding*2];
        NSLayoutConstraint *constraint_f = [NSLayoutConstraint constraintWithItem:_cellImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:_videoDataObject.title?(kScreenWidth-40)/4*3:(kScreenWidth-35)/4*3];//kScreenHeight/2-72
        NSLayoutConstraint *constraint_g = [NSLayoutConstraint constraintWithItem:_cellImageView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:kkGlobalDefaultPadding];
        
        NSLayoutConstraint *constraint_h = [NSLayoutConstraint constraintWithItem:_cellImageView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0f constant:kScreenWidth-kkGlobalDefaultPadding*2];
        
        
        [self addConstraints:@[constraint_e,constraint_f,constraint_g,constraint_h]];
        _cellImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cellImageView.layer.borderWidth = 0.5;
        _cellImageView.layer.shouldRasterize=YES;
    }
    
    __block __typeof (UIImageView *)picture = _cellImageView;
    
    [_cellImageView setImageWithURL:[NSURL URLWithString:_videoDataObject.imageURL]
               withPlaceholderImage:nil
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                              if (image) {
                                  picture.alpha = 0;
                                  [UIView animateWithDuration:0.3 animations:^(){
                                      [picture setImage:image];
                                      picture.alpha = 0.9;
                                  }];
                              }
                              else {
                                  [picture setImage:[UIImage imageNamed: @"preset.png"]];
                              }
                          }
        usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}



@end
