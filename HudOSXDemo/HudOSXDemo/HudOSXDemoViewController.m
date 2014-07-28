//
//  HudDemoViewController.m
//  HudDemo
//
//  Created by Matej Bukovinski on 30.9.09.
//  Copyright bukovinski.com 2009. All rights reserved.
//

#import "HudOSXDemoViewController.h"
#import <unistd.h>

#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp) exp
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#endif


#define SCREENSHOT_MODE 0


@implementation HudOSXDemoViewController

#pragma mark -
#pragma mark Lifecycle methods

//- (void)viewDidLoad {
//	NSView *content = [[self.view subviews] objectAtIndex:0];
//#if SCREENSHOT_MODE
//	[content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//#endif
//	((NSScrollView *)self.view).contentSize = content.bounds.size;
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	return YES;
//}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//	UIView *content = [[self.view subviews] objectAtIndex:0];
//	((UIScrollView *)self.view).contentSize = content.bounds.size;
//}

- (void)dealloc {
#if !__has_feature(objc_arc)
	[super dealloc];
#endif
}

#pragma mark -
#pragma mark IBActions

- (IBAction)showSimple:(id)sender {
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithLabel:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithDetailsLabel:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"updating data";
	HUD.square = YES;
	
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithLabelDeterminate:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWIthLabelAnnularDeterminate:(id)sender {
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeAnnularDeterminate;
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithLabelDeterminateHorizontalBar:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	// Set determinate bar mode
	HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
	
	HUD.delegate = self;
	
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showWithCustomView:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = MB_AUTORELEASE([[NSImageView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 37.0f, 37.0f)]);
    NSImage *img = [NSImage imageNamed:@"37x-Checkmark"];
    if (!img) img = [NSImage imageNamed:@"37x-Checkmark.png"];
    [(NSImageView *)HUD.customView setImage:img];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = @"Completed";
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:3];
}

- (IBAction)showWithLabelMixed:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Connecting";
	HUD.minSize = CGSizeMake(135.f, 135.f);
	
	[HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showUsingBlocks:(id)sender {
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	hud.labelText = @"With a block";
	
	[hud showAnimated:YES whileExecutingBlock:^{
		[self myTask];
	} completionBlock:^{
		[hud removeFromSuperview];
#if !__has_feature(objc_arc)
		[hud release];
#endif
	}];
#endif
}

- (IBAction)showOnWindow:(id)sender {
	// The hud will dispable all input on the window
	HUD = [[MBProgressHUD alloc] initWithWindow:self.view.window];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showURL:(id)sender {
	NSURL *URL = [NSURL URLWithString:@"http://a1408.g.akamai.net/5/1408/1388/2005110403/1a1a1ad948be278cff2d96046ad90768d848b41947aa1986/sample_iPod.m4v.zip"];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection start];
#if !__has_feature(objc_arc)
	[connection release];
#endif
	
	HUD = MB_RETAIN([MBProgressHUD showHUDAddedTo:self.view animated:YES]);
	HUD.delegate = self;
}


- (IBAction)showWithGradient:(id)sender {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showTextOnly:(id)sender {
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = @"Some message...";
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:3];
}

- (IBAction)showWithColor:(id)sender{
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	// Set the hud to display with a color
	HUD.color = [NSColor colorWithDeviceRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	
	HUD.delegate = self;
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];	
}

#pragma mark -
#pragma mark Execution code

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(3);
}

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
}

- (void)myMixedTask {
	// Indeterminate mode
	sleep(2);
	// Switch to determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"Progress";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
	// Back to indeterminate mode
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Cleaning up";
	sleep(2);
	// UIImageView is a UIKit class, we have to initialize it on the main thread
	__block NSImageView *imageView;
	dispatch_sync(dispatch_get_main_queue(), ^{
		NSImage *image = [NSImage imageNamed:@"37x-Checkmark.png"];
		imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 37.0f, 37.0f)];
        imageView.image = image;
	});
	HUD.customView = MB_AUTORELEASE(imageView);
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
	sleep(2);
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	expectedLength = MAX([response expectedContentLength], 1);
	currentLength = 0;
	HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = MB_AUTORELEASE([[NSImageView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 37.0f, 37.0f)]);
    [(NSImageView *)HUD.customView setImage:[NSImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
#if !__has_feature(objc_arc)
	[HUD release];
#endif
	HUD = nil;
}

@end
