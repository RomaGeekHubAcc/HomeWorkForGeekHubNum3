//
//  AppDelegate.h
//  HWforgeekHub3
//
//  Created by Roma on 27.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataBaseManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DataBaseManager *dbManager;
}

@property (strong, nonatomic) UIWindow *window;

@end
