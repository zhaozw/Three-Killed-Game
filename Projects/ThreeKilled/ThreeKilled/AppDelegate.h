//
//  AppDelegate.h
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/13/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate> {
    UINavigationController *_appNavController;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

@end
