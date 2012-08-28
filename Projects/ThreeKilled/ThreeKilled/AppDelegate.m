//
//  AppDelegate.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/13/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+TKAdditions.h"
#import "TKEncrypt.h"

const NSString *kEncryptKey = @"hello";
@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [TKEncrypt encrypt:@"gameIcon" withKey:@"hello"];
//    [TKEncrypt encrypt:@"hall 2" withKey:@"hello"];
//    [TKEncrypt encrypt:@"selcharacter" withKey:@"hello"];
//    [TKEncrypt encrypt:@"btable 2" withKey:@"hello"];
//    [TKEncrypt encrypt:@"btable1 2" withKey:@"hello"];
//    [TKEncrypt encrypt:@"gameIcon 2" withKey:@"hello"];
//    [TKEncrypt encrypt:@"table 2" withKey:@"hello"];
//    [TKEncrypt encrypt:@"table1 2" withKey:@"hello"];
//    [TKEncrypt encrypt:@"utl 2" withKey:@"hello"];
//    [TKEncrypt encrypt:@"hall_2" withKey:@"hello"];
//    [TKEncrypt encrypt:@"table_2" withKey:@"hello"];
    
    BOOL success = [self helloRequest];
    if (success)[self loadLoginViewController];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
