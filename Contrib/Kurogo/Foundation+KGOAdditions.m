/*
 * Copyright © 2010 - 2012 Modo Labs Inc. All rights reserved.
 *
 * The license governing the contents of this file is located in the LICENSE
 * file located at the root directory of this distribution. If the LICENSE file
 * is missing, please contact sales@modolabs.com.
 *
 */

#import "Foundation+KGOAdditions.h"

KGOSign KGOGetIntegerSign(NSInteger x) {
    if (x > 0)
        return KGOSignPositive;
    return (x == 0) ? KGOSignZero : KGOSignNegative;
}

@implementation NSString (KGOAdditions)

+ (NSString *)stringByTrimmingURLPortNumber:(NSString *)baseString {
    if ([baseString rangeOfString:@":"].location != NSNotFound) {
        return [baseString substringToIndex:[baseString rangeOfString:@":"].location];
    }
    return baseString;
}

@end


@implementation NSURL (KGOAdditions)

// modified version of internal URL building method from MIT.
// an internal url with query params would be built as:
// NSURL *url = [NSURL URLWithQueryParameters:queryParameters baseURL:[NSURL internalURLWithModuleTag:moduleTag path:nil]];

/* 
 * Copyright (c) 2010 Massachusetts Institute of Technology
 * Copyright (c) 2011 Modo Labs, Inc
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
+ (NSURL *)internalURLWithModuleTag:(NSString *)tag path:(NSString *)path {
	NSURL *url = nil;
	
	NSArray *urlTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
	if ([urlTypes count]) {
		NSArray *urlSchemes = [[urlTypes objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"];
		NSString *defaultScheme = [urlSchemes objectAtIndex:0];
        
        if (defaultScheme) {
            if ([path rangeOfString:@"/"].location != 0) {
                path = [NSString stringWithFormat:@"/%@", path];
            }
            url = [[[NSURL alloc] initWithScheme:defaultScheme host:tag path:path] autorelease];
        }
	}
    
    return url;
}

// http://simonwoodside.com/weblog/2009/4/22/how_to_really_url_encode/
// NSString's stringByAddingPercentEscapesUsingEncoding leaves out / and &.
+ (NSString *)urlEscapeWithPercents:(NSString *)string {
	CFStringRef escapedCFString =
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef)string,
                                            NULL,
                                            (CFStringRef)@"-+!*'\"();:@&=$,/?%#[]% ",
                                            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *escapedString = [[(NSString *)escapedCFString copy] autorelease];
    CFRelease(escapedCFString);
    return escapedString;
}

// http://www.faqs.org/rfcs/rfc1738.html
+ (NSString *)queryStringWithParameters:(NSDictionary *)parameters {
	NSMutableArray *components = [NSMutableArray arrayWithCapacity:[parameters count]];

    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *encodedKey = [self urlEscapeWithPercents:key];

        if ([value isKindOfClass:[NSString class]]) {        
            NSString *encodedValue = [self urlEscapeWithPercents:value];
            
            [components addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];

        } else if ([value isKindOfClass:[NSDictionary class]]) {
            for (NSString *singleKey in [value allKeys]) {
                NSString *singleValue = [value forcedStringForKey:singleKey];
                if (singleValue) {
                    NSString *encodedSingleValue = [self urlEscapeWithPercents:singleValue];
                    [components addObject:[NSString stringWithFormat:@"%@[%@]=%@", encodedKey, singleKey, encodedSingleValue]];
                }
            }
            
        } else if ([value isKindOfClass:[NSArray class]]) {
            for (NSInteger i = 0; i < [value count]; i++) {
                NSString *singleValue = [value forcedStringAtIndex:i];
                if (singleValue) {
                    NSString *encodedSingleValue = [self urlEscapeWithPercents:singleValue];
                    [components addObject:[NSString stringWithFormat:@"%@[%d]=%@", encodedKey, i, encodedSingleValue]];
                }
            }
        } else if ([value isKindOfClass:[NSNumber class]]) {
            NSString *encodedValue = [value description];
            [components addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
        }
        
    }];

	return [components componentsJoinedByString:@"&"];
}

+ (NSURL *)URLWithQueryParameters:(NSDictionary *)parameters baseURL:(NSURL *)baseURL {
    NSString *queryString = [NSString stringWithFormat:@"?%@", [NSURL queryStringWithParameters:parameters]];
    return [NSURL URLWithString:queryString relativeToURL:baseURL];
}

// TODO: create backwards equivalent of +queryStringWithParameters:
// so we can parse queries like ?blah[a]=2&blah[b]=3
+ (NSDictionary *)parametersFromQueryString:(NSString *)queryString {
    NSArray *components = [[queryString stringByReplacingOccurrencesOfString:@"+" withString:@"%20"] componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *aComponent in components) {
        NSArray *parts = [aComponent componentsSeparatedByString:@"="];
        NSString *key = [[parts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dictionary setObject:val forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)queryParameters {
    return [NSURL parametersFromQueryString:[self query]];
}

@end


@implementation NSFileManager (KGOAdditions)

+ (NSString *)applicationCachesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end


@implementation NSDate (KGOAdditions)

- (NSString *)agoString {
    NSString *result = nil;
    int seconds = -(int)[self timeIntervalSinceNow];
    int minutes = seconds / 60;
    if (minutes < 60) {
        if (minutes == 0) {
            result = NSLocalizedString(@"CORE_JUST_NOW", @"just now");
        } else if (minutes == 1) {
            result = NSLocalizedString(@"CORE_1_MINUTE_AGO", @"1 minute ago");
        } else {
            result = [NSString stringWithFormat:NSLocalizedString(@"CORE_%d_MINUTES_AGO", @"%d minutes ago"), minutes];
        }
    } else {
        int hours = minutes / 60;
        if (hours < 24) {
            if (hours == 1) {
                result = NSLocalizedString(@"CORE_1_HOUR_AGO", @"1 hour ago");
            } else {
                result = [NSString stringWithFormat:NSLocalizedString(@"CORE_%d_HOURS_AGO", @"%d hours ago"), minutes];
            }
        } else {
            int days = hours / 24;
            if (days < 7) {
                if (days == 1) {
                    result = NSLocalizedString(@"CORE_1_DAY_AGO", @"1 day ago");
                } else {
                    result = [NSString stringWithFormat:NSLocalizedString(@"CORE_%d_DAYS_AGO", @"%d days ago"), days];
                }
            } else {
                static NSDateFormatter *shortFormatter = nil;
                if (shortFormatter == nil) {
                    shortFormatter = [[NSDateFormatter alloc] init];
                    [shortFormatter setDateStyle:NSDateFormatterMediumStyle];
                    [shortFormatter setTimeStyle:NSDateFormatterNoStyle];
                }
                result = [shortFormatter stringFromDate:self];
            }
        }
    }
    return result;
}

- (NSString *)weekDateTimeString {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return [formatter stringForObjectValue:self];
}

- (NSString *)dayTimeString {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];    
    [formatter setDateStyle:kCFDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return [formatter stringForObjectValue:self];
}

- (NSString *)weekDateString {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:kCFDateFormatterNoStyle];
    return [formatter stringForObjectValue:self];
}

- (NSString *)weekMonthDayYearString {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];    
    [formatter setDateFormat:@"EEEE MMM d, yyyy"];
    return [formatter stringFromDate:self];
}

@end


@implementation NSSet (KGOAdditions)

- (NSArray *)sortedArrayUsingKey:(NSString *)key ascending:(BOOL)ascending
{
    NSArray *result = nil;
    id obj = [self anyObject];
    SEL selector = NSSelectorFromString(key);
    if ([obj respondsToSelector:selector]) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
        NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
        result = [self sortedArrayUsingDescriptors:descriptors];
    }
    return result;
}

@end




@implementation NSArray (KGOAdditions)

- (NSArray *)mappedArrayUsingBlock:(id (^)(id element))block
{
    NSMutableArray *queue = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [queue addObject:block(obj)];
    }];
    return [[queue copy] autorelease];
}

@end

@implementation NSArray (KGOWebBridge)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (self.count > index) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}

@end

@implementation NSMutableDictionary (KGOAdditions)

- (void)setObjectIfExists:(id)object forKey:(id)key
{
    if (object) {
        [self setObject:object forKey:key];
    }
}

@end

@implementation NSArray (JSONParser)

- (NSString *)forcedStringAtIndex:(NSInteger)index {
    NSString *string = [self stringAtIndex:index];
    if (!string) {
        NSNumber *number = [self numberAtIndex:index];
        if (number) {
            string = [number description];
        }
    }
    return string;
}

- (NSString *)stringAtIndex:(NSInteger)index {
    id object = [self objectAtIndex:index];
    if ([object isKindOfClass:[NSString class]])
        return (NSString *)object;
    
    return nil;
}

- (NSNumber *)numberAtIndex:(NSInteger)index {
    id object = [self objectAtIndex:index];
    if ([object isKindOfClass:[NSNumber class]])
        return (NSNumber *)object;
    
    return nil;
}

- (NSArray *)arrayAtIndex:(NSInteger)index {
    id object = [self objectAtIndex:index];
    if ([object isKindOfClass:[NSArray class]])
        return (NSArray *)object;

    return nil;
}

- (NSDate *)dateAtIndex:(NSInteger)index {
    id object = [self objectAtIndex:index];
    if ([object isKindOfClass:[NSDate class]])
        return (NSDate *)object;

    return nil;
}

- (NSDate *)dateAtIndex:(NSInteger)index format:(NSString *)format {
    NSString *string = [self stringAtIndex:index];
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:format];
    return [df dateFromString:string];
}

- (NSDictionary *)dictionaryAtIndex:(NSInteger)index {
    id object = [self objectAtIndex:index];
    if ([object isKindOfClass:[NSDictionary class]])
        return (NSDictionary *)object;
    
    return nil;
}

- (BOOL)boolAtIndex:(NSInteger)index {
    id object = [self objectAtIndex:index];
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber *)object boolValue];
    
    if ([object isKindOfClass:[NSString class]])
        return [(NSString *)object boolValue];
    
    return NO;
}

- (NSInteger)integerAtIndex:(NSInteger)index {
    id object = [self objectAtIndex:index];
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber *)object integerValue];
    
    if ([object isKindOfClass:[NSString class]])
        return [(NSString *)object integerValue];
    
    return NSNotFound;
}

- (CGFloat)floatAtIndex:(NSInteger)index {
    id object = [self objectAtIndex:index];
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber *)object floatValue];
    
    if ([object isKindOfClass:[NSString class]])
        return [(NSString *)object floatValue];
    
    return NO;
}

- (CGFloat)floatAtIndex:(NSInteger)index defaultValue:(CGFloat)defaultValue {
    id object = [self objectAtIndex:index];
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber *)object floatValue];
    
    if ([object isKindOfClass:[NSString class]])
        return [(NSString *)object floatValue];
    
    return defaultValue;
}

@end


@implementation NSDictionary (JSONParser)

- (NSString *)stringForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    }
    return nil;
}

- (NSString *)nonemptyStringForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] && [(NSString *)object length]) {
        return (NSString *)object;
    }
    return nil;
}

- (NSString *)forcedStringForKey:(NSString *)key {
    NSString *string = [self stringForKey:key];
    if (!string) {
        NSNumber *number = [self numberForKey:key];
        if (number) {
            string = [number description];
        }
    }
    return string;
}

- (NSString *)nonemptyForcedStringForKey:(NSString *)key {
    NSString *string = [self nonemptyStringForKey:key];
    if (!string) {
        NSNumber *number = [self numberForKey:key];
        if (number) {
            string = [number description];
        }
    }
    return string;
}

- (NSNumber *)numberForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
        return (NSNumber *)object;
    
    return nil;
}

- (NSArray *)arrayForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSArray class]])
        return (NSArray *)object;
    
    return nil;
}

- (NSDate *)dateForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSDate class]])
        return (NSDate *)object;
    
    return nil;
}

- (NSDate *)dateForKey:(NSString *)key format:(NSString *)format {
    NSString *string = [self nonemptyStringForKey:key];
    if (string) {
        NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
        [df setDateFormat:format];
        return [df dateFromString:string];
    }
    return nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSDictionary class]])
        return (NSDictionary *)object;
    
    return nil;
}

- (BOOL)boolForKey:(NSString *)key {
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber *)object boolValue];
    
    if ([object isKindOfClass:[NSString class]])
        return [(NSString *)object boolValue];
    
    return NO;
}

- (NSInteger)integerForKey:(NSString *)key {
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber *)object integerValue];
    
    if ([object isKindOfClass:[NSString class]])
        return [(NSString *)object integerValue];
    
    return NSNotFound;
}

- (CGFloat)floatForKey:(NSString *)key {
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]) {
        return [object floatValue];
    }
    
    return 0;
}

- (CGFloat)floatForKey:(NSString *)key defaultValue:(CGFloat)defaultValue {
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber *)object floatValue];
    
    if ([object isKindOfClass:[NSString class]])
        return [(NSString *)object floatValue];
    
    return defaultValue;
}

- (double)doubleForKey:(NSString *)key {
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]) {
        return [object doubleValue];
    }
    
    return 0;
}

@end
