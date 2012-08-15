//
//  GameUserData.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "GameUserData.h"

@implementation GameUserData
@synthesize userDataID;
@synthesize userDataKey;
@synthesize userDataName;

- (void)dealloc {
    self.userDataID = nil;
    self.userDataKey = nil;
    self.userDataName = nil;

    [super dealloc];
}

@end
