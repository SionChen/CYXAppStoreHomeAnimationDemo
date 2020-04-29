//
//  AppDelegate.m
//  CYXAppStoreHomeAnimationDemo
//
//  Created by 晓 on 2020/4/26.
//  Copyright © 2020 晓. All rights reserved.
//

#import "AppDelegate.h"
#import "AppStoreListViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    application.delegate.window = window;
    window.rootViewController = [[AppStoreListViewController alloc] init];
    [window makeKeyAndVisible];
    return YES;
}



@end
