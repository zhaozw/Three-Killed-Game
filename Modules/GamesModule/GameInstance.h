//
//  GameInstance.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameInstance : NSObject {
    NSString *gameID;
    NSString *name;
}
@property (nonatomic, retain)  NSString *gameID;
@property (nonatomic, retain)  NSString *name;

@end
