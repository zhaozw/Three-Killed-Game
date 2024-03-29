//
//  FirstViewController.h
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    IBOutlet UITextField *usrName;
    IBOutlet UITextField *password;
    IBOutlet UIButton *login;
    IBOutlet UIButton *cancel;
}
@property (nonatomic, retain)  IBOutlet UIImageView *inputBackgroundView;
@property (nonatomic, retain)  IBOutlet UIImageView *userNameBGView;
@property (nonatomic, retain)  IBOutlet UIImageView *passwordBGView;

- (IBAction)login:(id)sender;
- (IBAction)cancel:(id)sender;
@end
