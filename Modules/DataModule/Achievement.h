//
//  Achievement.h
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Achievement : NSObject {
    NSString *name;
    NSString *number;
    NSString *summary;
}
@property (nonatomic, retain)  NSString *name;
@property (nonatomic, retain)  NSString *number;
@property (nonatomic, retain)  NSString *summary;

@end
