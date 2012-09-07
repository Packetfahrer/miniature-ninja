//
//  CustomerAppDelegate.m
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "CustomerAppDelegate.h"

#import "CustomerFirstViewController.h"

#import "CustomerSecondViewController.h"


#import "Contact.h"
#import "Trans.h"



@implementation CustomerAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize contactArray;
@synthesize transArray;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
	[contactArray release];
	[transArray release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	//Copy database to the user's phone if needed.
	[self copyDatabaseIfNeeded];
	
	//Initialize the contact array.
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.contactArray = tempArray;
	[tempArray release];
 
	//Initialize the transaction array.
	NSMutableArray *tempTransArray = [[NSMutableArray alloc] init];
	self.transArray = tempTransArray;
	[tempTransArray release];
    
	//Once the db is copied, get the initial data to display on the screen
	[Contact getInitialDataToDisplay:[self getDBPath]];
    
	[Trans getInitialDataToDisplay:[self getDBPath]];
        
    //*************************************************************************
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[CustomerFirstViewController alloc] initWithNibName:@"CustomerFirstViewController" bundle:nil] autorelease];
    UIViewController *viewController2 = [[[CustomerSecondViewController alloc] initWithNibName:@"CustomerSecondViewController" bundle:nil] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
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
	//Save all the dirty contact objects and free memory.
	[self.contactArray makeObjectsPerformSelector:@selector(saveAllData)];
	
	[Contact finalizeStatements];
    
	[self.transArray makeObjectsPerformSelector:@selector(saveAllData)];
	
	[Trans finalizeStatements];
    
	
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    //Save all the dirty contact objects and free memory.
	[self.contactArray makeObjectsPerformSelector:@selector(saveAllData)];
	[self.transArray makeObjectsPerformSelector:@selector(saveAllData)];
    
    
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
- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"customer.db"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"customer.db"];
}

- (void) removeContact:(Contact *)contactObj {
	
	//Delete it from the database.
	[contactObj deleteContact];
	
	//Remove it from the array.
	[contactArray removeObject:contactObj];
	[self refreshContact];
}

- (void) addContact:(Contact *)contactObj {
	
	//Add it to the database.
	[contactObj addContact];
	
	//Add it to the contact array.
	[self refreshContact];
	
	//kc0106	[contactArray addObject:contactObj];
	
}

- (void) saveContact {
	[self.contactArray makeObjectsPerformSelector:@selector(saveAllData)];
    [self refreshContact];
}

- (void) refreshContact {
	//Initialize the contact array.
	if ([contactArray retainCount] <= 1){
		[contactArray retain]; //kc0106
	}
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.contactArray = tempArray;
	[tempArray release];
	//Once the db is copied, get the initial data to display on the screen.
	[Contact getInitialDataToDisplay:[self getDBPath]];
}
//****************************************Trans*******************************************************************
- (void) removeTrans:(Trans *)transObj {
	
	//Delete it from the database.
	[transObj deleteTrans];
	[self refreshTrans];

	//Remove it from the array.
	[transArray removeObject:transObj];
	[self refreshTrans];
}

- (void) addTrans:(Trans *)transObj {
	
	//Add it to the database.
	[transObj addTrans];
	
	//Add it to the contact array.
	[self refreshTrans];
		
}

- (void) saveTrans {
	[self.transArray makeObjectsPerformSelector:@selector(saveAllData)];
    [self refreshTrans];
}

- (void) refreshTrans {
	//Initialize the contact array.
	if ([transArray retainCount] <= 1){
		[transArray retain]; //kc0106
	}
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.transArray = tempArray;
	[tempArray release];
	//Once the db is copied, get the initial data to display on the screen.
	[Trans getInitialDataToDisplay:[self getDBPath]];
}
//****************************************Trans*******************************************************************

@end
