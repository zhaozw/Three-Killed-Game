//
//  RangkingsViewController.h
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"
@interface RangkingsViewController : UIViewController <APILibraryDelegate>{
    IBOutlet UITableView *listView;
    NSArray *rankings;
}
@property (nonatomic, retain)  IBOutlet UITableView *listView;
@property (nonatomic, retain)  NSArray *rankings;

@end
