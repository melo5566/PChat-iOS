//
//  YoutubeVideoPlayerView.m
//  North7
//
//  Created by Weiyu Chen on 2015/5/27.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "YoutubeVideoPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation YoutubeVideoPlayerView

- (void) setYoutubeID:(NSString *)youtubeID {
    _youtubeID = youtubeID;
    [self initVideoPlayerWebView];
//    [self initLine];
//    [self initGesture];
}

- (void)initVideoPlayerWebView
{
    self.playerView = [[YTPlayerView alloc] initForAutolayout];
    self.playerView.backgroundColor = [UIColor blackColor];
    self.playerView.alpha = 0;
    self.playerView.delegate = self;
    [self addSubview:self.playerView];
    
    NSMutableArray *webViewConstaint = @[].mutableCopy;
    [webViewConstaint addObject:[NSLayoutConstraint constraintWithItem:self.playerView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0f constant:0.0f]];
    [webViewConstaint addObject:[NSLayoutConstraint constraintWithItem:self.playerView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0f constant:-1.0f]];
    [webViewConstaint addObject:[NSLayoutConstraint constraintWithItem:self.playerView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0f constant:0.0f]];
    [webViewConstaint addObject:[NSLayoutConstraint constraintWithItem:self.playerView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f constant:0.0f]];
    [self addConstraints:webViewConstaint];
    
    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"autoplay" : @1,
                                 @"fs" : @0,
                                 @"rel" : @0,
                                 @"loop" : @0,
                                 @"enablejsapi" : @1,
                                 @"modestbranding" : @0
                                 };
    [self.playerView loadWithVideoId:_youtubeID playerVars:playerVars];
    
//    _videoPlayerWebView = [[UIWebView alloc] initForAutolayout];
//    _videoPlayerWebView.scrollView.scrollEnabled = NO;
//    [_videoPlayerWebView setBackgroundColor:[UIColor blackColor]];
//    _videoPlayerWebView.alpha = 0;
//    _videoPlayerWebView.delegate = self;
////    _videoPlayerWebView.allowsInlineMediaPlayback = YES;
//    
//    [self addSubview:_videoPlayerWebView];
//    NSMutableArray *webViewConstaint = @[].mutableCopy;
//    [webViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_videoPlayerWebView
//                                                             attribute:NSLayoutAttributeTop
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self
//                                                             attribute:NSLayoutAttributeTop
//                                                            multiplier:1.0f constant:0.0f]];
//    [webViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_videoPlayerWebView
//                                                             attribute:NSLayoutAttributeHeight
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self
//                                                             attribute:NSLayoutAttributeHeight
//                                                            multiplier:1.0f constant:-1.0f]];
//    [webViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_videoPlayerWebView
//                                                             attribute:NSLayoutAttributeLeft
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self
//                                                             attribute:NSLayoutAttributeLeft
//                                                            multiplier:1.0f constant:0.0f]];
//    [webViewConstaint addObject:[NSLayoutConstraint constraintWithItem:_videoPlayerWebView
//                                                             attribute:NSLayoutAttributeRight
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self
//                                                             attribute:NSLayoutAttributeRight
//                                                            multiplier:1.0f constant:0.0f]];
//    [self addConstraints:webViewConstaint];
//    [self layoutIfNeeded];
    
//    [_videoPlayerWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/embed/%@?playsinline=1&enablejsapi=1&showinfo=0&rel=0&autohide=1&fs=0",_youtubeID]]]];
//    NSString* trigger = @"window.onload = function(){window.setInterval(function(){ document.getElementsByTagName('video')[0].setAttribute('webkit-playsinline','true'); }, 100);};";
//    [_videoPlayerWebView stringByEvaluatingJavaScriptFromString:trigger];
    
//    [self setupVideoPlayer:_youtubeID];
}

- (void)initLine {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"#5c5c5c"]];
    [self addSubview:lineView];
}

- (void)initGesture {
    UIView* view = [[UIView alloc] initWithFrame:self.frame];
    [view setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchVideo)];
    [view addGestureRecognizer:tap];
    [view addGestureRecognizer:pinch];
    [view setUserInteractionEnabled:NO];
    [self addSubview:view];
    
}
- (void)videoWebviewResize {
    if (self.frame.size.width > self.frame.size.height) {
        _videoPlayerWebView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } else {
        _videoPlayerWebView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
    }
}
- (void)pinchVideo {
    NSLog(@"do not thing");
}
- (void)playVideo {
    NSLog(@"點");
    //[_videoPlayerWebView stringByEvaluatingJavaScriptFromString:@"playVideo()"];
}

- (void) playerViewDidBecomeReady:(YTPlayerView *)playerView {
    [UIView animateWithDuration:0.3 animations:^(){
        playerView.alpha = 1;
    }];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    _videoPlayerWebView.alpha = 1;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    
    _videoPlayerWebView.alpha = 0;
}

- (void) setupVideoPlayer: (NSString*) youtubeVideoId {
//    [_videoPlayerWebView stopLoading];
    
    NSError *error = nil;
    
    //Prepare the HTML from the template
    NSString *template = [NSString stringWithContentsOfFile:
                          [[NSBundle mainBundle]
                           pathForResource:@"YouTubeTemplate" ofType:@"html"]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    NSString *htmlStr = [NSString stringWithFormat: template,
                         self.videoPlayerWebView.frame.size.width, self.videoPlayerWebView.frame.size.height,
                         self.videoPlayerWebView.frame.size.width, self.videoPlayerWebView.frame.size.height,
                         youtubeVideoId];
    
    //Write the HTML file to disk
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *tmpFile = [tmpDir stringByAppendingPathComponent: @"video.html"];
    [htmlStr writeToFile: tmpFile
              atomically: TRUE
                encoding: NSUTF8StringEncoding error:NULL];
    //Enable autoplay
    self.videoPlayerWebView.mediaPlaybackRequiresUserAction = NO;
    
    //Load the HTML
    [self.videoPlayerWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:tmpFile isDirectory:NO]]];
    //Autoplay doesn't work with loadHTMLString
//        [self.videoPlayerWebView loadHTMLString:htmlStr baseURL:nil];
}

@end
