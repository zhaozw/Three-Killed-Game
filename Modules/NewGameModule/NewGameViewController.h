//
//  NewGameViewController.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"
@interface NewGameViewController : UIViewController <APILibraryDelegate>{
    NSArray *allKindsGames;
    IBOutlet UITableView *listView;
}
@property (nonatomic, retain)  NSArray *allKindsGames;
@property (nonatomic, retain)  IBOutlet UITableView *listView;

@end
