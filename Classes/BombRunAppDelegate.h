

#import <UIKit/UIKit.h>

@class RootViewController;

@interface BombRunAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
