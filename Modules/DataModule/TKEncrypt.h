//
//  TKEncrypt.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/28/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBEncryptorAES.h"
@interface TKEncrypt : NSObject {
    
}
+ (void)encrypt:(NSString *)scr withKey:(NSString *)key;
@end
