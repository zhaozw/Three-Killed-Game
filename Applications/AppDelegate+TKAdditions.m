//
//  AppDelegate+TKAdditions.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/13/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "AppDelegate+TKAdditions.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "APILibrary.h"
@implementation AppDelegate (TKAdditions)
- (BOOL)helloRequest {
    BOOL success = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&success metError:&error helloWithParam:nil];
    if (!success) {
        [APILibrary alertWithException:error];
    } 
    return success;
}

- (void)loadLoginViewController
{
    UIViewController *loginVC = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
}

- (void)loadNavigationContainer {
    UIViewController *homeVC = [[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil] autorelease];
    _appNavController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    _appNavController.delegate = self;
    self.window.rootViewController = _appNavController;
    [self.window makeKeyAndVisible];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}
@end
