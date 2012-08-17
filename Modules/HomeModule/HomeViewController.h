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
    IBOutlet UIImageView *menuContainer;
}

@end
