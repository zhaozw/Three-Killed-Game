//
//  GameUserData.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameUserData : NSObject {
    NSString *userDataID;
    NSString *userDataKey;
    NSString *userDataName;
}
@property (nonatomic, retain)  NSString *userDataID;
@property (nonatomic, retain)  NSString *userDataKey;
@property (nonatomic, retain)  NSString *userDataName;

@end
