//
//  IntroductionView.m
//  493_Project
//
//  Created by Wu Peter on 2015/12/13.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "IntroductionView.h"

static NSString * const kHeadlineViewPaginatorDotColor     = @"#404ed0";
static CGFloat    const kHeadlineViewPaginatorHeight       = 20.0f;

@interface IntroductionView ()

@property (nonatomic, strong) UIScrollView          *slidersScrollView;

@property (nonatomic, strong) UIPageControl         *paginator;
@property (nonatomic, strong) UIScrollView          *mediaBox;
@property (nonatomic, strong) NSTimer               *timer;
@property (nonatomic)         BOOL                  isScrolling;
@end

@implementation IntroductionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isScrolling = NO;
    }
    return self;
}

- (void) setSliders:(NSArray *)sliders {
    _sliders = sliders;
    if ([_sliders isNotEmpty]) {
        [self initLayout];
    } else {
        [self initPlaceholdder];
    }
}

- (void) initLayout {
    // background color
    self.backgroundColor = [UIColor clearColor];
    
    if ([_sliders isNotEmpty]) {
        // init media box
        [self initSlidersScrollView];
    }
    
    // init paginator
    if (_sliders.count > 1) {
        [self initPaginator];
    }
}

- (void) initSlidersScrollView {
    _slidersScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
    _slidersScrollView.pagingEnabled = YES;
    _slidersScrollView.backgroundColor = [UIColor blackColor];
    _slidersScrollView.showsHorizontalScrollIndicator = NO;
    _slidersScrollView.showsVerticalScrollIndicator = NO;
    _slidersScrollView.scrollsToTop = NO;
    _slidersScrollView.delegate = (id) self;
    _slidersScrollView.contentSize = CGSizeMake(kScreenWidth * _sliders.count , kScreenHeight);
    _slidersScrollView.clipsToBounds = NO;
    
    for (NSInteger i = 0; i < _sliders.count; i++) {
        CGRect frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.userInteractionEnabled = YES;
        [imageView setImage:[UIImage imageNamed:_sliders[i]]];
        
        [_slidersScrollView addSubview:imageView];
        
    }
    
    // move to the "first" one
    [_slidersScrollView scrollRectToVisible:CGRectMake(0 , 0, kScreenWidth, kScreenHeight) animated:NO];
    
    [self addSubview:_slidersScrollView];
}

- (void) initPlaceholdder {
    UIImage* placeholderImage = [UIImage imageNamed:kImageNamePlaceholderWide];
    UIImageView* placeholderImageView = [[UIImageView alloc] initWithImage:placeholderImage];
    placeholderImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    placeholderImageView.backgroundColor = [UIColor grayColor];
    if (![self.subviews containsObject:placeholderImageView]) {
        [self addSubview:placeholderImageView];
    }
}

- (void) initPaginator {
    // if already have one, remove it!
    if (_paginator) {
        [_paginator removeFromSuperview];
        _paginator = nil;
    }
    
    _paginator = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                 kScreenHeight - 20,
                                                                 self.bounds.size.width,
                                                                 kHeadlineViewPaginatorHeight)];
    
    _paginator.numberOfPages = _sliders.count;
    _paginator.currentPage = 0;
    
    
    [self addSubview:_paginator];
    
    // for iOS 6+ only
    if ([_paginator respondsToSelector:@selector(pageIndicatorTintColor)]) {
        _paginator.pageIndicatorTintColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    // for iOS 6+ only
    if ([_paginator respondsToSelector:@selector(currentPageIndicatorTintColor)]) {
        _paginator.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#404ed0"];
    }
    
    _paginator.backgroundColor = [UIColor colorWithHexString:@"#ffffff" withAlpha:0.75];
}

#pragma mark - scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self autoScrolling:NO];
}
- (void) scrollViewDidScroll:(UIScrollView *) scrollView
{
    NSInteger currentPage = ((scrollView.contentOffset.x + (kScreenWidth /2 )) / kScreenWidth);
    [_paginator setCurrentPage:currentPage];
}


- (void) scrollViewDidEndDecelerating:(UIScrollView *) scrollView {
    [self autoScrolling:YES];
}

#pragma mark - timer events
- (void) autoScrolling:(BOOL) on {
    if(on && (_sliders.count > 1)) {
        if (_timer != nil) {
            [_timer invalidate];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                  target:self
                                                selector:@selector(loopMediaBox)
                                                userInfo:nil
                                                 repeats:YES];
    }
    else {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) loopMediaBox {
    if ([self currentPage] == _sliders.count -1 ) {
        [_slidersScrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, kScreenHeight) animated:YES];
    }
    else {
        [_slidersScrollView scrollRectToVisible:CGRectMake(kScreenWidth * ([self currentPage] + 1), 0, kScreenWidth, kScreenHeight) animated:YES];
    }
    
}

- (NSInteger) currentPage {
    return _paginator.currentPage;
}

@end