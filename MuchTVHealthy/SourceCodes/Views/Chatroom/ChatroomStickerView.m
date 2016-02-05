//
//  ChatroomStickerView.m
//  493_Project
//
//  Created by Wu Peter on 2015/11/5.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "ChatroomStickerView.h"

#define kStickerPageNumber          1
#define kStickerPagingButtonHeight  45
#define kStickerPagingButtonWidth   55
#define kStickerPagingButtonImages  @[@"top"]
#define kStickerStickerImages       @[@"cat",@"wtf",@"noway",@"goodnight",@"no",@"wow",@"good",@"loveyou",@"hide",@"laugh",@"bad",@"cute"]
#define kStickerWidth               kScreenWidth / 3 - 10

@interface ChatroomStickerView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIScrollView                  *pagingButtonScollView;
@property (nonatomic, strong) UICollectionView              *stickerCollectionView;
@end

@implementation ChatroomStickerView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
        [self initLayout];
    }
    return self;
}

- (void) initLayout {
    [self initPagingButtonScollView];
    [self initStickerCollectionView];
}

- (void) initPagingButtonScollView {
    if (!_pagingButtonScollView) {
        _pagingButtonScollView = [[UIScrollView alloc] initForAutolayout];
        _pagingButtonScollView.backgroundColor = [UIColor clearColor];
        _pagingButtonScollView.contentSize = CGSizeMake(kStickerPageNumber * kStickerPagingButtonWidth, kStickerPagingButtonHeight);
        _pagingButtonScollView.showsHorizontalScrollIndicator = NO;
        _pagingButtonScollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_pagingButtonScollView];
        NSMutableArray *scollViewConstaint = @[].mutableCopy;
        [scollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_pagingButtonScollView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0f constant:0.0f]];
        [scollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_pagingButtonScollView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0f constant:0.0f]];
        [scollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_pagingButtonScollView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f constant:0.0f]];
        [scollViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_pagingButtonScollView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0f constant:kStickerPagingButtonHeight]];
        [self addConstraints:scollViewConstaint];
    }
    [self initPagingButton];
}

- (void) initPagingButton {
    for (int i = 0;i<kStickerPageNumber;i++) {
        UIButton *pagingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pagingButton.tag = i;
        pagingButton.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        [pagingButton setFrame:CGRectMake(kStickerPagingButtonWidth * i, 0, kStickerPagingButtonWidth, kStickerPagingButtonHeight)];
        [pagingButton setImage:[UIImage imageNamed:kStickerPagingButtonImages[i]] forState:UIControlStateNormal];
        [pagingButton addTarget:self action:@selector(pagingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_pagingButtonScollView addSubview:pagingButton];
    }
}

- (void) initStickerCollectionView {
    if (!_stickerCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _stickerCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_stickerCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _stickerCollectionView.dataSource = self;
        _stickerCollectionView.delegate = self;
//        _stickerCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        _stickerCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_stickerCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"StickerCollectionViewCell"];
        [self addSubview:_stickerCollectionView];
        
        NSMutableArray *collectionConstraint = [NSMutableArray array];
        
        [collectionConstraint addObject:[NSLayoutConstraint constraintWithItem:_stickerCollectionView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_pagingButtonScollView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [collectionConstraint addObject:[NSLayoutConstraint constraintWithItem:_stickerCollectionView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0f constant:0.0f]];
        [collectionConstraint addObject:[NSLayoutConstraint constraintWithItem:_stickerCollectionView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f constant:0.0f]];
        [collectionConstraint addObject:[NSLayoutConstraint constraintWithItem:_stickerCollectionView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f constant:0.0f]];
        
        [self addConstraints:collectionConstraint];
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 12;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"StickerCollectionViewCell";
    
    UIImageView *sticker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kStickerWidth, kStickerWidth)];
    sticker.backgroundColor = [UIColor clearColor];
    sticker.clipsToBounds = YES;
    NSString *imageName = kStickerStickerImages[indexPath.row];
    [sticker setImage:[UIImage imageNamed:imageName]];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundView = sticker;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kStickerWidth, kStickerWidth);
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate sendStickerWithImageName:kStickerStickerImages[indexPath.row]];
}

- (void) pagingButtonPressed:(id) sender {
    
}

@end

