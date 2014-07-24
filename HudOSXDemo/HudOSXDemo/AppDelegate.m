//
//  AppDelegate.m
//  HudOSXDemo
//
//  Created by Wayne Fox on 16/04/2014.
//  Copyright (c) 2014 Wayne Fox. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSMenu* mainMenu = [[NSApplication sharedApplication] mainMenu];
    NSMenuItem* helpMenuItem = [mainMenu itemAtIndex:[mainMenu numberOfItems]-1];
#ifdef DEBUG
    NSLog(@"[Line %d] %s MenuTitle: %@ now hidden", __LINE__, __FUNCTION__, helpMenuItem.title);
#endif  // DEBUG
    helpMenuItem.hidden = YES;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
	[viewController release];
	[window release];
	[super dealloc];
#endif
}

@end
