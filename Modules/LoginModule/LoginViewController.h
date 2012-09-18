//
//  FirstViewController.h
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APILibrary.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate,APILibraryDelegate>{
    IBOutlet UITextField *usrName;
    IBOutlet UITextField *password;
    IBOutlet UIButton *login;
    IBOutlet UIButton *lock;
    IBOutlet UIImageView *logo;
    
    BOOL lockStatus;
    CGPoint inputOrigin;
    CGPoint inputUp;
}
@property (nonatomic, retain)  IBOutlet UIImageView *inputBackgroundView;

- (IBAction)login:(id)sender;
- (IBAction)lock:(id)sender;
@end
