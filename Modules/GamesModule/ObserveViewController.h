//
//  ObserveViewController.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"
#import "GameInstance.h"
@interface ObserveViewController : UIViewController <APILibraryDelegate>{
    NSArray *allRoles;
    NSArray *allUsers;
    GameInstance *currentGame;
    
    IBOutlet UITableView *listView;
    IBOutlet UIView *tableFooterView;
}
@property (nonatomic, retain)  NSArray *allRoles;
@property (nonatomic, retain)  NSArray *allUsers;
@property (nonatomic, retain)  GameInstance *currentGame;
@property (nonatomic, retain)  IBOutlet UITableView *listView;
@property (nonatomic, retain)  IBOutlet UIView *tableFooterView;

- (IBAction)open:(id)sender;
- (IBAction)finish:(id)sender;
- (IBAction)oneOnone:(id)sender;
- (IBAction)myRole:(id)sender;
- (IBAction)close:(id)sender;
@end
