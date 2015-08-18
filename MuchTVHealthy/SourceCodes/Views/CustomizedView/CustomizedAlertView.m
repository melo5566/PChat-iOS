//
//  CustomizedAlertView.m
//  Community
//
//  Created by Weiyu Chen on 2015/3/13.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "CustomizedAlertView.h"

#define MESSAGE_MIN_LINE_COUNT 3
#define MESSAGE_MAX_LINE_COUNT 5
#define GAP 35
#define CANCEL_BUTTON_PADDING_TOP 40
#define CONTENT_PADDING_LEFT 10
#define CONTENT_PADDING_TOP 40
#define CONTENT_PADDING_BOTTOM 25
#define BUTTON_HEIGHT 44
#define CONTAINER_WIDTH (kScreenWidth - 20)

@interface CustomizedAlertView ()
@property (nonatomic, strong) NSMutableArray            *items;
@property (nonatomic, strong) UIWindow                  *backgroundWindow;
@property (nonatomic, weak) UIWindow                    *oldKeyWindow;
@property (nonatomic, assign) UIViewTintAdjustmentMode  oldTintAdjustmentMode;
@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UILabel                   *messageLabel;
@property (nonatomic, strong) UIView                    *containerView;
@property (nonatomic, strong) NSMutableArray            *buttons;
@end


#pragma mark - CustomizedAlertItem
@interface CustomizedAlertItem : NSObject
@property (nonatomic, copy) NSString                            *title;
@property (nonatomic, assign) CustomizedAlertViewButtonType     type;
@property (nonatomic, copy) CustomizedAlertViewHandler          action;
@end

@implementation CustomizedAlertItem

@end

// =====================
@implementation CustomizedAlertView

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message {
    self = [super init];
    if (self) {
        _title      = title;
        _message    = message;
        self.items  = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Class methods
- (void)showBackground {
    if (!_backgroundWindow) {
        _backgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_backgroundWindow makeKeyAndVisible];
        _backgroundWindow.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             
                             _backgroundWindow.alpha = 1;
                         }];
    }
}

- (void)hideBackgroundAnimated:(BOOL)animated {
    if (!animated) {
        [_backgroundWindow removeFromSuperview];
        _backgroundWindow = nil;
        return;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         _backgroundWindow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_backgroundWindow removeFromSuperview];
                         _backgroundWindow = nil;
                     }];
}

#pragma mark - Public
- (void)addButtonWithTitle:(NSString *)title type:(CustomizedAlertViewButtonType)type handler:(CustomizedAlertViewHandler)handler {
    CustomizedAlertItem *item = [[CustomizedAlertItem alloc] init];
    item.title  = title;
    item.type   = type;
    item.action = handler;
    [self.items addObject:item];
}

- (void) show {
    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
#ifdef __IPHONE_7_0
    if ([self.oldKeyWindow respondsToSelector:@selector(setTintAdjustmentMode:)]) { // for iOS 7
        self.oldTintAdjustmentMode = self.oldKeyWindow.tintAdjustmentMode;
        self.oldKeyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    }
#endif
    
    [self showBackground];
    [self setup];
    [self initAlertViewLayout];
    
    CGRect rect = self.containerView.frame;
    CGRect originalRect = rect;
    rect.origin.y = _backgroundWindow.bounds.size.height;
    self.containerView.frame = rect;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.containerView.frame = originalRect;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Layout
- (void)initAlertViewLayout {
    CGFloat height = [self preferredHeight];
    CGFloat left   = (kScreenWidth - CONTAINER_WIDTH) * 0.5;
    CGFloat top    = (kScreenHeight - height) * 0.5;
    
    self.containerView.transform        = CGAffineTransformIdentity;
    self.containerView.frame            = CGRectMake(left, top, CONTAINER_WIDTH, height);
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
    
    CGFloat containerHeight = CONTENT_PADDING_TOP;
    if (self.titleLabel) {
        self.titleLabel.text  = self.title;
        CGFloat height        = [self heightForTitleLabel];
        self.titleLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, containerHeight, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        containerHeight += height;
    }
    if (self.messageLabel) {
        if (containerHeight > CONTENT_PADDING_TOP) {
            containerHeight += GAP;
        }
        self.messageLabel.text  = self.message;
        CGFloat height          = [self heightForMessageLabel];
        self.messageLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, containerHeight, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        containerHeight += height;
    }
    if (self.items.count > 0) {
        CGFloat buttonWidth = (self.containerView.bounds.size.width - 3*CONTENT_PADDING_LEFT)/2;
        if (containerHeight > CONTENT_PADDING_TOP) {
            containerHeight += GAP;
        }
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(CONTENT_PADDING_LEFT + i * (buttonWidth+CONTENT_PADDING_LEFT), containerHeight, buttonWidth, BUTTON_HEIGHT);
                if (self.buttons.count > 1) {
//                    containerHeight += BUTTON_HEIGHT + GAP;
                }
            }
    }
}

- (CGFloat)preferredHeight {
    CGFloat height = CONTENT_PADDING_TOP;
    if (self.title) {
        height += [self heightForTitleLabel];
    }
    if (self.message) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        height += [self heightForMessageLabel];
    }
    if (self.items.count > 0) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
//            height += (BUTTON_HEIGHT + GAP) * self.items.count - GAP;
            height += BUTTON_HEIGHT;
            if (self.buttons.count > 2 && ((CustomizedAlertItem *)[self.items lastObject]).type == CustomizedAlertViewButtonTypeCancel) {
                height += CANCEL_BUTTON_PADDING_TOP;
            }
    }
    height += CONTENT_PADDING_BOTTOM;
    return height;
}

- (CGFloat)heightForTitleLabel {
    if (self.titleLabel) {
        CGSize maximumLabelSize = CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, MAXFLOAT);
        
        NSStringDrawingOptions options = NSStringDrawingUsesFontLeading |
        NSStringDrawingUsesLineFragmentOrigin;
        
        NSDictionary *attr = @{NSFontAttributeName: self.titleLabel.font};
        CGRect labelBounds = [self.title boundingRectWithSize:maximumLabelSize
                                                      options:options
                                                   attributes:attr
                                                      context:nil];
        
        return labelBounds.size.height;
    }
    return 0;
}

- (CGFloat)heightForMessageLabel {
    CGFloat minHeight = MESSAGE_MIN_LINE_COUNT * self.messageLabel.font.lineHeight;
    if (self.messageLabel) {
        CGFloat maxHeight = MESSAGE_MAX_LINE_COUNT * self.messageLabel.font.lineHeight;
        CGSize maximumLabelSize = CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight);
        
        NSStringDrawingOptions options = NSStringDrawingUsesFontLeading |
        NSStringDrawingUsesLineFragmentOrigin;
        
        NSDictionary *attr = @{NSFontAttributeName: self.messageLabel.font};
        CGRect labelBounds = [self.message boundingRectWithSize:maximumLabelSize
                                                      options:options
                                                   attributes:attr
                                                      context:nil];
        
        return labelBounds.size.height;
//        return MAX(minHeight, labelBounds.size.height);
    }
    return minHeight;
}

#pragma mark - Setup
- (void)setup {
    [self setupContainerView];
    [self updateTitleLabel];
    [self updateMessageLabel];
    [self setupButtons];
}


- (void)setupContainerView {
    self.containerView                      = [[UIView alloc] initForAutolayout];
    self.containerView.backgroundColor      = [UIColor whiteColor];
    self.containerView.layer.shadowRadius   = 2;
    self.containerView.layer.shadowOpacity  = 0.5;
    [_backgroundWindow addSubview:_containerView];
}

- (void)updateTitleLabel {
    if (self.title) {
        if (!self.titleLabel) {
            self.titleLabel                             = [[UILabel alloc] initWithFrame:self.bounds];
            self.titleLabel.textAlignment               = NSTextAlignmentCenter;
            self.titleLabel.backgroundColor             = [UIColor clearColor];
            self.titleLabel.font                        = [UIFont boldSystemFontOfSize:26];
            self.titleLabel.textColor                   = [UIColor colorWithHexString:@"#2f2b2b"];
            self.titleLabel.adjustsFontSizeToFitWidth   = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
            self.titleLabel.minimumScaleFactor = 0.75;
#else
            self.titleLabel.minimumFontSize = self.titleLabel.font.pointSize * 0.75;
#endif
            [self.containerView addSubview:self.titleLabel];
#if DEBUG_LAYOUT
            self.titleLabel.backgroundColor = [UIColor redColor];
#endif
        }
        self.titleLabel.text = self.title;
    } else {
        [self.titleLabel removeFromSuperview];
        self.titleLabel = nil;
    }
}

- (void)updateMessageLabel {
    if (self.message) {
        if (!self.messageLabel) {
            self.messageLabel                           = [[UILabel alloc] initWithFrame:self.bounds];
            self.messageLabel.textAlignment             = NSTextAlignmentCenter;
            self.messageLabel.backgroundColor           = [UIColor clearColor];
            self.messageLabel.font                      = [UIFont systemFontOfSize:20];
            self.messageLabel.textColor                 = [UIColor colorWithHexString:@"#2f2b2b"];
            self.messageLabel.numberOfLines             = MESSAGE_MAX_LINE_COUNT;
            self.messageLabel.adjustsFontSizeToFitWidth = YES;
            self.messageLabel.minimumScaleFactor        = 0.75;
            [self.containerView addSubview:self.messageLabel];
#if DEBUG_LAYOUT
            self.messageLabel.backgroundColor = [UIColor redColor];
#endif
        }
        self.messageLabel.text = self.message;
    } else {
        [self.messageLabel removeFromSuperview];
        self.messageLabel = nil;
    }
}

- (void)setupButtons {
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UIButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index {
    CustomizedAlertItem *item = self.items[index];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.layer.cornerRadius = 5;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:item.title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    switch (item.type) {
        case CustomizedAlertViewButtonTypeCancel:
            [button setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
            [button setTitleColor:[UIColor colorWithHexString:@"#a9a9a9"] forState:UIControlStateNormal];
            break;
        case CustomizedAlertViewButtonTypeDefaultPink:
            [button setBackgroundColor:[UIColor colorWithHexString:kDefaultYellowColorHexString]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case CustomizedAlertViewButtonTypeDefaultGreen:
            [button setBackgroundColor:[UIColor colorWithHexString:@"#4f9999"]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case CustomizedAlertViewButtonTypeDefaultLightGreen:
            [button setBackgroundColor:[UIColor colorWithHexString:@"#ecf8f7"]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case CustomizedAlertViewButtonTypeDefaultBlue:
        default:
            [button setBackgroundColor:[UIColor colorWithHexString:@"#3f6eb4"]];
            break;
    }
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Actions

- (void)buttonAction:(UIButton *)button {
    CustomizedAlertItem *item = self.items[button.tag];
    if (item.action) {
        item.action(self);
    }
    
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup {
    CGRect rect = self.containerView.frame;
    rect.origin.y = _backgroundWindow.bounds.size.height;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.containerView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [self hideBackgroundAnimated:YES];
    
    UIWindow *window = self.oldKeyWindow;
#ifdef __IPHONE_7_0
    if ([window respondsToSelector:@selector(setTintAdjustmentMode:)]) {
        window.tintAdjustmentMode = self.oldTintAdjustmentMode;
    }
#endif
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window makeKeyWindow];
    window.hidden = NO;
}
@end
