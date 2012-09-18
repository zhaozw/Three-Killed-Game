//
//  GameInstance.m
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "GameInstance.h"
#import "Foundation+KGOAdditions.h"
#import "UIKit+KGOAdditions.h"

@implementation GameInstance
@synthesize gameID;
@synthesize name;
@synthesize gameTypeID;
@synthesize allRoles;
@synthesize allUsers;
@synthesize status;
@synthesize playerCount;

- (void)dealloc {
    self.gameID = nil;
    self.name = nil;
    self.gameTypeID = nil;
    self.allRoles = nil;
    self.allUsers = nil;
    self.status = nil;
    self.playerCount = nil;


    [super dealloc];
}

- (UIImage *)statusImage {
    if (self.allRoles.count < self.playerCount.integerValue) {
        return [UIImage imageWithName:@"green_status" tableName:@"btable 2"];
    }
    return [UIImage imageWithName:@"red_status" tableName:@"btable 2"];
}

@end
