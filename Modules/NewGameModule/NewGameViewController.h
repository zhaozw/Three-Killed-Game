//
//  NewGameViewController.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"
#import "IconGrid.h"
@interface NewGameViewController : UIViewController <APILibraryDelegate,IconGridDelegate>{
    NSArray *allKindsGames;
    IBOutlet IconGrid *iconView;
    IBOutlet UIImageView *navTitleBar;
    IBOutlet UIImageView *menuContainer;
}
@property (nonatomic, retain)  NSArray *allKindsGames;

@end
