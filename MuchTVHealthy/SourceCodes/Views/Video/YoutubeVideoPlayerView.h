//
//  YoutubeVideoPlayerView.h
//  North7
//
//  Created by Weiyu Chen on 2015/5/27.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface YoutubeVideoPlayerView : UIView <UIWebViewDelegate, YTPlayerViewDelegate>
@property (nonatomic, strong) NSString      *youtubeID;
@property (nonatomic,strong) UIWebView      *videoPlayerWebView;
@property (nonatomic,assign) BOOL           isPlaying;
@property (nonatomic,strong) YTPlayerView   *playerView;

- (void)videoWebviewResize;
- (void)initVideoPlayerWebView;
@end
