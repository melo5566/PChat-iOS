//
//  ChatroomViewController.h
//  493_Project
//
//  Created by Wu Peter on 2015/10/31.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OrtcClient.h"
#import "RealTimeCloudStorage.h"
#import "MessageObject.h"

@interface ChatroomViewController : BaseViewController
{
@private
    
    OrtcClient* ortcClient;
    void (^onMessage)(OrtcClient* ortc, NSString* channel, NSString* message);
}
@property (nonatomic, strong) ChatroomListObject        *chatroomObject;
@end
