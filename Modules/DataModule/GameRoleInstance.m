//
//  GameRoleInstance.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "GameRoleInstance.h"

@implementation GameRoleInstance
@synthesize credits;
@synthesize gameID;
@synthesize gameName;
@synthesize gameTypeID;
@synthesize killedBy;
@synthesize roleName;
@synthesize roleID;
@synthesize seatNum;
@synthesize status;
@synthesize userID;
@synthesize userName;

- (void)dealloc {
    self.credits = nil;
    self.gameID = nil;
    self.gameName = nil;
    self.gameTypeID = nil;
    self.killedBy = nil;
    self.roleName = nil;
    self.roleID = nil;
    self.seatNum = nil;
    self.status = nil;
    self.userID = nil;
    self.userName = nil;

    [super dealloc];
}
@end
