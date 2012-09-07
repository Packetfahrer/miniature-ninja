//
//  CustomerFirstViewController.h
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
@class TranViewController;


@interface CustomerFirstViewController : UIViewController{
	CustomerAppDelegate *appDelegate;
    
    RootViewController *rtController;
    TranViewController *tvController;
    
    UINavigationController *addNavigationController;
    
}

- (IBAction) viewContacts: (id) sender;
- (IBAction) viewTransactions: (id) sender;


@end
