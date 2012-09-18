//
//  NewGameViewController.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"
#import "AutoIconGrid.h"
@interface NewGameViewController : UIViewController <APILibraryDelegate>{
    NSArray *allKindsGames;
    IBOutlet AutoIconGrid *iconView;
    IBOutlet UIImageView *navTitleBar;
    IBOutlet UIImageView *menuContainer;
    IBOutlet UIButton *begainButton;
    IBOutlet UIButton *dianjiangButton;
    IBOutlet UIButton *backButton;
}
@property (nonatomic, retain)  NSArray *allKindsGames;
- (IBAction)navBackButtonClicked:(id)sender;
@end
