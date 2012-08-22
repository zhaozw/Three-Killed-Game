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
#import "IconGrid.h"
@interface GameDetailViewController : UIViewController <APILibraryDelegate,IconGridDelegate>{
    GameInstance *currentGame;
    GameRoleInstance *currentRole;

    IBOutlet IconGrid *iconView;
    IBOutlet UIImageView *navTitleBar;
    IBOutlet UIImageView *menuContainer;
    IBOutlet UIButton *begainButton;
    IBOutlet UIButton *dianjiangButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *charactorButton;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *openButton;
    IBOutlet UIButton *onOneOneButton;
    IBOutlet UIScrollView *tableContentView;
    
    NSMutableArray *feakAllRoles;
}
@property (nonatomic, retain)  GameInstance *currentGame;
@property (nonatomic, retain)  GameRoleInstance *currentRole;
@property (nonatomic, retain)  NSMutableArray *feakAllRoles;

- (IBAction)navBackButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;
- (IBAction)openButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)finishButtonClicked:(id)sender;
- (IBAction)oneOnoneButtonClicked:(id)sender;

@end
