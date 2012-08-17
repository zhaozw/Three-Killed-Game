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
    self.inputBackgroundView.image = [UIImage imageNamed:@"input.png"];
    userNameBGView.image = [UIImage imageNamed:@"title_back.png"];
    passwordBGView.image = [UIImage imageNamed:@"title_back.png"];
    
    UIImage *loginImageNormal = [[UIImage imageNamed:@"comfirm_n.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    UIImage *loginImageHighlight = [[UIImage imageNamed:@"comfirm_i.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    [login setImage:loginImageNormal forState:UIControlStateNormal];
    [login setImage:loginImageHighlight forState:UIControlStateHighlighted];
    
    UIImage *cancelImageNormal = [[UIImage imageNamed:@"cancel_n.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    UIImage *cancelImageHighlight = [[UIImage imageNamed:@"cancel_d.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    [cancel setImage:cancelImageNormal forState:UIControlStateNormal];
    [cancel setImage:cancelImageHighlight forState:UIControlStateHighlighted];
    
    
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
            [SHARED_APP_DELEGATE() loadNavigationContainer];
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
