//
//  DetailViewController.h
//  PartyTwacker
//
//  Created by Kevin Collins on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact, EditViewController, RootViewController;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate,  UITabBarControllerDelegate  > {
	
	
	IBOutlet UITableView *tableView;
	Contact *contactObj;
	NSIndexPath *selectedIndexPath;
	EditViewController *evController;
	RootViewController *rootController;
	
}

@property (nonatomic, retain) Contact *contactObj;


@end
