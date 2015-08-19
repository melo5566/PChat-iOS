//
//  NSString+Utils.h
//  Community
//
//  Created by Weiyu Chen on 2015/2/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
- (BOOL) isPhoneNumber;
- (BOOL) isPassword;
- (BOOL) isEmpty;
- (BOOL) isNotEmpty;
- (BOOL) isEmail;
- (BOOL) isNotEmail;
- (NSMutableArray *) getURL;
- (NSString *) getYoutubeVieoCode;
- (BOOL) isLegalYoutubeURL;
- (NSString *) getYoutubeVieoHqDefaultImage;
- (NSString *) getYoutubeVieoMqDefaultImage;
- (NSString *) getYoutubeVieoSdDefaultImage;
- (NSString *) getYoutubeVieoMaxreDefaultImage;
- (NSString *) getFacebookNameTag;
- (NSString *) stringToFormattedDate;
- (NSString *) stringNSTimeIntervalToFormattedDate;
- (CGSize) sizeOfStringWithSystemFontSize:(CGFloat) fontSize andMaxLength:(CGFloat) maxLength;
- (CGSize) sizeOfStringWithFont:(UIFont *) font andMaxLength:(CGFloat) maxLength;
- (NSString *) trimmedString;
- (NSString *) truncatedString:(NSUInteger) numberOfCharacters;

+ (NSString *) numberToThousandSeparatorFormat:(NSInteger) number;
- (NSDate *) stringToNSDate;
- (CGFloat) heightOfTextViewWithSystemFontSize:(CGFloat) fontSize andMaxLength:(CGFloat) maxLength;


@end
