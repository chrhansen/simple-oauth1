//
//  NSString+URLEncoding.h
//  IdeaFlasher Authentication
//
//  Created by Christian Hansen on 24/11/12.
//  Copyright (c) 2012 Kwamecorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)utf8AndURLEncode;
- (NSString *)URLDecodedString;
+ (NSString *)getUUID;
+ (NSString *)getNonce;
+ (NSString *)queryStringWithParameters:(NSDictionary *)parameters;

@end
