//
//  AccountData.m
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "AccountData.h"

@implementation AccountData
@synthesize usrName;
@synthesize password;
@synthesize score;
@synthesize email;
@synthesize firstName;
@synthesize lastName;
@synthesize playerID;

- (void)dealloc {
    self.usrName = nil;
    self.password = nil;
    self.score = nil;
    self.email = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.playerID = nil;

    [super dealloc];
}
@end
