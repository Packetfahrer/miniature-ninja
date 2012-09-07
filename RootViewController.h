//
//  RootViewController.h
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//
#import <UIKit/UIKit.h>

@class DetailViewController;
@class RootViewController;
@class Contact;
@class AddViewController;





@interface RootViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tabView;

	IBOutlet UINavigationBar *navigationBar;
	CustomerAppDelegate *appDelegate;
	RootViewController *rootViewController;
    AddViewController *adController;

	DetailViewController *dvController;
 	UINavigationController *addNavigationController;
	//kc11192009	Tab1Controller *tab1;

}

//kc 11292009 @property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

- (IBAction) addContact: (id) sender; 

@end
