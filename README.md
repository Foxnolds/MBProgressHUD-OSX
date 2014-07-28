# MBProgressHUD-OSX

A fork and conversion of [Matej Bukovinski's MBProgressHUD](https://github.com/matej/MBProgressHUD) for iOS to run on OS X.
See [Matej Bukovinski's MBProgressHUD in github](https://github.com/matej/MBProgressHUD) for latest iOS official repository.

The MBProgressHUD class is still iOS compatible and can be deployed for either platform.
The MBProgressHUD class also supports ARC and Non-ARC compilation.

For OS X, I also used Kelan Champagne's YRKSpinningProgressIndicator, replacing
the OS X NSProgressIndicator.

MBProgressHUD is an iOS/OS X drop-in class that displays a translucent HUD with an indicator and/or labels while work is being done in a background thread. The HUD is meant as a replacement for the undocumented, private UIKit UIProgressHUD with some additional features.

## iOS Examples
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/1-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/1.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/2-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/2.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/3-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/3.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/4-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/4.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/5-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/5.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/6-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/6.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/7-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/7.png)

## OS X Examples
[![](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_1_thumb.png)](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_1.png)
[![](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_2_thumb.png)](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_2.png)
[![](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_3_thumb.png)](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_3.png)
[![](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_4_thumb.png)](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_4.png)
[![](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_6_thumb.png)](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_6.png)
[![](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_7_thumb.png)](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_7.png)
[![](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_13_thumb.png)](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_13.png)
[![](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_14_thumb.png)](http://dl.dropbox.com/u/176305/MBProgressHUD-OSX/OSX_14.png)


## Requirements

MBProgressHUD works on any iOS or OS X version and is compatible with both ARC and non-ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

### iOS
* Foundation.framework
* UIKit.framework
* CoreGraphics.framework

### OS X
* Foundation.framework
* AppKit.framework
* CoreData.framework

You will need LLVM 3.0 or later in order to build MBProgressHUD. 

## Adding MBProgressHUD to your project

### Cocoapods

I have not yet enabled [CocoaPods](http://cocoapods.org) for this OS X compatible version of MBProgressHUD.

### Source files

Meanwhile, you can directly add the `MBProgressHUD.h` and `MBProgressHUD.m` source files to your project.

1. Download the [latest code version](https://github.com/Foxnolds/MBProgressHUD-OSX/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `MBProgressHUD.h` and `MBProgressHUD.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include MBProgressHUD wherever you need it with `#import "MBProgressHUD.h"`.

### Static library

You can also add MBProgressHUD as a static library to your project or workspace. 

1. Download the [latest code version](https://github.com/Foxnolds/MBProgressHUD-OSX/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `MBProgressHUD.xcodeproj` onto your project or workspace (use the "Product Navigator view"). 
3. Select your target and go to the Build phases tab. In the Link Binary With Libraries section select the add button. On the sheet find and add `libMBProgressHUD.a`. You might also need to add `MBProgressHUD` to the Target Dependencies list. 
4. Include MBProgressHUD wherever you need it with `#import <MBProgressHUD/MBProgressHUD.h>`.

## Usage

The main guideline you need to follow when dealing with MBProgressHUD while running long-running tasks is keeping the main thread work-free, so the UI can be updated promptly. The recommended way of using MBProgressHUD is therefore to set it up on the main thread and then spinning the task, that you want to perform, off onto a new thread. 

```objective-c
[MBProgressHUD showHUDAddedTo:self.view animated:YES];
dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
	// Do something...
	dispatch_async(dispatch_get_main_queue(), ^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	});
});
```

If you need to configure the HUD you can do this by using the MBProgressHUD reference that showHUDAddedTo:animated: returns. 

```objective-c
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
hud.mode = MBProgressHUDModeAnnularDeterminate;
hud.labelText = @"Loading";
[self doSomethingInBackgroundWithProgressCallback:^(float progress) {
	hud.progress = progress;
} completionCallback:^{
	[hud hide:YES];
}];
```

UI updates should always be done on the main thread. Some MBProgressHUD setters are however considered "thread safe" and can be called from background threads. Those also include `setMode:`, `setCustomView:`, `setLabelText:`, `setLabelFont:`, `setDetailsLabelText:`, `setDetailsLabelFont:` and `setProgress:`.

If you need to run your long-running task in the main thread, you should perform it with a slight delay, so UIKit will have enough time to update the UI (i.e., draw the HUD) before you block the main thread with your task.

```objective-c
[MBProgressHUD showHUDAddedTo:self.view animated:YES];
dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
	// Do something...
	[MBProgressHUD hideHUDForView:self.view animated:YES];
});
```

You should be aware that any HUD updates issued inside the above block won't be displayed until the block completes.

For more examples, including how to use MBProgressHUD with asynchronous operations such as NSURLConnection, take a look at the bundled demo project. Extensive API documentation is provided in the header file (MBProgressHUD.h).


## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE). 

## Change-log

- Initial fork of iOS 0.8 release.
