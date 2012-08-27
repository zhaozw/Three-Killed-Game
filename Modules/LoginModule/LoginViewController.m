//
//  FirstViewController.m
//  Sanguosha
//
//  Created by Liu Mingxing on 5/14/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "LoginViewController.h"
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
    inputOrigin = self.inputBackgroundView.frame.origin;
    inputUp = CGPointMake(inputOrigin.x, 20);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_l.png"]];
    self.inputBackgroundView.image = [UIImage imageWithName:@"input_background" tableName:@"btable 2"];
    userNameBGView.image = [UIImage imageNamed:@"title_back.png"];
    passwordBGView.image = [UIImage imageNamed:@"title_back.png"];
    
    
    NSDictionary *config = [[NSUserDefaults standardUserDefaults] objectForKey:@"config"];
    NSString *account = nil;
    NSString *pwd = nil;
    NSNumber *locked = nil;
    if (config) {
        NSDictionary *credential = [config objectForKey:@"credential"];
        locked = [credential objectForKey:@"locked"];
        if (locked.boolValue) {
            account = [credential objectForKey:@"account"];
            pwd = [credential objectForKey:@"password"];
        }
    }
    usrName.text = account ? account : @"";
    password.text = pwd ? pwd : @"";
    if (locked && locked.boolValue) {
        lockStatus = YES;
        [lock setImage:[UIImage imageWithName:@"lock" tableName:@"btable 2"] forState:UIControlStateNormal];
        [lock setImage:[UIImage imageWithName:@"lock_on" tableName:@"btable 2"] forState:UIControlStateHighlighted];
    } else {
        lockStatus = NO;
        [lock setImage:[UIImage imageWithName:@"unlock" tableName:@"btable 2"] forState:UIControlStateNormal];
        [lock setImage:[UIImage imageWithName:@"unlock_on" tableName:@"btable 2"] forState:UIControlStateHighlighted];
    }
    [login setImage:[UIImage imageWithName:@"login" tableName:@"btable 2"] forState:UIControlStateNormal];
    [login setImage:[UIImage imageWithName:@"login_on" tableName:@"btable 2"] forState:UIControlStateHighlighted];
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

- (void)handleLoginRequest {
    BOOL status = NO;
    NSString *error = nil;
    AccountData *ad = [[[AccountData alloc] init] autorelease];
    ad.usrName = usrName.text;
    ad.password = password.text;
    [APILibrary sharedInstance].userData = ad;
    [APILibrary apiLibrary:&status metError:&error loginWithUserData:[APILibrary sharedInstance].userData withDelegate:self];
}

- (void)apiLibraryDidReceivedLoginResult:(id)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     [SHARED_APP_DELEGATE() loadNavigationContainer];
}

- (void)apiLibraryDidReceivedError:(NSString *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [APILibrary alertWithException:error];
}

- (IBAction)login:(id)sender {
    [self UserDefautSynchronize];
    [self forcedResignFirstResponder];
    if (usrName.text.length > 0 && password.text.length > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self performSelector:@selector(handleLoginRequest) withObject:nil afterDelay:0.5];
    } else {
        NSString *preCheckError = NSLocalizedString(@"Please input all values", nil);
        [APILibrary alertWithException:preCheckError];
    }
}

- (void)UserDefautSynchronize{
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    NSMutableDictionary *credential = [NSMutableDictionary dictionary];
    [credential setObject:[NSNumber numberWithBool:lockStatus] forKey:@"locked"];
    [credential setObject:usrName.text.length > 0 ? usrName.text : @"" forKey:@"account"];
    [credential setObject:password.text.length > 0 ? password.text : @"" forKey:@"password"];
    [config setObject:credential forKey:@"credential"];
    [[NSUserDefaults standardUserDefaults] setObject:config forKey:@"config"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)lock:(id)sender {
    lockStatus = !lockStatus;
    if (lockStatus) {
        [lock setImage:[UIImage imageWithName:@"lock" tableName:@"btable 2"] forState:UIControlStateNormal];
        [lock setImage:[UIImage imageWithName:@"lock_on" tableName:@"btable 2"] forState:UIControlStateHighlighted];
    } else {
        [lock setImage:[UIImage imageWithName:@"unlock" tableName:@"btable 2"] forState:UIControlStateNormal];
        [lock setImage:[UIImage imageWithName:@"unlock_on" tableName:@"btable 2"] forState:UIControlStateHighlighted];
    }
    [self UserDefautSynchronize];
}

- (void)uninputStatus {
    [usrName resignFirstResponder];
    [password resignFirstResponder];
    CGRect frame = self.inputBackgroundView.frame;
    if (frame.origin.y == inputUp.y) {
        frame.origin = inputOrigin;
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.inputBackgroundView.frame = frame;
                         }
                         completion:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self uninputStatus];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGRect frame = self.inputBackgroundView.frame;
    if (frame.origin.y == inputOrigin.y) {
        frame.origin = inputUp;
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.inputBackgroundView.frame = frame;
                         }
                         completion:nil];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self uninputStatus];
    return YES;
}

@end
