//
//  DiscussionObject.h
//  493_Project
//
//  Created by Wu Peter on 2015/11/25.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DiscussionObject : NSObject
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, strong) NSString          *authorName;
@property (nonatomic, strong) NSString          *authorPhoto;
@property (nonatomic, strong) NSString          *createTime;
@property (nonatomic, strong) NSString          *objectID;
@property (nonatomic, strong) NSMutableArray    *imageArray;
- (id)initWithPFObject:(PFObject *)object;
@end

@interface ReplyObject : NSObject
@property (nonatomic, strong) NSString      *content;
@property (nonatomic, strong) NSString      *authorName;
@property (nonatomic, strong) NSString      *authorPhoto;
@property (nonatomic, strong) NSString      *createTime;
- (id)initWithPFObject:(PFObject *)object;
@end

@interface WorkloadObject : NSObject
@property (nonatomic, strong) NSString              *department;
@property (nonatomic, strong) NSString              *course;
@property (nonatomic, strong) NSString              *season;
@property (nonatomic, strong) NSString              *year;
@property (nonatomic, strong) NSString              *voter;
@property (nonatomic, strong) NSString              *courseID;
@property (nonatomic) NSUInteger                    light;
@property (nonatomic) NSUInteger                    moderate;
@property (nonatomic) NSUInteger                    heavy;
@property (nonatomic) NSUInteger                    exHeavy;
- (id)initWithPFObject:(PFObject *)object;
@end

@interface CategoryObject : NSObject
@property (nonatomic, strong) NSString              *category;
@property (nonatomic, strong) NSString              *name;
@property (nonatomic, strong) NSString              *imageUrl;
- (id)initWithPFObject:(PFObject *)object;
@end