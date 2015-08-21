//
//  InformationIntroductionViewself.m
//  MuchTVHealthy
//
//  Created by FanzyTv on 2015/8/3.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "InformationIntroductionView.h"

@interface InformationIntroductionView()
@property (nonatomic, strong) UILabel               *backGroundLabel;
@property (nonatomic, strong) UILabel               *titleContentLabel;
@property (nonatomic, strong) UILabel               *tlabel;
@property (nonatomic, strong) UIButton              *leftButton;
@property (nonatomic, strong) UIButton              *rightButton;
@property (nonatomic, strong) UIImageView           *pic;
@property (strong, nonatomic)  NSAttributedString       *attachmentString;
@property (strong, nonatomic)  NSAttributedString       *aattachmentString;
@property (nonatomic, strong) NSMutableParagraphStyle *style;
//@property (nonatomic, strong) UILabel               *titleLabel;
@end
@implementation InformationIntroductionView

-(void)setRecipePictureObject:(RecipePictureObject *)recipePictureObject{
    _titleContent=recipePictureObject.content;
    _pictureurl=recipePictureObject.imageurl;
    _labelHeight=recipePictureObject.calculatedIntroductionCardHeight;
    [self initLayoutWithPictureAndButtons];
}

- (void) setIntroductionObject:(RecipeIntroductionObject *)introductionObject{
    _title=introductionObject.title;
    _titleContent=introductionObject.content;
    _labelHeight=introductionObject.calculatedIntroductionCardHeight;
    [self initLayout];
}
- (void) initTitleContentLayout:(CGFloat) y{
    if(!_style){
        _style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        _style.alignment = NSTextAlignmentJustified;
        _style.firstLineHeadIndent = 10.0f;///////is 10 enough?
        _style.headIndent = 10.0f;
        _style.tailIndent = -10.0f;}
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self.titleContent attributes:@{ NSParagraphStyleAttributeName : _style}];
    if(!_titleContentLabel){
        _titleContentLabel=[[UILabel alloc]init];
        _titleContentLabel.frame=CGRectMake(0, y, kScreenWidth, self.labelHeight);}
    [self addSubview:_titleContentLabel];
    _titleContentLabel.numberOfLines = 0;
    _titleContentLabel.attributedText = attrText;
    _titleContentLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:18];
    _titleContentLabel.textColor=[UIColor grayColor];
    _titleContentLabel.backgroundColor=[UIColor whiteColor];
    
}
- (void) initLayout{
    if(!_backGroundLabel){
        _backGroundLabel = [[UILabel alloc]init];
        [_backGroundLabel.layer setShadowColor:[UIColor blackColor].CGColor];
        [_backGroundLabel.layer setShadowOpacity:0.5];
        [_backGroundLabel.layer setShadowOffset:CGSizeMake(0, 0.5)];
        _backGroundLabel.clipsToBounds=NO;
        _backGroundLabel.layer.masksToBounds = NO;
        _backGroundLabel.layer.shouldRasterize=YES;
    }
    _backGroundLabel.frame=CGRectMake(0, 0,kScreenWidth,_labelHeight+  kHeaderHeightIncludingThick1Height);
    [self addSubview: _backGroundLabel];
    _backGroundLabel.backgroundColor=[UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
    if(!_tlabel){
        _tlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,  kHeaderHeightIncludingThick1Height-1)];}
    [self addSubview:_tlabel];
    _tlabel.text=self.title;
    _tlabel.textColor=[UIColor colorWithHexString:kCellTitleLabelTextColor];
    _tlabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:21];
    _tlabel.backgroundColor=[UIColor whiteColor];
    [self initTitleContentLayout: kHeaderHeightIncludingThick1Height];//////for now set fake header to be 30
    self.backgroundColor=[UIColor colorWithHexString:kDefaultBackGroundColorHexString];
}
- (void) initLayoutWithPictureAndButtons{
    if(!_backGroundLabel){
        _backGroundLabel = [[UILabel alloc]init];
        [_backGroundLabel.layer setShadowColor:[UIColor blackColor].CGColor];
        [_backGroundLabel.layer setShadowOpacity:0.5];
        [_backGroundLabel.layer setShadowOffset:CGSizeMake(0, 0.5)];}
    _backGroundLabel.frame=CGRectMake(0, 0, kScreenWidth, kScreenWidth/4*3+_labelHeight+40);/////to use tht calculated one
    [self addSubview: _backGroundLabel];
    _backGroundLabel.clipsToBounds=NO;
    _backGroundLabel.layer.masksToBounds = NO;
    _backGroundLabel.backgroundColor=[UIColor colorWithHexString:kDefaultSeparatorLineColorHexString];
    
    
    
    if(!_pic){
        _pic=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenWidth/4*3)];}
    [self addSubview:_pic];
    _pic.contentMode = UIViewContentModeScaleAspectFill;
    _pic.clipsToBounds = YES;
    [_pic setImageWithURL:[NSURL URLWithString:_pictureurl]
     withPlaceholderImage:[UIImage imageNamed:@"preset.png"]
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *url) {
                }
usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    [self initTitleContentLayout:kScreenWidth/4*3];
    
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0,kScreenWidth/4*3+_labelHeight+1, kScreenWidth/2-0.5, 39)];}
    [self addSubview: _leftButton];
    _leftButton.backgroundColor=[UIColor whiteColor];
    if(!_attachmentString){
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image=[UIImage imageWithImage:[UIImage imageNamed:@"icon_collect.png"] scaledToSize:CGSizeMake(18, 18)];
        _attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];}
    NSMutableAttributedString *attachmentShareString = [[NSMutableAttributedString alloc] initWithAttributedString:_attachmentString];
    
    NSAttributedString *myText = [[NSMutableAttributedString alloc] initWithString:@" 收 藏 " attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"STHeitiTC-Light" size:18],NSForegroundColorAttributeName : [UIColor grayColor]}];
    [attachmentShareString appendAttributedString:myText];
    [_leftButton setAttributedTitle:attachmentShareString forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(likeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2+0.5,kScreenWidth/4*3+_labelHeight+1, kScreenWidth/2-0.5, 39)];}
    [self addSubview: _rightButton];
    _rightButton.backgroundColor=[UIColor whiteColor];
    if(!_aattachmentString){
        NSTextAttachment *aattachment = [[NSTextAttachment alloc] init];
        aattachment.image=[UIImage imageWithImage:[UIImage imageNamed:@"icon_share.png"] scaledToSize:CGSizeMake(18, 18)];
        _aattachmentString = [NSAttributedString attributedStringWithAttachment:aattachment];}
    NSMutableAttributedString *aattachmentShareString = [[NSMutableAttributedString alloc] initWithAttributedString:_aattachmentString];
    
    NSAttributedString *myyText = [[NSMutableAttributedString alloc] initWithString:@" 分 享 " attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"STHeitiTC-Light" size:18],NSForegroundColorAttributeName : [UIColor grayColor]}];
    [aattachmentShareString appendAttributedString:myyText];
    [_rightButton setAttributedTitle:aattachmentShareString forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.backgroundColor=[UIColor colorWithHexString:kDefaultBackGroundColorHexString];
}
- (void)likeClicked:(id) sender{
    if([_delegate respondsToSelector:@selector(likeClicked:)]){
        [_delegate likeClicked:sender];}
}

- (void)shareClicked:(id) sender{
    if([_delegate respondsToSelector:@selector(shareClicked:)]){
        [_delegate shareClicked:sender];
    }
}


@end
