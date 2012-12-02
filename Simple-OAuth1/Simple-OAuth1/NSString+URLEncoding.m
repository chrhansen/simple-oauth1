//
//  NSString+URLEncoding.m
//  IdeaFlasher Authentication
//
//  Created by Christian Hansen on 24/11/12.
//  Copyright (c) 2012 Kwamecorp. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSString *)utf8AndURLEncode
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (NSString *)URLDecodedString
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)getUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidStr;
}


+ (NSString *)getNonce
{
    NSString *uuid = [self getUUID];
    return [[uuid substringToIndex:8] stringByReplacingOccurrencesOfString:@"-" withString:@""].lowercaseString;
}

+ (NSString *)queryStringWithParameters:(NSDictionary *)parameters
{
    NSString *queryString;
    NSArray *sortedKeys = [parameters.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    if (sortedKeys == nil
        || sortedKeys.count == 0)
    {
        return @"";
    }
    for (NSString *key in sortedKeys)
    {
        id value = parameters[key];
        if (value && [value isKindOfClass:NSString.class])
        {
            if (!queryString)
            {
                queryString= @"?";
            }
            queryString = [queryString stringByAppendingFormat:@"%@=%@&", key, value];
        }
    }
    queryString = [queryString substringToIndex:queryString.length-1];
    return queryString;
}

@end
