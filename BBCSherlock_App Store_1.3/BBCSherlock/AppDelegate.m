//
//  AppDelegate.m
//  Sherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "SHTwitterViewController.h"
#import "SHYoutubeViewController.h"
#import "SHGalleryViewController.h"
#import "SHTumblrNewViewController.h"
#import "SHHomeViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    NSString * controllers[5] = {@"SHHomeViewController",@"SHYoutubeViewController",@"SHTumblrNewViewController",@"SHTwitterViewController",@"SHGalleryViewController"};
    NSArray *itemImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"Icon_home.png"],[UIImage imageNamed:@"Icon_video.png"], [UIImage imageNamed:@"Icon_tumblr.png"],[UIImage imageNamed:@"Icon_twitter.png"],[UIImage imageNamed:@"Icon_producer.png"],nil];
    
    NSMutableArray * viewControllers = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) 
    {
        if(i!=3)
        {
            UIViewController * aViewController = [[[NSClassFromString(controllers[i]) alloc] initWithNibName:nil bundle:nil] autorelease];
            aViewController.tabBarItem.image = [itemImages objectAtIndex:i];
            UINavigationController * navi = [[[UINavigationController alloc] initWithRootViewController:aViewController] autorelease];
            [viewControllers addObject:navi];
        }
        else
        {
            UIViewController * aViewController = [[[NSClassFromString(controllers[i]) alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
            aViewController.tabBarItem.image = [itemImages objectAtIndex:i];
            UINavigationController * navi = [[[UINavigationController alloc] initWithRootViewController:aViewController] autorelease];
            [viewControllers addObject:navi];
        }
    }
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = viewControllers;
    self.tabBarController.delegate = self;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
