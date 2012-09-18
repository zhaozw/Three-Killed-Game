//
//  AccountData.h
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountData : NSObject {
    NSString *usrName;
    NSString *password;
    NSNumber *score;
    
    NSString *email;
    NSString *firstName;
    NSString *lastName;
    NSString *playerID;
}
@property (nonatomic, retain)  NSString *usrName;
@property (nonatomic, retain)  NSString *password;
@property (nonatomic, retain)  NSNumber *score;
@property (nonatomic, retain)  NSString *email;
@property (nonatomic, retain)  NSString *firstName;
@property (nonatomic, retain)  NSString *lastName;
@property (nonatomic, retain)  NSString *playerID;

@end
