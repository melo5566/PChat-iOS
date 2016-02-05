//
//  IntroductionViewController.m
//  493_Project
//
//  Created by Wu Peter on 2015/12/13.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "IntroductionViewController.h"
#import "IntroductionView.h"

@interface IntroductionViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) NSArray           *imageArray;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic) NSUInteger                currPage;
@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Introduction";
    _imageArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    [self initCloseButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCloseButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(10, 0, 50, 17);
    [button setTitle:@"Close" forState:UIControlStateNormal];
    button.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitleColor:[UIColor colorWithR:255 G:255 B:255] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigatinBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navigatinBarButtonItem;

}

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * _imageArray.count , self.view.bounds.size.height);
    _scrollView.clipsToBounds = NO;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(self.view.bounds.size.width/2,self.view.bounds.size.height - 20, 10, 20);
    _pageControl.numberOfPages = _imageArray.count;
    [self.view addSubview:_pageControl];
    if ([_pageControl respondsToSelector:@selector(pageIndicatorTintColor)]) {
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    }
    if ([_pageControl respondsToSelector:@selector(currentPageIndicatorTintColor)]) {
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    _pageControl.backgroundColor = [UIColor clearColor];
    
    for (NSInteger i = 0; i < _imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initForAutolayout];
        [imageView setImage:[UIImage imageNamed:_imageArray[i]]];
        [_scrollView addSubview:imageView];
        
        NSMutableArray *avatarConstraint = @[].mutableCopy;
        
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_scrollView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0f constant:i*kScreenWidth]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_scrollView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0.0f]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:self.view.bounds.size.width]];
        [avatarConstraint addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:self.view.bounds.size.height]];
        
        [_scrollView addConstraints:avatarConstraint];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currPage = ((scrollView.contentOffset.x + (self.view.bounds.size.width /2 )) / self.view.bounds.size.width);
    [_pageControl setCurrentPage:_currPage];
}

- (void)closeButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
