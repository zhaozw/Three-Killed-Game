//
//  GameRoleInstance.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "GameRoleInstance.h"
#import "Foundation+KGOAdditions.h"
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

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    self.credits = [dictionary forcedNumberForKey:@"credits"];
    self.gameID = [dictionary forcedStringForKey:@"game_id"];
    self.gameName = [dictionary forcedStringForKey:@"game_name"];
    self.gameTypeID = [dictionary forcedStringForKey:@"game_type_id"];
    self.killedBy = [dictionary forcedStringForKey:@"killed_by"];
    self.roleName = [dictionary forcedStringForKey:@"name"];
    self.roleID = [dictionary forcedStringForKey:@"role_id"];
    self.seatNum = [dictionary forcedNumberForKey:@"seat"];
    self.status = [NSNumber numberWithBool:[dictionary boolForKey:@"status"]];
    self.userID = [dictionary forcedStringForKey:@"user_id"];
    self.userName = [dictionary forcedStringForKey:@"username"];
}
@end
