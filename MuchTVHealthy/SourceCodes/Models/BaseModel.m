//
//  BaseModel.m
//  Community
//
//  Created by Weiyu Chen on 2015/2/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

/**
 *  一般 URLRequest
 */
- (NSMutableURLRequest *) generalURLRequestWithHTTPMethod:(NSString *)method API:(NSString *)apiName withParams:(NSDictionary *) params {
    NSLog(@"API: %@", apiName);
    if (params) {
        NSLog(@"Param: %@", params);
    }
    //轉成 NSUTF8StringEncoding 避免url含有中文造成crash
    apiName = [apiName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:[method uppercaseString]
                                                                                 URLString:apiName
                                                                                parameters:params
                                                                                     error:nil];
    // set request timeout
    [request setTimeoutInterval:30];
    
    return request;
}




#pragma mark - check network
/**
 *  檢查網路是否有連線，並執行下一個動作
 */
- (void) checkNetworkReachabilityAndDoNext:(void (^)(void))nextStep {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
            [self.delegate hasNoNetworkConnection];
        } else {
            NSLog(@"no network connection, and you don't implement the delegate method");
        }
    }
    else {
        nextStep();
    }
}

/**
 *  檢查網路狀態，如果有網路執行 nextStep，沒有網路則執行 failStep
 */
-(void) checkNetworkReachabilityAndDoNext:(void (^)(void))nextStep noNetwork:(void (^)(void))failStep {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable) {
        failStep();
    } else {
        nextStep();
    }
    
}

/**
 *  檢查網路是否連線
 */
- (void) checkNetworkReachability {
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"api.parse.com"];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable) {
        
        if ([self.delegate respondsToSelector:@selector(hasNoNetworkConnection)]) {
            [self.delegate hasNoNetworkConnection];
        } else {
            NSLog(@"no network connection, and you don't implement the delegate method");
        }
        
    }
    
}

@end
