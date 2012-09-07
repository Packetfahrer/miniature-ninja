//
//  CustomerAppDelegate.h
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//


#import <UIKit/UIKit.h>

@class Contact;
@class Trans;


@interface CustomerAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    UIWindow *window;
    UITabBarController *tabBarController;
	
    //To hold a list of Contact objects
	NSMutableArray *contactArray;
    
    //To hold a list of Transaction objects
	NSMutableArray *transArray;
    
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSMutableArray *contactArray;
@property (nonatomic, retain) NSMutableArray *transArray;


- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

- (void) removeContact:(Contact *)contactObj;
- (void) saveContact;
- (void) addContact:(Contact *)contactObj;
- (void) refreshContact;

- (void) removeTrans:(Trans *)transObj;
- (void) saveTrans;
- (void) addTrans:(Trans *)transObj;
- (void) refreshTrans;


@end
