//
//  AppDelegate+TKAdditions.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/13/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "AppDelegate+TKAdditions.h"
#import "LoginViewController.h"
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

- (void)loadNavigationContainer 
{
    UIViewController *loginVC = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    _appNavController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UIColor *tintColor = [UIColor yellowColor];
    _appNavController.navigationBar.tintColor = tintColor;
    _appNavController.delegate = self;
    _appNavController.view.backgroundColor = [UIColor grayColor];
    self.window.rootViewController = _appNavController;
    [self.window makeKeyAndVisible];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}
@end
