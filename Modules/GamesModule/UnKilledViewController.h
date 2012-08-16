//
//  UnKilledViewController.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/16/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRoleInstance.h"
#import "GameInstance.h"
#import "APILibrary.h"
@interface UnKilledViewController : UIViewController <APILibraryDelegate>{
    GameRoleInstance *currentRole;
    GameInstance *currentGame;
}
@property (nonatomic, retain)  GameRoleInstance *currentRole;
@property (nonatomic, retain)  GameInstance *currentGame;
@property (nonatomic, retain)  IBOutlet UITableView *listView;

@end
