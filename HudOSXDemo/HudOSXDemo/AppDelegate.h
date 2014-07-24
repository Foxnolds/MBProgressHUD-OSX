//
//  AppDelegate.h
//  HudOSXDemo
//
//  Created by Wayne Fox on 16/04/2014.
//  Copyright (c) 2014 Wayne Fox. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HudOSXDemoViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSWindow *window;
	IBOutlet HudOSXDemoViewController* viewController;
}

@property (nonatomic, strong) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet HudOSXDemoViewController* viewController;

@end
