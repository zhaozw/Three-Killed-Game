//
//  GameDetailViewController.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"
#import "GameInstance.h"
#import "GameRoleInstance.h"
@interface GameDetailViewController : UIViewController <APILibraryDelegate>{
    GameInstance *currentGame;
    GameRoleInstance *currentRole;
    IBOutlet UITableView *listView;
}
@property (nonatomic, retain)  GameInstance *currentGame;
@property (nonatomic, retain)  GameRoleInstance *currentRole;
@property (nonatomic, retain)  IBOutlet UITableView *listView;

@end
