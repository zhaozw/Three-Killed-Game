//
//  HomeViewController.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController {
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
    
    IBOutlet UIButton *menuButton;
    IBOutlet UIButton *createButton;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *acLabel;
}

@end
