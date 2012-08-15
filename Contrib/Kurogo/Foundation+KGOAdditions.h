/*
 * Copyright © 2010 - 2012 Modo Labs Inc. All rights reserved.
 *
 * The license governing the contents of this file is located in the LICENSE
 * file located at the root directory of this distribution. If the LICENSE file
 * is missing, please contact sales@modolabs.com.
 *
 */

#import <Foundation/Foundation.h>

typedef enum {
    KGOSignPositive = 1,
    KGOSignNegative = -1,
    KGOSignZero = 0
} KGOSign;

KGOSign KGOGetIntegerSign(NSInteger x);

@interface NSString (KGOAdditions)
+ (NSString *)stringByTrimmingURLPortNumber:(NSString *)baseString;
@end


@interface NSURL (KGOAdditions)

+ (NSString *)urlEscapeWithPercents:(NSString *)string;
+ (NSString *)queryStringWithParameters:(NSDictionary *)parameters;
+ (NSURL *)URLWithQueryParameters:(NSDictionary *)parameters baseURL:(NSURL *)baseURL;
+ (NSDictionary *)parametersFromQueryString:(NSString *)queryString;
- (NSDictionary *)queryParameters;

@end


@interface NSFileManager (KGOAdditions)

+ (NSString *)applicationCachesDirectory;

@end


@interface NSDate (KGOAdditions)

- (NSString *)agoString;

- (NSString *)weekDateTimeString;

- (NSString *)dayTimeString;

- (NSString *)weekDateString;

- (NSString *)weekMonthDayYearString;

@end

@interface NSSet (KGOAdditions)

- (NSArray *)sortedArrayUsingKey:(NSString *)key ascending:(BOOL)ascending;

@end


@interface NSArray (KGOAdditions)

- (NSArray *)mappedArrayUsingBlock:(id(^)(id element))block;

@end

@interface NSArray (KGOWebBridge)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableDictionary (KGOAdditions)

- (void)setObjectIfExists:(id)object forKey:(id)key;

@end

@interface NSArray (JSONParser)

// returns nil on failure
- (NSString *)forcedStringAtIndex:(NSInteger)index;
- (NSString *)stringAtIndex:(NSInteger)index;
- (NSNumber *)numberAtIndex:(NSInteger)index;
- (NSArray *)arrayAtIndex:(NSInteger)index;
- (NSDate *)dateAtIndex:(NSInteger)index;
- (NSDate *)dateAtIndex:(NSInteger)index format:(NSString *)format;
- (NSDictionary *)dictionaryAtIndex:(NSInteger)index;

// returns false on failure
- (BOOL)boolAtIndex:(NSInteger)index;

// returns NSNotFound on failure
- (NSInteger)integerAtIndex:(NSInteger)index;

// returns 0.0 on failure
- (CGFloat)floatAtIndex:(NSInteger)index;

// returns defaultValue on failure
- (CGFloat)floatAtIndex:(NSInteger)index defaultValue:(CGFloat)defaultValue;

@end


@interface NSDictionary (JSONParser)

// returns nil on type failure
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)forcedStringForKey:(NSString *)key;

// casts numbers to strings
- (NSString *)nonemptyStringForKey:(NSString *)key;
- (NSString *)nonemptyForcedStringForKey:(NSString *)key;

- (NSNumber *)numberForKey:(NSString *)key;
- (NSNumber *)forcedNumberForKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key;
- (NSDate *)dateForKey:(NSString *)key;
- (NSDate *)dateForKey:(NSString *)key format:(NSString *)format;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

// returns false on failure
- (BOOL)boolForKey:(NSString *)key;

// returns NSNotFound on failure
- (NSInteger)integerForKey:(NSString *)key;

// returns 0.0 on failure
- (CGFloat)floatForKey:(NSString *)key;

// returns defaultValue on failure
- (CGFloat)floatForKey:(NSString *)key defaultValue:(CGFloat)defaultValue;

- (double)doubleForKey:(NSString *)key;

@end

