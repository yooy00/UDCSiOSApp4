//
//  AppDelegate.h
//  UDCSiOSApp4
//
//  Created by WL on 13-10-4.
//  Copyright (c) 2013年 WL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainScreen.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain)  mainScreen  *viewController;
@property (strong, nonatomic) UINavigationController *navController;
@end
