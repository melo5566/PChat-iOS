//
//  PhotoViewerViewController.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/5.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MessageObject.h"

@interface PhotoViewerViewController : BaseViewController
@property (nonatomic, strong) UIImage           *image;
@property (nonatomic, strong) MessageObject     *messageObject;
@property (nonatomic, strong) NSString          *type;
@end
