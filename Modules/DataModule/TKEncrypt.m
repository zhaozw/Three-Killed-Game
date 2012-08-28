//
//  TKEncrypt.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/28/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "TKEncrypt.h"

@implementation TKEncrypt

+ (void)encrypt:(NSString *)scr withKey:(NSString *)akey {
    NSDictionary *plist = nil;
    NSString *mainFile = nil;
    if (!plist) {
        mainFile = [[NSBundle mainBundle] pathForResource:scr ofType:@"plist"];    
        plist = [[NSDictionary alloc] initWithContentsOfFile:mainFile];
    }
    NSString *archiveKey = nil;
    NSString *archiveValue = nil;
    NSMutableDictionary *newPlist = [NSMutableDictionary dictionary];
    for (NSString *key in plist) {
        NSLog(@"key is :%@",key);
        archiveKey = [FBEncryptorAES encryptBase64String:key keyString:akey separateLines:NO];
        NSLog(@"archiveKey is :%@",archiveKey);
        
        NSLog(@"value is :%@",[plist objectForKey:key]);
        archiveValue = [FBEncryptorAES encryptBase64String:[plist objectForKey:key] keyString:akey separateLines:NO];
        NSLog(@"archiveValue is :%@",archiveValue);
        [newPlist setObject:archiveValue forKey:archiveKey];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *favoritesPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",scr]];
    [newPlist writeToFile:favoritesPath atomically:YES];
}

@end
