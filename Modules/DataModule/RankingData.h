//
//  RankingData.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingData : NSObject {
    NSString *rankingID;
    NSString *firstName;
    NSString *lastName;
    NSNumber *credits;
}
@property (nonatomic, retain)  NSString *rankingID;
@property (nonatomic, retain)  NSString *firstName;
@property (nonatomic, retain)  NSString *lastName;
@property (nonatomic, retain)  NSNumber *credits;

- (void)updateWithDictionary:(NSDictionary *)dictionary;
@end
