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
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBarItem.title = @"hello";
    usrLabel.text = NSLocalizedString(@"_UserNameLabel_", nil);
    pwdLabel.text = NSLocalizedString(@"_PasswordLabel_", nil);
    [login setTitle:NSLocalizedString(@"_Login_", nil) forState:UIControlStateNormal];
    [login setTitle:NSLocalizedString(@"_Login_", nil) forState:UIControlStateHighlighted];
    [cancel setTitle:NSLocalizedString(@"_Cancel_", nil) forState:UIControlStateNormal];
    [cancel setTitle:NSLocalizedString(@"_Cancel_", nil) forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
            HomeViewController *homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" 
                                                                              bundle:nil];
            [self.navigationController pushViewController:homeVC animated:YES];
        } else {
            [APILibrary alertWithException:error];
        }
    } else {
        NSString *preCheckError = NSLocalizedString(@"Please input all values", nil);
        [APILibrary alertWithException:preCheckError];
    }
}

- (IBAction)cancel:(id)sender {
    usrName.text = @"";
    password.text = @"";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [usrName resignFirstResponder];
        [password resignFirstResponder];
    }
}

@end
