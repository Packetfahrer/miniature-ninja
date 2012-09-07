//
//  TranViewController.h
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailTransViewController;
@class TranViewController;
@class Trans;
@class AddTransViewController;





@interface TranViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tabView;
    
	IBOutlet UINavigationBar *navigationBar;
	CustomerAppDelegate *appDelegate;
	TranViewController *tranViewController;
    AddTransViewController *acController;
    
	DetailTransViewController *dvController;
 	UINavigationController *addNavigationController;
	//kc11192009	Tab1Controller *tab1;
    
}

//kc 11292009 @property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

- (IBAction) addTrans: (id) sender; 

@end
