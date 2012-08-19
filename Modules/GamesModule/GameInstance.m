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

- (void)dealloc {
    self.gameID = nil;
    self.name = nil;
    self.gameTypeID = nil;
    self.allRoles = nil;
    self.allUsers = nil;
    self.status = nil;


    [super dealloc];
}

- (UIImage *)statusImage {
    return [UIImage imageWithName:@"green_status" tableName:@"btable 2"];
}

@end
