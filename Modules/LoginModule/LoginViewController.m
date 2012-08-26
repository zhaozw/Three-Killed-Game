//
//  FirstViewController.m
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "APILibrary.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
#import "AppDelegate+TKAdditions.h"
#import "UIKit+KGOAdditions.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize inputBackgroundView;
@synthesize userNameBGView;
@synthesize passwordBGView;

- (void)dealloc {
    self.inputBackgroundView = nil;
    self.userNameBGView = nil;
    self.passwordBGView = nil;

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_l.png"]];
    self.inputBackgroundView.image = [UIImage imageWithName:@"input_background" tableName:@"btable 2"];
    userNameBGView.image = [UIImage imageNamed:@"title_back.png"];
    passwordBGView.image = [UIImage imageNamed:@"title_back.png"];
    
    [login setImage:[UIImage imageWithName:@"login" tableName:@"btable 2"] forState:UIControlStateNormal];
    [login setImage:[UIImage imageWithName:@"login_on" tableName:@"btable 2"] forState:UIControlStateHighlighted];
    
    [lock setImage:[UIImage imageWithName:@"lock" tableName:@"btable 2"] forState:UIControlStateNormal];
    [lock setImage:[UIImage imageWithName:@"lock_on" tableName:@"btable 2"] forState:UIControlStateHighlighted];
    
    logo.image = [UIImage imageWithName:@"sanguosha" tableName:@"btable 2"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGAffineTransform t = self.view.transform;
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) && t.b && t.c) {
        [self.view setTransform:CGAffineTransformMakeRotation(0)];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
#pragma mark - common
- (void)forcedResignFirstResponder {
    [usrName resignFirstResponder];
    [password resignFirstResponder];
}

- (IBAction)login:(id)sender {
    [self forcedResignFirstResponder];
    if (usrName.text.length > 0 && password.text.length > 0) {
        AccountData *ad = [[[AccountData alloc] init] autorelease];
        ad.usrName = usrName.text;
        ad.password = password.text;
        [APILibrary sharedInstance].userData = ad;
        BOOL status = NO;
        NSString *error = nil;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [APILibrary apiLibrary:&status metError:&error loginWithUserData:[APILibrary sharedInstance].userData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (status) {
            [SHARED_APP_DELEGATE() loadNavigationContainer];
        } else {
            [APILibrary alertWithException:error];
        }
    } else {
        NSString *preCheckError = NSLocalizedString(@"Please input all values", nil);
        [APILibrary alertWithException:preCheckError];
    }
}

- (IBAction)lock:(id)sender {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [usrName resignFirstResponder];
        [password resignFirstResponder];
    }
}

@end
