//
//  DetailTransViewController.h
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trans, EditTransViewController, TransViewController;

@interface DetailTransViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate,  UITabBarControllerDelegate  > {
	
	
	IBOutlet UITableView *tableView;
	Trans *transObj;
	NSIndexPath *selectedIndexPath;
	EditTransViewController *evController;
	TransViewController *rootController;
	
}

@property (nonatomic, retain) Trans *transObj;


@end

