//
//  GameInstance.m
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "GameInstance.h"

@implementation GameInstance
@synthesize gameID;
@synthesize name;
- (void)dealloc {
    self.gameID = nil;
    self.name = nil;

    [super dealloc];
}

@end
