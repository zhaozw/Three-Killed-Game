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
#import "GameRoleInstance.h"
#import "AQGridView.h"
#import "SpringBoardCell.h"
@interface ObserveViewController : UIViewController <APILibraryDelegate,AQGridViewDataSource,AQGridViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    IBOutlet AQGridView *iconView;
    IBOutlet UIImageView *navTitleBar;
    IBOutlet UIImageView *menuContainer;
    IBOutlet UIButton *begainButton;
    IBOutlet UIButton *dianjiangButton;
    IBOutlet UIButton *backButton;


    NSUInteger _emptyCellIndex;
    
    NSUInteger _dragOriginIndex;
    CGPoint _dragOriginCellOrigin;
    
    SpringBoardCell * _draggingCell;
    
    NSArray *allRoles;
    NSArray *allUsers;
    GameInstance *currentGame;
    GameRoleInstance *currentRole;
}
@property (nonatomic, retain)  NSArray *allRoles;
@property (nonatomic, retain)  NSArray *allUsers;
@property (nonatomic, retain)  GameInstance *currentGame;
@property (nonatomic, retain)  GameRoleInstance *currentRole;

- (IBAction)open:(id)sender;
- (IBAction)finish:(id)sender;
- (IBAction)oneOnone:(id)sender;
- (IBAction)myRole:(id)sender;
- (IBAction)close:(id)sender;

- (IBAction)navBackButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;
@end
