//
//  ChatroomStickerView.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/5.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatroomStickerViewDelegate <NSObject>

- (void) sendStickerWithImageName:(NSString *)stickerImageName;

@end

@interface ChatroomStickerView : UIView
@property (nonatomic, weak) id <ChatroomStickerViewDelegate> delegate;
@end

