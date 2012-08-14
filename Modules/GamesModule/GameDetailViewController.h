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
@interface GameDetailViewController : UIViewController <APILibraryDelegate>{
    GameInstance *currentGame;
}
@property (nonatomic, retain)  GameInstance *currentGame;

@end
