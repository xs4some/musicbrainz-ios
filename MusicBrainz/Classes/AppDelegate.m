//
//  AppDelegate.m
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 04-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "AppDelegate.h"
#import "Const.h"

#import "SearchViewController.h"
#import "CollectionViewController.h"
#import "DonateViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.network = [[MKNetworkEngine alloc] initWithHostName:nil customHeaderFields:nil];
    [self.network useCache];
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    UIColorFromRGB(kNavigationBarTextColour), UITextAttributeTextColor,
                                    [UIColor clearColor], UITextAttributeTextShadowColor, nil];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes: attributes forState: UIControlStateNormal];
    }

    UIViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    UIViewController *collectionViewController = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    UIViewController *donateViewController = [[DonateViewController alloc] initWithNibName:@"DonateViewController" bundle:nil];

    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    UINavigationController *collectionNavigationConroller = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    UINavigationController *donateNavigationController = [[UINavigationController alloc] initWithRootViewController:donateViewController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[searchNavigationController, collectionNavigationConroller, donateNavigationController];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
