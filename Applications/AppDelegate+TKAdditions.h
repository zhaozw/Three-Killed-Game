//
//  AppDelegate+TKAdditions.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/13/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "AppDelegate.h"
#define SHARED_APP_DELEGATE() (AppDelegate *)[[UIApplication sharedApplication] delegate]
@interface AppDelegate (TKAdditions)
- (BOOL)helloRequest;
- (void)loadLoginViewController;
- (void)loadNavigationContainer;
@end
