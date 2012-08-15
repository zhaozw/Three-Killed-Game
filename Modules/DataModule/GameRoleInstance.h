//
//  GameRoleInstance.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameRoleInstance : NSObject {
    NSNumber *credits;
    NSString *gameID;
    NSString *gameName;
    NSString *gameTypeID;
    NSString *killedBy;
    NSString *roleName;
    NSString *roleID;
    NSNumber *seatNum;
    NSNumber *status;
    NSString *userID;
    NSString *userName;
}
@property (nonatomic, retain)  NSNumber *credits;
@property (nonatomic, retain)  NSString *gameID;
@property (nonatomic, retain)  NSString *gameName;
@property (nonatomic, retain)  NSString *gameTypeID;
@property (nonatomic, retain)  NSString *killedBy;
@property (nonatomic, retain)  NSString *roleName;
@property (nonatomic, retain)  NSString *roleID;
@property (nonatomic, retain)  NSNumber *seatNum;
@property (nonatomic, retain)  NSNumber *status;
@property (nonatomic, retain)  NSString *userID;
@property (nonatomic, retain)  NSString *userName;

- (void)updateWithDictionary:(NSDictionary *)dictionary;
@end
