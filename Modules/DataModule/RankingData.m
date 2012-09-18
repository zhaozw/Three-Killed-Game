//
//  RankingData.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "RankingData.h"
#import "Foundation+KGOAdditions.h"
@implementation RankingData
@synthesize rankingID;
@synthesize firstName;
@synthesize lastName;
@synthesize credits;

- (void)dealloc {
    self.rankingID = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.credits = nil;

    [super dealloc];
}   

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    self.rankingID = [dictionary forcedStringForKey:@"id"];
    self.firstName = [dictionary forcedStringForKey:@"first_name"];
    self.lastName = [dictionary forcedStringForKey:@"last_name"];
    self.credits = [dictionary forcedNumberForKey:@"credits"];
}
@end
