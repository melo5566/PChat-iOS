//
//  BaseModel.h
//  Community
//
//  Created by Weiyu Chen on 2015/2/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>

// ====================================================
@protocol BaseModelDelegate <NSObject>

@optional
- (void) hasNoNetworkConnection;

@end

// ====================================================
@interface BaseModel : NSObject

//@property (nonatomic, weak) id <BaseModelDelegate> baseModeldelegate;
@property (nonatomic, weak) id <BaseModelDelegate> delegate;


#pragma mark - request method
- (NSMutableURLRequest *) generalURLRequestWithHTTPMethod:(NSString *)method API:(NSString *)apiName withParams:(NSDictionary *) params;


- (NSMutableURLRequest *) cachedURLRequestWithHTTPMethod:(NSString *) method API:(NSString *) apiName andUserID:(NSNumber *) userID withParams:(NSDictionary *) params;
- (NSMutableURLRequest *) generalURLRequestWithHTTPMethod:(NSString *) method API:(NSString *) apiName andUserID:(NSNumber *) userID withParams:(NSDictionary *) params;
- (NSMutableURLRequest *) JSONFormatURLRequestWithHTTPMethod:(NSString *) method API:(NSString *) apiName andUserID:(NSNumber *) userID withParams:(NSDictionary *) params;
//- (NSMutableURLRequest *) uploadImageURLRequestWithData:(UIImage *) data API:(NSString *) apiName andUserID:(NSNumber *) userID withParams:(NSDictionary *) params;

#pragma mark - check network
- (void) checkNetworkReachability;
- (void) checkNetworkReachabilityAndDoNext:(void (^)(void)) nextStep;
- (void) checkNetworkReachabilityAndDoNext:(void (^)(void)) nextStep noNetwork:(void (^)(void)) failStep;

@end
