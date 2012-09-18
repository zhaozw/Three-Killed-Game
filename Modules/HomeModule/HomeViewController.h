//
//  HomeViewController.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"
#import "EGORefreshTableHeaderView.h"
@interface HomeViewController : UIViewController <APILibraryDelegate,EGORefreshTableHeaderDelegate>{
    IBOutlet UIImageView *navTitleImageView;
    IBOutlet UITableView *listView;
    IBOutlet UIView *bottomContainer;
    IBOutlet UIImageView *infoContainer;
    
    IBOutlet UIButton *leftButton;
    IBOutlet UIButton *rightButton;
    
    IBOutlet UIImageView *portriatView;
    IBOutlet UIImageView *infoTopView;
    
    IBOutlet UIImageView *leftholder;
    IBOutlet UIImageView *rightholder;
    
    IBOutlet UIButton *returnButton;
    IBOutlet UIButton *createButton;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *acLabel;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    NSMutableArray *games;
    NSArray *rankings;
    BOOL pageGames;
}
@property (nonatomic, retain)  NSMutableArray *games;
@property (nonatomic, retain)  NSArray *rankings;

- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)returnClicked:(id)sender;
- (IBAction)create:(id)sender;
@end
