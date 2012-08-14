//
//  GamesViewController.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"
@interface GamesViewController : UIViewController <APILibraryDelegate> {
    NSArray *games;
}
@property (nonatomic, retain)  IBOutlet UITableView *gamesTableView;
@property (nonatomic, retain)  NSArray *games;

@end
