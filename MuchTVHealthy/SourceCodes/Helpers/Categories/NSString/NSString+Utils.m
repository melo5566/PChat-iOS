//
//  NSString+Utils.m
//  Community
//
//  Created by Weiyu Chen on 2015/2/6.
//  Copyright (c) 2015年 Fanzytv. All rights reserved.
//

#import "NSString+Utils.h"

#define REGEX_URL @"((http(s)?://[[0-9a-zA-Z]-_]+(\\.[[0-9a-zA-Z]-_]+)+\\.?(:[0-9]+)?|[[0-9a-zA-Z]-_]+(\\.[[0-9a-zA-Z]-_]+)+\\.?(:[0-9]+)?\\/|[\\.[0-9a-zA-Z]-_]+(\\.com|\\.org|\\.edu|\\.gov|\\.tw|fanxin.tv(:[0-9]+)?))([A-Za-z0-9.\\-_~:/?#\\[\\]@!$&'\\(\\)*+,;=]+)?)"
#define REGEX_MAIL @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"

@implementation NSString (Utils)

/**
 *  判斷是否"是空字串"，與 isNotEmpty 成對，視語意使用
 */
- (BOOL) isEmpty
{
    return [self.trimmedString isEqualToString:@""];
}

/**
 *  判斷是否"不是空字串"，與 isEmpty 成對，視語意使用
 */
- (BOOL) isNotEmpty
{
    return ![self isEmpty];
}

- (NSMutableArray *) getURL
{
    NSString* inputString = [self trimmedString];
    NSString* matchedString;
    NSMutableArray *matchStrs = @[].mutableCopy;
    NSError* error = nil;
    
    NSRegularExpression *URLRegex = [NSRegularExpression regularExpressionWithPattern:REGEX_URL options:0 error:&error];
    NSArray *URLMatches = [URLRegex matchesInString:inputString options:0 range:NSMakeRange(0, [inputString length])];
    
    // 檢查URL是否與E-MAIL重疊
    NSRegularExpression *mailRegex = [NSRegularExpression regularExpressionWithPattern:REGEX_MAIL options:0 error:&error];
    NSArray *mailMatches = [mailRegex matchesInString:[inputString lowercaseString] options:0 range:NSMakeRange(0, [inputString length])];
    for (NSTextCheckingResult *URLMatch in URLMatches)
    {
        BOOL isPartOfMail = NO;
        for (NSTextCheckingResult *mailMatch in mailMatches) {
            if ([URLMatch range].location >= [mailMatch range].location && [URLMatch range].location + [URLMatch range].length <= [mailMatch range].location + [mailMatch range].length) {
                isPartOfMail = YES;
                break;
            }
        }
        
        if (!isPartOfMail) {
            matchedString = [inputString substringWithRange:[URLMatch range]];
            [matchStrs addObject:matchedString];
        }
    }
    
    return matchStrs;
}

/**
 *  判斷是否"是email"，與 isNotEmail 成對，視語意使用
 */
- (BOOL) isEmail
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

/**
 *  判斷是否"不是email"，與 isEmail 成對，視語意使用
 */
- (BOOL) isNotEmail
{
    return ![self isEmail];
}

/**
 *  取得 youtube 網址中的 video code
 *  判斷規則：網址中包括的 11 個字元(包括 - )，也許可能有漏洞
 */
- (NSString *) getYoutubeVieoCode
{
    NSString* inputString = [self trimmedString];
    NSString* matchedString;
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)" options:0 error:&error];
    NSArray* matches = [regex matchesInString:inputString options:0 range:NSMakeRange(0, [inputString length])];
    
    for ( NSTextCheckingResult* match in matches )
    {
        matchedString = [inputString substringWithRange:[match range]];
    }
    
    return matchedString;
}
// ** 檢查是否為有效的 Youtube 網址 ** //
- (BOOL) isLegalYoutubeURL {
    NSString *matchedString = [self getYoutubeVieoCode];
    return [matchedString isNotEmpty] ? YES : NO;
}
// ** 取得 youtube 影片預設圖(HqDefault)480*360  影片大圖 ** //
- (NSString *) getYoutubeVieoHqDefaultImage
{
    NSString *youtubeVieoCode = [self getYoutubeVieoCode];
    return [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",youtubeVieoCode];
}
// ** 取得 youtube 影片預設圖(MqDefault)320*180 影片大圖 去黑邊 ** //
- (NSString *) getYoutubeVieoMqDefaultImage
{
    NSString *youtubeVieoCode = [self getYoutubeVieoCode];
    return [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/mqdefault.jpg",youtubeVieoCode];
}
// ** 取得 youtube 影片預設圖(SdDefault)640*480 影片大圖 ** //
- (NSString *) getYoutubeVieoSdDefaultImage
{
    NSString *youtubeVieoCode = [self getYoutubeVieoCode];
    return [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/sddefault.jpg",youtubeVieoCode];
}
// ** 取得 youtube 影片預設圖(MaxresDefault)1280*720 影片大圖 ** //
- (NSString *) getYoutubeVieoMaxreDefaultImage
{
    NSString *youtubeVieoCode = [self getYoutubeVieoCode];
    return [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/maxresdefault.jpg",youtubeVieoCode];
}

/**
 *  由 Facebook link 取出 id
 */
- (NSString *) getFacebookNameTag
{
    NSString* inputString = [self trimmedString];
    NSString* matchedString;
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"//www.facebook.com/([a-zA-Z0-9_-]{1,})" options:0 error:&error];
    NSArray* matches = [regex matchesInString:inputString options:0 range:NSMakeRange(0, [inputString length])];
    
    for ( NSTextCheckingResult* match in matches )
    {
        matchedString = [inputString substringWithRange:[match range]];
    }
    
    return matchedString;
}

/**
 *  日期格式轉換
 *  from 20130718221122 to 2013/07/18 18:22
 *  如果無法轉換則不處理
 */
- (NSString *) stringToFormattedDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* date = [dateFormat dateFromString:self];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString* outputString = [dateFormat stringFromDate:date];
    
    return (outputString) ? outputString : self;
}

/**
 *  日期格式轉換
 *  from 1378956547000 to 2013/09/12 11:29
 */
- (NSString *) stringNSTimeIntervalToFormattedDate
{
    NSTimeInterval timeInterval = ([self doubleValue] / 1000);
    if(timeInterval > 0.0f)
    {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString* outputString = [dateFormatter stringFromDate:date];
        
        return outputString;
    }
    
    return self;
}

/**
 *  依字串長度及字型、寬度，計算多行字串之尺寸
 */
- (CGSize) sizeOfStringWithSystemFontSize:(CGFloat) fontSize andMaxLength:(CGFloat) maxLength {
    CGSize maximumLabelSize = CGSizeMake(maxLength, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading |
    NSStringDrawingUsesLineFragmentOrigin;
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGRect labelBounds = [self boundingRectWithSize:maximumLabelSize
                                            options:options
                                         attributes:attr
                                            context:nil];
    return labelBounds.size;
}

- (CGSize) sizeOfStringWithFont:(UIFont *) font andMaxLength:(CGFloat) maxLength {
    CGSize maximumLabelSize = CGSizeMake(maxLength, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading |
    NSStringDrawingUsesLineFragmentOrigin;
    
    NSDictionary *attr = @{NSFontAttributeName: font};
    CGRect labelBounds = [self boundingRectWithSize:maximumLabelSize
                                            options:options
                                         attributes:attr
                                            context:nil];
    return labelBounds.size;
}

/**
 *  依字串長度及字型、寬度，計算多行字串之TextView尺寸
 */
- (CGFloat) heightOfTextViewWithSystemFontSize:(CGFloat) fontSize andMaxLength:(CGFloat) maxLength
{
//    CGSize size = [self sizeOfStringWithSystemFontSize:fontSize andMaxLength:maxLength-11];
    CGSize size = [self sizeOfStringWithSystemFontSize:fontSize andMaxLength:maxLength];
//    CGFloat returnHeight = size.height + 16 ;
    CGFloat returnHeight = size.height + 16;
    
    return returnHeight;
}

/**
 *  去除文字兩端之空白字元
 */
- (NSString *) trimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  指定字串長度，過長截斷
 */
- (NSString *) truncatedString:(NSUInteger) numberOfCharacters
{
    NSRange stringRange = {0, MIN([self length], numberOfCharacters)};
    stringRange = [self rangeOfComposedCharacterSequencesForRange:stringRange];
    return [self substringWithRange:stringRange];
}

/**
 *  把數字加上千位逗號
 */
+ (NSString *) numberToThousandSeparatorFormat:(NSInteger) number
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.positiveFormat = @"#,###";
    return [formatter stringFromNumber:[NSNumber numberWithInteger:number]];
}

/**
 *  NSString轉換為NSDate
 *  from @"1378956547000" to NSDate
 */
- (NSDate *) stringToNSDate
{
    NSTimeInterval timeInterval = ([self doubleValue] / 1000);
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

@end
